# sm-energy-sizing

Changes to how much energy E-Tanks and Reserve Tanks grant at pickup in Super
Metroid.

Uses free space in bank 84, since it has to add code to the tanks’ PLMs.

## Single Tank

Instead of a complete refill, regular energy tank pickups only add one tank
worth to Samus’s current energy.

If you want energy tanks to grant **zero** energy, you can write `EA EA EA` at
$84:8972 ($20972 file offset, unheadered.)

Uses free space at FFF0.

## Reserves with Energy

Instead of being completely empty, reserve tanks come with exactly one reserve
tank worth of energy.

Uses free space at FFE0.

# Author

[Adam](https://github.com/n00btube) standing on the shoulders of Kejardon,
and anyone who wrote patches in asm format for xkas.

# License

MIT.  If it breaks, you get to keep the pieces.
