#!/usr/bin/env python
# vim:fileencoding=utf-8
# Copyright 2015 Adam <https://github.com/n00btube>
# MIT license.
# There _may_ be a newer version at:
# https://github.com/n00btube/sm-energy-sizing

from __future__ import print_function
# ^^ I'm going to do my best to make this work on Python2, but it's only
# tested on Python3.

import sys

FILENAME = "energy-reserve-mods.asm" # output filename

read = input
try:
    read = raw_input # Python2
except:
    pass


class MenuItem (object):
    string = None
    callee = None

    def __init__ (self, string, callee, *args, **kwargs):
        self.string = string
        self.callee = callee

def menu (header, itemlist):
    actions = {}
    val = None

    while not val:
        print("")
        print(header)
        for n, item in enumerate(itemlist, 1):
            print("{0}. {1}".format(n, item.string))
            actions[n] = item.callee

        print("> ", end="")
        try:
            val = read()
        except (EOFError, KeyboardInterrupt) as e:
            sys.exit(0)
        if not val:
            continue
        try:
            fn = actions[int(val)]
            return fn()
        except (KeyError, ValueError) as e:
            print("")
            print("Invalid choice - use option number, or Ctrl+C to quit")
            val = None


class Patch (object):
    # needs enough room for the fattest options combined, 25/$19 bytes
    inject_addr = "84FFE0"
    hijacks = None
    patch = None
    initial_size = 0

    def __init__ (self, *args, **kwargs):
        self.hijacks = [
            "lorom",
            "",
        ]
        self.patch = [
            "",
            "; can be moved anywhere in bank $84 free space",
            "org ${0}".format(self.inject_addr),
        ]
        self.initial_size = len(self.hijacks) + len(self.patch)

    def _hijack_energy (self):
        self.hijacks.extend([
            "org $848972",
            "JSR etank_pickup",
        ])

    def _hijack_reserve (self):
        self.hijacks.extend([
            "org $84898D",
            "JSR rtank_pickup",
        ])
        self.patch.extend([
            "rtank_pickup:",
            "STA $09D4    ; save capacity increase",
        ])

    def energy_zero (self):
        self.hijacks.extend([
            "; energy gain at pickup = 0",
            "org $848972",
            "STA $0A06 ; mirror = max, force HUD update w/o changing current",
        ])

    def energy_one_tank (self):
        self._hijack_energy()
        self.patch.extend([
            "etank_pickup:",
            "LDA $09C2    ; current health",
            "CLC",
            "ADC $0000,Y  ; re-use single tank size value",
            "STA $09C2    ; save back",
            "RTS",
        ])

    def energy_full (self):
        pass # original behavior

    def energy_full_all (self):
        self._hijack_energy()
        self.patch.extend([
            "etank_pickup:",
            "STA $09C2    ; save max as current",
            "LDA $09D4    ; reserve capacity",
            "STA $09D6    ; reserve current",
            "RTS",
        ])

    def reserve_zero (self):
        pass # original behavior

    def reserve_one_tank (self):
        self._hijack_reserve()
        self.patch.extend([
            "LDA $09D6    ; load current reserves",
            "CLC",
            "ADC $0000,Y  ; re-use single tank size value",
            "STA $09D6    ; save back to current reserves",
            "RTS",
        ])

    def reserve_full (self):
        self._hijack_reserve()
        self.patch.extend([
            "STA $09D6    ; current = max reserve",
            "RTS",
        ])

    def reserve_full_all (self):
        self._hijack_reserve()
        self.patch.extend([
            "STA $09D6    ; current = max reserve",
            "LDA $09C4",
            "STA $09C2    ; current = max energy",
            "RTS",
        ])

    def valid (self):
        if len(self.hijacks) + len(self.patch) > self.initial_size:
            return True
        return False

    def write (self, fn):
        if not self.valid():
            print("Nothing to do.")
            return
        with open(fn, "w") as f:
            for ln in self.hijacks:
                print(ln, file=f)
            for ln in self.patch:
                print(ln, file=f)


p = Patch()
Etanks = [
    MenuItem("Zero energy", p.energy_zero),
    MenuItem("One tank of energy", p.energy_one_tank),
    MenuItem("Full energy (original behavior)", p.energy_full),
    MenuItem("Full energy and reserves", p.energy_full_all),
];
Rtanks = [
    MenuItem("Zero reserves (original behavior)", p.reserve_zero),
    MenuItem("One tank of reserves", p.reserve_one_tank),
    MenuItem("Full reserves", p.reserve_full),
    MenuItem("Full energy and reserves", p.reserve_full_all),
]

if __name__ == "__main__":
    menu("What to do when Samus picks up an Energy Tank?", Etanks)
    menu("What should happen when collecting a Reserve Tank?", Rtanks)
    p.write(FILENAME)

