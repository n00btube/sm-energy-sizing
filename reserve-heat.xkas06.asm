; By [n00btube](https://github.com/n00btube) aka Adam, April 2015.
; MIT license.
; There _may_ be a newer version on the GitHub.

lorom

; While Samus is getting her reserve->main tank transfer, the game pauses, but
; heat damage still happens.  UNTIL NOW.
; Seriously, if the enemies are frozen, and Samus is floating, why isn't heat
; damage stopped?  Like it is when she's actively standing around XRaying?

; Main hijack point: heat-damage code.  Called from heat-glow code.
org $8DE381
	; originally, these damage values get *added* to $0A4E/$0A50 and thus
	; accumulate while reserve-fill is happening.  We change them to a store,
	; so the reserve-fill happens on "one frame" as far as heat damage goes.
	; In normal gamestate, heat damage is checked (+zeroed) every frame.
	LDA #$4000 ; sub-health damage per frame = 1/4
	STA $0A4E  ; store
	STZ $0A50  ; whole-health damage per frame = 0
	JMP $E394  ; skip to original code following what we just overwrote

