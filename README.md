# sm-energy-sizing

Changes to how much energy E-Tanks and Reserve Tanks add to Samus’ current
levels when picked up in Super Metroid.  Also, a bonus patch changes the
effective size of a reserve tank in the display.

Uses free space in bank 84, since it has to add code to the tanks’ PLMs.
Designed for unheadered ROMs.

# Patch Generator / Energy gains when picking up the items

I got more ideas, and instead of spraying the repo with patches (or the patch files with options), I made you a program that generates patches.

You’ll need Python for this to work.
It’s _meant_ to work in Python 2.6+ but is only tested on Python 3.4.

Run `patch-generator.py` and if everything went well, you’ll get two menus.
One with a set of options for E-tank behavior, and one for reserve tanks.
Then, an `energy-reserve-mods.asm` file is spit out into the current directory with exactly the combo of options you’ve chosen.

Compared to the plain ASM files, there are new options for having each kind of tank refill _both_ kinds of energy.
It’s not that it would be hard to mod the patch files;
it’s that I didn’t want to write long-winded directions on how do that in each file.

## Bonus hex tweak: No current energy gained at pickup

    20973 - C2 09 to 06 0A

(All numbers in hex, for an unheadered ROM.)

It stores Samus’ max energy to the current-energy _mirror,_ leaving actual current energy unchanged.
The HUD routine then sees “energy differs from the mirror,” and updates the display.

Samus still gets the capacity increase, but that’s it.  No free energy.

This hex tweak can now be incorporated in the patch generator’s output, too.

## Original patch: Single Tank Increase at Pickup

Instead of a complete refill, regular energy tank pickups only add one tank worth to Samus’s current energy.

This patch is named `single-tank` and uses free space at $84:FFF0.

## Original patch: Reserve Tanks Aren’t Empty at Pickup

There are two options rolled into this patch, named `reserve`.
In both cases, nstead of reserve tanks being completely empty, they will contain energy.
The only question is, how much?

1. Default: reserve tanks have exactly one tank of energy in them.
If Samus has 25 of 200 reserve and collects a tank, she’ll have 125 of 300 reserve afterward.
Just like how regular E-tanks work with the `single-tank` patch.
2. Optional mod (see asm file for instructions): reserve tanks completely fill reserve energy.
If Samus has 25 of 200 reserve and collects a tank, she’ll have 300 of 300 reserve afterward.
Just like how regular E-tanks work in the original game.

This patch is named `reserve` and uses free space at $84:FFE0.

# Reserve Tank Display Size

This patch, `reserve-size`, changes the displayed size of reserve tanks in the
equipment screen.  The original game draws 100 reserve energy == 1 box, and if
you change the pickup amount in SMILE to something different, like 180, the
display shows more than 1 tank when Samus has exceeded 100 reserve energy.
Until Samus has more than 200 capacity, the display _won’t_ show the second
tank outlined-but-empty while her current levels are 100 or less.

With the display-size patch, the drawing is changed so that each block on the
display contains a configurable amount of energy (see `!newsize` in the
patch.)  It doesn’t fix any issues when the pickup value and tank size are
mismatched, though.

Some free space in bank $82 is used to separate division to find “number of
tanks to draw” from the division to find the digits to display.

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
