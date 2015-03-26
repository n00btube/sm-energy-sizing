# sm-energy-sizing

Changes to how much energy E-Tanks and Reserve Tanks grant at pickup in Super
Metroid.

Uses free space in bank 84, since it has to add code to the tanks’ PLMs.

# Bonus Hex Tweak

## No current energy gained at pickup

    20973 - C2 09 to 06 0A

(All numbers in hex, for an unheadered ROM.)

It stores Samus’ max energy to the current-energy _mirror,_ leaving actual current energy unchanged.
The HUD routine then sees “energy differs from the mirror,” and updates the display.

Samus still gets the capacity increase, but that’s it.  No free energy.

# Patches

## Single Tank Increase at Pickup

Instead of a complete refill, regular energy tank pickups only add one tank worth to Samus’s current energy.

This patch is named `single-tank` and uses free space at $84:FFF0.

## Reserve Tanks Aren’t Empty at Pickup

There are two options rolled into this patch.
In both cases, nstead of reserve tanks being completely empty, they will contain energy.
The only question is, how much?

1. Default: reserve tanks have exactly one tank of energy in them.
If Samus has 25 of 200 reserve and collects a tank, she’ll have 125 of 300 reserve afterward.
Just like how regular E-tanks work with the `single-tank` patch.
2. Optional mod (see asm file for instructions): reserve tanks completely fill reserve energy.
If Samus has 25 of 200 reserve and collects a tank, she’ll have 300 of 300 reserve afterward.
Just like how regular E-tanks work in the original game.

This patch is named `reserve` and uses free space at $84:FFE0.

# Applying

I keep forgetting how to xkas, so just to remind myself…

For xkas 06:

    xkas patchfile.asm unheadered.sfc

For xkas 14:

    xkas -o unheadered.sfc patchfile.asm [more asms...]

Although I don’t use that myself, so I got rid of the xkas14 patches in here.
I don’t want to break things inadvertently.

# Author

[Adam](https://github.com/n00btube) standing on the shoulders of Kejardon,
and anyone who wrote patches in asm format for xkas.

It turns out that the ‘single tank increase’ patch duplicates a patch by
Crashtour99.  Oops, I should check metconst before writing things.

# License

MIT.  If it breaks, you get to keep the pieces.
