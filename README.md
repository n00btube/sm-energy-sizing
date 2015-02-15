# sm-energy-sizing

Changes to how much energy E-Tanks and Reserve Tanks grant at pickup in Super
Metroid.

Uses free space in bank 84, since it has to add code to the tanks’ PLMs.

# Patches

## Single Tank Increase at Pickup

Instead of a complete refill, regular energy tank pickups only add one tank
worth to Samus’s current energy.

If you want energy tanks to grant **zero** energy, you can write `EA EA EA` at
$84:8972 ($20972 file offset, unheadered.)

Uses free space at FFF0.

## Full Reserve Tanks

Instead of being completely empty, reserve tanks come with exactly one reserve
tank worth of energy.

Uses free space at FFE0.

# Applying

I keep forgetting how to xkas, so just to remind myself…

For xkas 06:

    xkas patchfile.asm unheadered.sfc

For xkas 14:

    xkas -o unheadered.sfc patchfile.asm [more asms...]

# Author

[Adam](https://github.com/n00btube) standing on the shoulders of Kejardon,
and anyone who wrote patches in asm format for xkas.

# License

MIT.  If it breaks, you get to keep the pieces.
