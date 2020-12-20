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

;;; NAS-SYS entry point for initialisation
STMON:  EQU     $0d

;;; NAS-SYS restarts
RIN:    EQU     $8
ROUT:   EQU     $30

;;; NAS-SYS SCAL codes
ZMRET:  EQU     $5b
ZTBCD3: EQU     $66
ZCRLF:  EQU     $6a
ZERRM:  EQU     $6b

;;; Macro for using SCAL
SCAL:   MACRO FOO
        RST 18H
        DB FOO
        ENDM

;;; NAS-SYS workspace
ARGN:   EQU     $0c0b
ARG1:   EQU     $0c0c
ARG2:   EQU     $0c0e
ARG3:   EQU     $0c10
ARG4:   EQU     $0c12

;;; 512 byte buffer for loading menu and profile data. Image data is
;;; moved directly from the SDcard to its destination address.
BUFFER: EQU     $c80

;;; I/O ports
REMAP:  EQU     $03
SDDATA: EQU     $10
SDCTRL: EQU     $11
SDLBA0: EQU     $12
SDLBA1: EQU     $13
SDLBA2: EQU     $14

;;; SDcard commands
SDWR:   EQU     $1
SDRD:   EQU     $0

;;; Menu size (offset to profile 0)
POFFSET:EQU     $8

SBSTART:
        org     $1000
        jp      REENTER         ;power-on-reset jump
        jp      CSUM            ;portable entry point to CSUM utility
        jp      SD2MEM          ;portable entry point to SD2MEM utility

REENTER:ld      sp,$1000        ;like NAS-SYS
        call    STMON           ;initialise NAS-SYS

        in      a,(REMAP)       ;get bootmode

;;; TODO one of the bootmode codes will mean "go and start profile 0"
;;; and another will mean "start the menu". For now, we always start
;;; the menu.

;;; Load and display menu. Menu starts at block 0 and can be xple
;;; blocks. It is terminated with a 0. Assume it is well-formed
;;; and so keep incrementing block numbers until we get a "0".

        xor a
        out     (SDLBA2),a      ;high block address is ALWAYS 0

        ld      d,a             ;d=0
        ld      e,a             ;e=0 - start at block 0
MENNXT: ld      hl,BUFFER
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
        sub     'A'-POFFSET

;;; Load profile into memory buffer
        ld      d,0
        ld      e,a
        ld      hl,BUFFER
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
GCMD:   ld      a,c             ;data
        jr      EXIT            ;go and never come back

;;; Load image
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
;;; This requires execution of an "OUT" then a "JP" but we can't execute the OUT
;;; from ROM or it will disappear from under our feet. Portable solution: build
;;; a code fragment on the stack, then jump to it.
;;;
;;; entry: A  contains the value to be output to port 3
;;;        HL contains the destination address
;;; exit:  Never returns. Continues execution at HL
;;;
;;; For a destination of DH, DL (destination high,low bytes) the code fragment
;;; looks like this:
;;; d3 03      OUT (3), A
;;; c3 DL DH   JP DHDL
;;; xx         ??
;;;
;;; the trailing xx is not executed; building code on the stack means
;;; that it has to be an even number of bytes. Use "PUSH BC", to put
;;; stuff on the stack: C goes in the low address, B in the high.

OPOUT:  EQU     $d3             ; OUT (n), A
OPJP:   EQU     $c3             ; JP nnnn

EXIT:   ld      c, h
        push    bc              ; DH xx
        ld      b, l
        ld      c, OPJP
        push    bc              ; JP DL
        ld      b, 3            ; Port 3
        ld      c, OPOUT
        push    bc              ; OUT (3) A

        ;; jump to code fragment at SP -- is there a simpler way?
        ;; assumption is that the stack will be re-initialised by
        ;; the destination code.
        or      a               ; clear carry
        ld      h, 0
        ld      l, 0
        adc     hl, sp
        jp      (hl)            ; go and never come back


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
        pop     af
        push    bc              ;store argument 1
        push    af              ;keep AF at TOS
        call    GETARG          ;argument 2 is in BC (may be invalid)

        pop     af              ;restore command letter
        inc     hl              ;point to start of next command
        ex      de,hl           ;now DE addresses the buffer
        pop     hl              ;argument 1
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
        jr      z, GA1          ;no argument

        inc     hl              ;point past command/delimiter
        ld      bc,0            ;accumulate argument in BC

        ;; if it's ' ' or '=', we're done (well-formed input guarantees
        ;; this will not be true first time through
GETDIG: ld      a,(hl)          ;get it and don't point past (in case we're done)
        cp      ' '
        jr      z, GA1
        cp      '='
        jr      z, GA1

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

GA1:    ret


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read 512 bytes from SDcard to memory buffer.
;;;
;;; entry: DE block number (assume upper 8 bits has already been loaded with 0)
;;;        HL destination address
;;; exit:  DE unchanged
;;;        HL incremented by 512
;;;        AF corrupted
;;;

SDRD512:push    de
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

        ld      b,0             ;0==256
        ;; get first 256 bytes
SDWAIT1:in      a,(SDCTRL)      ;get status
        cp      $E0             ;read data available
        jr      nz, SDWAIT1
        in      a,(SDDATA)
        ld      (hl),a
        inc     hl
        djnz    SDWAIT1
        nop                     ;only here to allow debug/breakpoint
        ;; get second 256 bytes (b=0 == 256)
SDWAIT2:in      a,(SDCTRL)      ;get status
        cp      $E0             ;read data available
        jr      nz, SDWAIT2
        in      a,(SDDATA)
        ld      (hl),a
        inc     hl
        djnz    SDWAIT2
        pop     bc
        pop     de
        ret

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Command-line utility: Calculate checksum of memory region
;;;
;;; E 1003 ssss eeee
;;;
;;; Compute checksum of memory from ssss to eeee inclusive.
;;; Checksum is the sum of all bytes and is reported as a
;;; 16-bit value. Carry off the MSB is lost/ignored.
CSUM:   ld      de,EARG
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

        SCAL    ZTBCD3          ;print hl
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

SD2MEM: ld      de,EARG
        ld      a,(ARGN)
        cp      4               ;expect 4 arguments
        jp      nz, MEXIT
        ;; in case it's never been done
        xor     a
        out     (SDLBA2),a      ;high block address is ALWAYS 0

        ld      hl,(ARG2)       ;destination
        ld      de,(ARG3)       ;block number
        ld      bc,(ARG4)       ;block count
        ld      b,c             ;block count low 8 bits in B
SD1:    call    SDRD512
        inc     de
        djnz    SD1
        jr      MEX1            ;done


EARG:   DB "Wrong number of arguments",0

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

MEX1:   SCAL    ZCRLF
        SCAL    ZMRET


;;; pad ROM to 1Kbytes.
SIZE:   EQU $ - SBSTART
PAD1:   EQU $1400 - SIZE
        DS  PAD1, $ff

	END
