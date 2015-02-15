// By [n00btube](https://github.com/n00btube) aka Adam, February 2015.

arch snes.cpu
lorom

// IMPORTANT ADDRESSES:
// 7E:09C2 - current energy
// 7E:09C4 - max energy
// 84:8968 - where the energy tank PLM changes Samus's energy
// 84:E0B8 - size of a regular energy tank
// 84:EFD3-FFFF - free space we're going to park code in

// the normal fill routine calculates new max energy, then issues a pair of
// STA $09Cx instructions to write to both max and current.  The instructions
// are 3 bytes, so we can replace the second one with a JSR to our new current
// energy calculation, then RTS back without issue, and leave the rest of the
// routine in place.

// Address of existing instruction (part of the block starting at 84:8968)
// I guess if you wanted empty e-tanks, you could write EA EA EA in here to
// replace the STA with NOPs, and you don't need ASM at all for that.
org $848972
JSR add_single_tank // hijack existing code


// This is an address you can move around the free space here as desired,
// you just need 11 bytes ($0B bytes) of room for it.
org $84FFF0

// add single tank routine
add_single_tank:
LDA $09C2    // load current health
// this add re-uses the value that was loaded earlier in the routine, as Y
// hasn't been changed since then.
CLC
ADC $0000,y  // add value from 0 bytes after Y register
STA $09C2    // save back to current health
RTS          // done.

