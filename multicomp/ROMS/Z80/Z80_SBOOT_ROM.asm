;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Special Boot ROM for NASCOM-NG aka NASCOM 4
;;;
;;; foofoobedoo@gmail.com
;;;
;;; The Special Boot ROM (SBR) is used to customise the system. For example, to
;;; load images into RAM from SDcard and then write-protect them so that they
;;; look like ROM. It is 1Kbytes in size. When enabled, it is decoded at address
;;; $1000. When enabled from reset, it is decoded for the first 3 reads, which
;;; are expected to be "JP $1003", just like a NASCOM ROM that supports the
;;; NASCOM jump-on-reset

STMON:  EQU     $0d


SBSTART:
        org     $1000
        jp      REENTER         ;power-on-reset jump
REENTER:ld      sp, $1000       ;like NAS-SYS
        call    STMON           ;initialise NAS-SYS

        ld      a,9             ;NAS-SYS, NASCOM video
        ld      hl,$0000        ;restart NAS-SYS
        jr      EXIT

        halt
        halt
        halt
        halt


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


;;; pad ROM to 1Kbytes.
SIZE:   EQU $ - SBSTART
PAD1:   EQU $1400 - SIZE
        DS  PAD1, $ff

	END
