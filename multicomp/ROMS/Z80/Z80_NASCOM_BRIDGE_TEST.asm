;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; code for testing the bridge

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
;;; I/O ports VFC
VIDMAP: EQU     $ee             ;write any data, select 80-col VFC output
VIDNAS: EQU     $ef             ;write any data, select 48-col NASCOM output

;;; SDcard commands
SDWR:   EQU     $1
SDRD:   EQU     $0

;;; Menu size (offset to profile 0)
POFFSET: EQU     $8

SBSTART:
        org     $1000
        jp      REENTER         ;power-on-reset jump

;;; Entry point after reset. No stack, and the NASCOM 4 I/O ports are
;;; in an unknown state.
REENTER: ld     sp,$1000
        ld      a,$13
        ld      i,a             ;interrupt table is at $13E0
        im      2               ;vectored interrupts


        ;; now that I have a test-bench with external memory, do some
        ;; external reads and writes
        ld      hl,$7000
        ld      b, 8
FILL:   ld      (hl),b
        inc     hl
        djnz    FILL

        ld      b, 8
RDBK:   ld      a,(hl)          ;TB memory only has 8 locations so address wraps
        inc     hl
        djnz    RDBK


        ;; I thought I could just cycle around the ports in address order but
        ;; it turns out that's a bad idea. First thing I hit is the Port 0 NMI
        ;; bit and take an NMI that takes me into an uninitialised NAS-SYS. OK,
        ;; start simple: for now, all I need is to target the ports that I care
        ;; about..

        ;; PIO port 4 A data
        ;;          5 B data
        ;;          6 A ctrl
        ;;          7 B ctrl

        ;; set up interrupt vectors for the PIO and CTC
        ld      a, $20
        out     (6), a          ;interrupt vector channel A
        ld      a, $22
        out     (7), a          ;                 channel B
        ld      a, $24
        out     ($a), a         ;interrupt vector channel A
        ld      a, $26
        out     ($b), a         ;                 channel B

        ei                      ;enable interrupts

        ld      a,  $55
        out     (4), a          ;PIO data port (LSB=1 triggers interrupt after 200 cycles)
        inc     a
        out     (4), a          ;interrupt back to 0

        out     (8), a          ;CTC data port (LSB=0 so no interrupt)
        inc     a
        out     ($e0), a        ;FDC
        inc     a
        out     ($e1), a        ;FDC
        inc     a
        out     ($e2), a        ;FDC
        inc     a
        out     ($e3), a        ;FDC
        inc     a
        out     ($e4), a        ;Drive select register
        inc     a
        out     ($e5), a        ;NOT directed to the bridge
        inc     a


PLOP:   in      a, (4)          ;PIO
        in      a, (8)          ;CTC
        in      a, ($e0)        ;FDC
        in      a, ($00)        ;KBD
        in      a, ($e4)        ;NOT directed to the bridge

        ld      a, 0edh         ;code sequence that looks like RETI but isn't M1 (code)
        ld      c, l

        ;; Some instructions that have a $ED prefix, like RETI
        ;; (also "ld i, a" above).
        neg
        neg
        ld      a, r

        ;; Code sequence that ends with a RETI
        call    PISR

        nop
        nop
        nop

        ;;  wait for interrupt
ENDLS:  halt
        jr      ENDLS



        ;; Pretend ISR - subroutine that returns using RETI - naughty! But just for
        ;; Quality and Training purposes..
PISR:   ld      a, $12
        ld      hl, $3456
        reti                    ;$ED $4D

        ;; ISR that takes control after vectored interrupt
ISR:    nop
        nop
        nop
        reti


;;; the assembler doesn't seem to like generating binary for non-consecutive regions,
;;; so need to pad to $1300 then put the vector table then pad to end - simply using
;;; ORG here silently fails
S2:     EQU $ - SBSTART
P2:     EQU $1300 - S2
        DS P2, $00


;;; Vector table at $1300. There's nothing to provide a vector, and the CPU will read 00
;;; so it will end up going to address $1300

VECT:   DW      ISR

;;; pad ROM to 1Kbytes.
SIZE:   EQU $ - SBSTART
PAD1:   EQU $1400 - SIZE
        DS  PAD1, $ff

;;; End.
