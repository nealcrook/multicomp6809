;;;
;;; Special Boot ROM for NASCOM-NG aka NASCOM 4
;;;
;;; foofoobedoo@gmail.com
;;;
;;; The Special Boot ROM (SBR) is 1Kbytes in size. When enabled,
;;; it is decoded at address 0. When enabled from reset, it is
;;; decoded for the first 3 reads - which are required to be a
;;; jump.

STMON:  EQU     $0d


SBSTART:
        org     $1000
        jp      REENTER         ;power-on-reset jump
REENTER:ld      sp, $1000       ;like NAS-SYS
        call    STMON           ;initialise NAS-SYS

        halt                    ;for now! Just proof of concept.

;;; pad ROM to 1Kbytes.
SIZE:   EQU $ - SBSTART
PAD1:   EQU $1400 - SIZE
        DS  PAD1, $ff

	END
