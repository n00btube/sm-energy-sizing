; By [n00btube](https://github.com/n00btube) aka Adam, February 2015.
; MIT license.
; There _may_ be a newer version on the GitHub.

lorom

; IMPORTANT ADDRESSES:
; 7E:09D4 - max reserve tank energy
; 7E:09D6 - current reserve tank energy
; 84:8986 - where the reserve tank PLM changes Samus's energy
; 84:E909 - size of a reserve tank
; 84:EFD3-FFFF - free space we're going to park code in

; the normal routine calculates the fresh size of a reserve tank, then carries
; on without leaving us room to mod anything.  So, we'll overwrite its STA
; with a JSR and then put the STA as our first instruction.  Both the STA and
; JSR are 3 bytes so that everything lines up perfectly.

; Address of existing instruction (part of the block starting at 84:8968)
org $84898D
JSR hijack_reserve


; This is an address you can move around the free space here as desired,
; you just need 14 bytes ($0E bytes) of room for it.
; 7 bytes ($07 bytes) if you take out the optional section.
org $84FFE0

; add single tank routine
hijack_reserve:
STA $09D4    ; instruction we overwrote, increase capacity

; OPTIONAL: ---------------------------------------
; If you leave this section IN: reserves will have exactly one tank's worth of
; energy.  Best combined with single-tank.xkas06.asm.
; If you delete this section: reserves will completely fill when collecting a
; reserve tank, just like how E-tanks work in the original game.
LDA $09D6    ; load current reserves
; this add re-uses the value that was loaded earlier in the routine, as Y
; hasn't been changed since then.
CLC
ADC $0000,Y  ; add value from 0 bytes after Y register (reserve tank size)
; END OPTIONAL SECTION ----------------------------

STA $09D6    ; save back to current reserves
RTS          ; done.

