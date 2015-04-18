; By [n00btube](https://github.com/n00btube) aka Adam, April 2015.
; MIT license.
; There _may_ be a newer version on the GitHub.

lorom

; New reserve tank size value.
; Limitation: make sure you don't place so many tanks in your hack that
; picking up all the reserves gives Samus >=1000 ($3E8) reserve energy total,
; or you'll glitch the 100s digit.
; Caution: this needs to fit in one byte, do not exceed 255 ($FF).
!newsize = #200


; Hijackings: where the game divides the current or max reserve energy by $64
; to draw its reserve boxes.  We don't want to mess up the number draw.
org $82B2C1
	DB !newsize ; conversion of max reserves to number of box outlines to draw

org $82B2D3
	JSR setup_digits ; hijack: current reserves to full/partial tanks+digits
	; (to do digits separately from full/partial tanks)
	; we need to leave the partial-tank result in the divide register,
	; so this hijack for the digits comes first.
org $82B2DC
	DB !newsize ; conversion of current reserves to full/partial tanks
org $82B2E9
	BRA $03    ; already wrote $32
org $82B2F1
	NOP : NOP  ; already wrote $2A

org $82B320
	DB $23    ; conversion of partial tank to 0-7px range
org $82B34A
	DB !newsize ; CMP argument, X += $10 if current reserve exceeds value

; Place anywhere in bank $82 free space
org $82FFD0
setup_digits:
	LDA $09D6   ; current reserves
	STA $4204
	SEP #$20
	LDA #$64    ; /100
	STA $4206
	REP #$20
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	LDA $4216
	STA $32     ; remainder (10s/1s divided out later)
	LDA $4214
	STA $2A     ; hundreds digit
	LDA $09D6   ; reload current reserves for tank-size division
	RTS

