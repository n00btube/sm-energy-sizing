# sm-energy-sizing

Changes to how much energy E-Tanks and Reserve Tanks grant at pickup in Super
Metroid.

Uses free space in bank 84, since it has to add code to the tanks’ PLMs.

# Bonus Hex Tweak

## No current energy gained at pickup

    20973 - C2 09 to 06 0A

(All numbers in hex for an unheadered ROM.)

It stores Samus’ max energy to the current-energy _mirror,_ leaving actual current energy unchanged.
The HUD routine then sees “energy differs from the mirror,” and updates the display.

Samus still gets the capacity increase, but that’s it.

# Patches

## Single Tank Increase at Pickup

Instead of a complete refill, regular energy tank pickups only add one tank worth to Samus’s current energy.

This patch is named `single-tank` and uses free space at $84:FFF0.

## Full Reserve Tanks

Instead of being completely empty, reserve tanks come with exactly one reserve tank worth of energy.
If she has 0/200 reserve and collects a tank, she’ll have 100/300 reserve afterward.

This patch is named `reserve-full` and uses free space at $84:FFE0.

## All-filling Reserve Tanks

At pickup, reserve tanks completely fill Samus’ reserves.
If she has 0/200 reserve and happens on a tank, she’ll have 300/300 reserve afterward.

This patch is named `reserve-all` and uses free space at $84:FFE0.
Which is okay, because you can’t use reserve-full _and_ reserve-all at once.

# Applying

I keep forgetting how to xkas, so just to remind myself…

For xkas 06:

    xkas patchfile.asm unheadered.sfc

For xkas 14:

    xkas -o unheadered.sfc patchfile.asm [more asms...]

# Author

[Adam](https://github.com/n00btube) standing on the shoulders of Kejardon,
and anyone who wrote patches in asm format for xkas.

It turns out that the ‘single tank increase’ patch duplicates a patch by
Crashtour99.  Oops, I should check metconst before writing things.

# License

MIT.  If it breaks, you get to keep the pieces.
