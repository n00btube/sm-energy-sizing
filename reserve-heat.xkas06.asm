; By [n00btube](https://github.com/n00btube) aka Adam, April 2015.
; MIT license.
; There _may_ be a newer version on the GitHub.

lorom

; While Samus is getting her reserve->main tank transfer, the game pauses, but
; heat damage still happens.  UNTIL NOW.
; Seriously, if the enemies are frozen, why isn't heat frozen?

; Main hijack point: heat-damage code.  Called from heat-glow code.
; I didn't walk back up the call stack, maybe reserve-tank state ($0998=$1B)
; could just skip calling heat-glow stuff instead of this minimal approach?
org $8DE37C
	JSR heat_exemption
	BCC $2A ; change condition from BNE to something handier

; This bank is full; this is the start of the free space... Oof.
org $8DFFF0
heat_exemption:
	JSL real_heat_exemption
	RTS

; Free space we have room to work in (anywhere in the ROM, because JSL/RTL.)
org $8CFFE0
real_heat_exemption:
	AND #$0021    ; varia/gravity check (change to 0001 for just varia)
	BNE no_damage ; immune to damage

	LDA $0998     ; game state
	AND #$00FF    ; ignore $0999
	CMP #$001B    ; auto reserve is transferring energy?
	BEQ no_damage ; if so, don't accumulate env. damage

	SEC
	RTL

no_damage:
	CLC
	RTL
