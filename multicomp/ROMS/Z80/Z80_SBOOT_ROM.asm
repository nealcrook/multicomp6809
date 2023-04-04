;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Special Boot ROM for NASCOM-NG aka NASCOM 4
;;;
;;; foofoobedoo@gmail.com 11Dec2020.
;;;
;;; The Special Boot ROM (SBR) is used to customise the system. For example, to
;;; load images into RAM from SDcard and then write-protect them so that they
;;; look like ROM. It is 1Kbytes in size. When enabled, it is decoded at address
;;; $1000. When enabled from reset, it is decoded for the first 3 reads, which
;;; are expected to be "JP $1003", just like a NASCOM ROM that supports the
;;; NASCOM jump-on-reset
;;;
;;; Current function is to:
;;; - display a menu from SDcard
;;; - accept a keypress to select a menu item
;;; - load the profile associated with the selection
;;; - execute the command string in the profile, which will usually involve
;;;   loading one or more images to memory, jumping out of the SBR and disabling
;;;   it from the memory map.
;;;
;;; Eventually want to provide read-only support for FAT32 filesystem on the
;;; SDcard see: https://www.pjrc.com/tech/8051/ide/fat32.html
;;; but for now, just do low-level block access of a data structure created by
;;; the make_sdcard_image utility.
;;;
;;; With thanks to Mike Foster for some code tidy-up and cleaner ways of
;;; doing stuff.

;;; NAS-SYS entry point for initialisation
STMON:  EQU     $0d

;;; NAS-SYS restarts
RIN:    EQU     $8
SCAL:   EQU     $18
ROUT:   EQU     $30

;;; NAS-SYS SCAL codes
ZMRET:  EQU     $5b
ZTBCD3: EQU     $66
ZCRLF:  EQU     $6a
ZERRM:  EQU     $6b

;;; NAS-SYS workspace
ARGN:   EQU     $0c0b
ARG1:   EQU     $0c0c
ARG2:   EQU     $0c0e
ARG3:   EQU     $0c10
ARG4:   EQU     $0c12

;;; When images are loaded, they are copied straight from SDcard to
;;; their destination address. Need block buffer for menu and profile.
;;;
;;; 512 byte buffer for loading menu. Menu blocks are loaded to this
;;; buffer from SDcard and then output via NAS-SYS RST ROUT calls
MBUFF:  EQU     $c80
;;; 512 byte buffer for the selected profile. Profile block is loaded
;;; to this buffer from SDcard and then processed directly. By using
;;; video RAM for this buffer, images loaded by the profile can go
;;; anywhere (previously, used $c80 for the profile which prevented
;;; loading the memory test program, because that loads at $c80)
PBUFF: EQU     $800

;;; I/O ports (special for NASCOM 4)
SDDATA: EQU     $10
SDCTRL: EQU     $11
SDLBA0: EQU     $12
SDLBA1: EQU     $13
SDLBA2: EQU     $14
REMAP:  EQU     $18
PROTECT: EQU     $19
MWAITS: EQU     $1A
PORPAGE: EQU     $1B
REASON: EQU     $1C
SERCON: EQU     $1D
;;; I/O ports VFC
VIDNAS: EQU     $ef             ;read/write any data, select 48-col NASCOM output
VIDMAP: EQU     $ee             ;read/write any data, select 80-col VFC output

;;; SDcard commands
SDWR:   EQU     $1
SDRD:   EQU     $0

;;; Menu size (offset to profile 0)
POFFSET: EQU     $8

SBSTART:
        org     $1000
        jp      REENTER         ;power-on-reset jump
        jp      CSUM            ;portable entry point to CSUM utility
        jp      SD2MEM          ;portable entry point to SD2MEM utility

;;; Entry point after reset. No stack, and some NASCOM 4 I/O ports are
;;; in an unknown state.
REENTER:in     a, (REASON)
        and     $80             ;Cold bit set?
        out     (REASON), a     ;Cold bit is now clear (W1C)
        jr      nz, COLD

        in      a, (REASON)
        and     $40             ;NeverBooted bit set?
        jr      z, WARM

;;; Warm reset after failed boot - assume no SDcard present
;;; and go to NAS-SYS/minimal system
        ld      a,$19           ;remap: WSram/VidRam/Monitor
        ld      hl,$0000
        jp      EXIT

;;; Warm reset. Retain all of the existing NASCOM 4 register state
;;; and the current video output.
WARM:   ld      l,0
        in      a, (PORPAGE)
        ld      h, a            ;where we started last time
        in      a, (REMAP)      ;what was enabled
        and     $fb             ;will disable SBootROM
        jp      EXIT            ;go and never come back

;;; Cold reset. To allow warm reset, some NASCOM 4 ports
;;; are not reset, so start by setting them to a polite state.
;;; and selecting the NASCOM video output.
;;; This path through the code has NO STACK
COLD:   out     (VIDNAS), a     ;select NASCOM video output
        ld      a, $1d
        out     (REMAP), a      ;make NAS-SYS accessible
        xor     a
        out     (PROTECT), a    ;make whole address space writeable
        out     (PORPAGE), a    ;reset to 0 (NAS-SYS)
        ld      a, 7
        out     (SERCON), a     ;serial port at 115200 baud

;;; Initialise stack and NAS-SYS, so that the RST calls are usable
        ld      sp,$1000        ;like NAS-SYS
        call    STMON           ;initialise NAS-SYS

;;; Display version number on top line
        ld      de, VER
        ld      hl, $bca
PUTVER: ld      a, (de)
        or      a
        jr      z, MENU
        ld      (hl), a
        inc     de
        inc     hl
        jr      PUTVER

;;; TODO there will be some auto-cold-start options from
;;; the reason register (from the PS/2 keyboard FN keys).

;;; Load and display menu. Menu starts at block 0 and can be xple
;;; blocks. It is terminated with a 0. Assume it is well-formed
;;; and so keep incrementing block numbers until we get a "0".
MENU:   xor     a
        out     (SDLBA2),a      ;high block address is ALWAYS 0

        ld      d,a             ;d=0
        ld      e,a             ;e=0 - start at block 0
MENNXT: ld      hl,MBUFF
        push    hl
        call    SDRD512         ;read 1st block of menu
        pop     hl              ;point back to start

        ld      b,0
MEN0:   ld      a,(hl)
        cp      0
        jr      z, MENDONE
        rst     ROUT
        inc     hl
        djnz    MEN0            ;upto 256 bytes
MEN1:   ld      a,(hl)
        cp      0
        jr      z, MENDONE
        rst     ROUT
        inc     hl
        djnz    MEN1            ;upto 512 bytes
        inc     de              ;point to next block
        jr      MENNXT          ;read it to buffer

MENDONE:

;;; Get profile selection from user. Profile selection is a letter
;;; A-Z pressed by the user (other keys ignored) and converted to
;;; a number 0-25 in A.
GETPRO: rst     RIN
        cp      'A'
        jr      c, GETPRO       ;too small
        cp      'Z'+1
        jr      nc, GETPRO      ;too big
        sub     'A' - POFFSET

;;; Load profile into memory buffer
        ld      d,0
        ld      e,a
        ld      hl,PBUFF
        push    hl
        call    SDRD512
        pop     hl

;;; Parse and execute commands in memory buffer. Assume that buffer
;;; is well-formed and ends with a G so no need to check for overflow

        ex      de,hl
DOPROF: call    GETCMD          ;now DE=buffer, HL=arg1, BC=arg2
        cp      'W'
        jr      z,WCMD
        cp      'P'
        jr      z,PCMD
        cp      'G'
        jr      z,GCMD
        cp      'I'
        jr      z,ICMD
        cp      'L'
        jr      z,LCMD
        ;; FATAL error
        halt

;;; Memory write: Wxxxx=yyyy
;;; MUST PRESERVE DE
WCMD:   ld      (hl),b
        inc     hl
        ld      (hl),c
        jr      DOPROF

;;; Port write: Pxx=yy
;;; MUST PRESERVE DE
PCMD:   ld      a,c             ;data
        ld      c,l             ;port
        out     (c),a
        jr      DOPROF

;;; Image block: I1234
;;; MUST PRESERVE DE
;;; Prepare for read by storing block start address
ICMD:   push    hl
        jr      DOPROF

;;; Go: G1000=40
;;; HL already has destination address
GCMD:   ld      a, $40
        out     (REASON), a     ;clear NeverBooted
        ld      a,c             ;data
        jr      EXIT            ;go and never come back

;;; Load image: Lxxxx=yyyy
;;; Load yyyy blocks starting at block (specified by most recent I command) to memory
;;; starting at xxxx.
;;; MUST PRESERVE DE
;;; HL=destination address
;;; BC=number of blocks. Guaranteed to be <256, so B=0.
LCMD:   ex      de,hl           ;HL=buffer pointer, DE=destination address
        ex      (sp),hl         ;stacked: buffer pointer, HL=first block
        ex      de,hl           ;HL=destination address, DE=first block

        ld      b,c             ;put block count in B
LCMD1:  call    SDRD512
        inc     de
        djnz    LCMD1
        pop     de              ;restore buffer pointer
        jr      DOPROF

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END of main code. The rest is subroutines
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Exit: disable this ROM and jump to a new location to continue execution.
;;; This requires execution of an "OUT" then a "JP". It should not be possible
;;; to execute the OUT from ROM, because the ROM will disappear from the address
;;; space before the JMP and its arguments can be fetched. However, the logic
;;; that disables the SBootROM has a counter so that the disable does not take
;;; effect straight away, but keeps the ROM enabled until after the JP and its
;;; arguments -- *requires" the particular out/jp sequence below, else the
;;; timing will be incorrect and Bad Things will happen. This routine also
;;; writes the high byte of hl to the PORPAGE register for use in warm reset
;;;
;;; entry: A  contains the value to be output to port REMAP
;;;        HL contains the destination address
;;; exit:  Never returns. Continues execution at HL

EXIT:   ld      c, PORPAGE
        out     (c), h          ;store page for use in warm start
        out     (REMAP), a
        jp      (hl)            ;go and never come back


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read the next command and decode its args
;;;
;;; entry: DE addresses first byte of command
;;; exit:  DE incremented to start of next command
;;;        HL first argument
;;;        BC second argument
;;;        A  command
;;;
;;; example:  W1234=5678 IABDC L4000=8
;;;           ^-DE
;;; After 1st call, A='W', DE points to I, HL=1234, BC=5678
;;; After 2nd call, A='I', DE points to L, HL=ABDC, BC undefined
;;; Arguments are 1-4 hex digits (upper-case letters)
;;; Argument is ended by space or =
;;; There is a space after the last command

GETCMD: ex      de,hl           ;now HL addresses the buffer
        ld      a,(hl)
        push    af              ;command letter
        call    GETARG          ;argument 1 is in BC
        pop     af              ;restore command letter
        push    bc              ;store argument 1
        push    af              ;keep AF at TOS
        call    GETARG          ;argument 2 is in BC (may be invalid)

        pop     af              ;restore command letter
        inc     hl              ;point to start of next command
        ex      de,hl           ;now DE addresses the buffer
        pop     hl              ;argument 1 (from bc)
        ret


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read the next numeric argument and return it as a 16-bit number
;;;
;;; entry: HL addresses byte before argument
;;; exit:  HL incremented to delimiter (see examples)
;;;        BC argument
;;;        AF corrupted
;;;
;;; Called twice per command
;;; example:  W1234=5678 IABDC L4000=8
;;;           ^b1  ^a1  ^a2
;;; Before 1st call, HL points to b1. After, it points to a1 and BC=1234
;;; Before 2nd call, HL points to a1. After, it points to a2 and BC=5678
;;;
;;; example:  W1234=5678 IABDC L4000=8
;;;                      ^b1  ^^a1,a2
;;; Before 1st call, HL points to b1. After, it points to a1 and BC=1234
;;; Before 2nd call, HL points to a1. After, it is incremented to a2, BC=undefined
;;;
;;; Algorithm: if initial symbol is a ' ', there is no argument
GETARG:
        ld      a,(hl)
        cp      ' '
        ret     z               ;no argument -> we're done.

        inc     hl              ;point past command/delimiter
        ld      bc,0            ;accumulate argument in BC

        ;; if it's ' ' or '=', we're done (well-formed input guarantees
        ;; this will not be true first time through)
GETDIG: ld      a,(hl)          ;get it and don't point past (in case we're done)
        cp      ' '
        ret     z               ;we're done.
        cp      '='
        ret     z               ;we're done.

        ;; must be 0-9 or A-F, accumulate it: convert to number, shift bc left
        ;; 4 bits, merge value in, then go back for more.

        sla     b               ;shift B to discard existing high nibble; set low
        sla     b               ;nibble to 0
        sla     b
        sla     b

        ld      a,c             ;get the high nibble from C that's going to be
        rrca                    ;the new low nibble in B
        rrca
        rrca
        rrca
        and     $0f             ;clear out shifted Carry flag
        or      b               ;merge nibbles
        ld      b,a             ;and put in B

        sla     c               ;shift C moving low nibble to high position
        sla     c               ;and leaving 0 in low nibble
        sla     c
        sla     c

        ld      a,(hl)          ;restore the new digit we're considering

        ;; ASCII 0-9 is 0x30-0x39
        ;; ASCII A-F is 0x41-0x46

        sub     $30             ;0-9 or $11-$16
        cp      10
        jr      c, GA2          ;it's 0-9
        sub     7               ;it was $11-$16, now A-F

GA2:    or      c
        ld      c,a             ;merge into C

        inc     hl
        jr      GETDIG          ;go back for more


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read 512 bytes from SDcard to memory buffer.
;;;
;;; entry: DE block number (assume upper 8 bits has already been loaded with 0)
;;;        HL destination address
;;; exit:  DE unchanged
;;;        HL incremented by 512
;;;        AF corrupted
;;;

SDRD512: push   de
        push    bc

;;; Didn't need this in 6809 code but, in Z80 code, without this
;;; it sometimes reads an extra byte when this routine is called
;;; in a loop - but not when I breakpoint after each iteration of
;;; the loop. Would need to add observation for external scope to
;;; understand what's going on here; don't have an adequate tb
;;; representation of the SDcard to simulate this scenario.
SDINIT: in      a,(SDCTRL)
        cp      $80
        jr      nz, SDINIT      ;wait until SDcard is ready

        ld      a,d
        out     (SDLBA1),a
        ld      a,e
        out     (SDLBA0),a
        xor     a               ;A=0
        out     (SDCTRL),a      ;READ

        ld      b,a             ;0==256
        call    SDWAIT          ;get first 256 bytes
        ;; b=0 after first call so all ready to..
        call    SDWAIT          ;get second 256 bytes
        pop     bc
        pop     de
        ret

SDWAIT: in      a,(SDCTRL)      ;get status
        cp      $E0             ;read data available
        jr      nz, SDWAIT
        in      a,(SDDATA)
        ld      (hl),a
        inc     hl
        djnz    SDWAIT
        ret


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Command-line utility: Calculate checksum of memory region
;;;
;;; E 1003 ssss eeee
;;;
;;; Compute checksum of memory from ssss to eeee inclusive.
;;; Checksum is the sum of all bytes and is reported as a
;;; 16-bit value. Carry off the MSB is lost/ignored.
CSUM:   ld      de,EARG         ;set de to error message in case needed
        ld      a,(ARGN)
        cp      3               ;expect 3 arguments
        jp      nz, MEXIT

        call    E2LEN           ;hl=start, bc=count
        ld      d,0
        ld      e,d             ;accumulate in de

C1:     ld      a,b             ;is byte count zero?
        or      c
        jr      z,CDONE         ;if so, we're done

        ld      a,e             ;get lo accumulator
        add     a,(hl)          ;add next byte
        jr      nc,C2
        inc     d               ;carry to hi accumlator
C2:     ld      e,a             ;store lo accumulator
        inc     hl              ;next byte
        dec     bc
        jr      C1              ;loop

CDONE:  ld      h,d             ;move sum from de to hl
        ld      l,e

        rst     SCAL
        defb    ZTBCD3          ;print hl
        jr      MEX1

;;; End-To-Length: start address in (ARG2), end address in (ARG3).
;;; Exit with HL=start, BC=byte count.
;;; corrupts: AF
E2LEN:  ld      de,(ARG2)       ;start address
        ld      hl,(ARG3)       ;end address
        ;; compute end - start + 1
        or      a               ;clear carry flag
        sbc     hl,de
        inc     hl              ;byte count in hl
        ld      b,h
        ld      c,l             ;byte count in bc

        ld      hl,(ARG2)       ;start address in hl
        ret

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Command-line utility: read data from SDcard to memory
;;;
;;; E 1006 dddd bbbb nn
;;;
;;; dddd - destination address
;;; bbbb - block address on SDcard
;;; nn   - number of blocks (512-bytes per block)

SD2MEM: ld      de,EARG         ;point de to error in case needed
        ld      a,(ARGN)
        cp      4               ;expect 4 arguments
        jp      nz, MEXIT
        ;; in case it's never been done, make sure sdlba2=0
        xor     a
        out     (SDLBA2),a      ;high block address is ALWAYS 0

        ld      hl,(ARG2)       ;destination
        ld      de,(ARG3)       ;block number
        ld      bc,(ARG4)       ;block count
        ld      b,c             ;block count low 8 bits in B
SD1:    call    SDRD512
        inc     de
        djnz    SD1             ;loop then fall-through at end

;;; clean return to NAS-SYS
MEX1:   rst     SCAL
        defb    ZCRLF
        rst     SCAL
        defb    ZMRET

;;; Exit with message. Can be used for successful or error/fatal
;;; exit. (DE) is null-terminated string (possibly 0-length).
;;; Print string then CR then return to NAS-SYS.
;;; Come here by CALL or JP/JR -- NAS-SYS will clean up the
;;; stack if necessary.
MEXIT:  ld      a,(de)
        or      a
        jr      z, MEX1
        rst     ROUT
        inc     de
        jr      MEXIT

EARG:   DB "Wrong number of arguments",0

VER:    DB "Rev1.4 04Apr2023",0

;;; pad ROM to 1Kbytes.
SIZE:   EQU $ - SBSTART
PAD1:   EQU $1400 - SIZE
        DS  PAD1, $ff

;;; End.
