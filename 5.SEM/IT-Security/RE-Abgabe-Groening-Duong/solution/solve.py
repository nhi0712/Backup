#!/usr/bin/env python3
# Angreifer-Skript zur gehaerteten 'validate'-ELF.
# (1) rekonstruiert die verschleierten Zielkonstanten aus den im Binary
#     sichtbaren Werten (Tabelle T + maskierte BLOBs + Ableitungslogik),
# (2) loest die Legacy-Constraints mit Z3 -> gueltiger Lizenzschluessel.
from z3 import BitVec, BitVecVal, Solver, sat

# --- (1) aus Ghidra/objdump abgelesen ---
T = [0x0037,0x004A,0x005D,0x0070,0x0083,0x0096,0x00A9,0x00BC,
     0x00CF,0x00E2,0x00F5,0x0108,0x011B,0x012E,0x0141,0x0154]
BLOB = [0x5610, 0x6786, 0xC616]          # maskierte Zielwerte (Immediates im Code)
m16 = lambda v: v & 0xFFFF
def derive_key():                        # 1:1 die Ableitungsschleife nachgebaut
    k = 0
    for t in T:
        k = m16(k + t)
        k = m16(k ^ m16(k << 3))
    return k
k = derive_key()
masks = [k, m16((k << 5) | (k >> 11)), m16(k * 0x9E37)]
C1, C2, C3 = (m16(BLOB[i] ^ masks[i]) for i in range(3))
print("rekonstruiert: C1=0x%04X  C2=0x%04X  C3=0x%04X" % (C1, C2, C3))

# --- (2) Constraints loesen ---
a, b, c, d = (BitVec(n, 16) for n in "abcd")
s = Solver()
s.add((a + b + c + d) == BitVecVal(C1, 16))   # Summe
s.add((a ^ b ^ c ^ d) == BitVecVal(C2, 16))   # XOR
s.add((a * b + c * d) == BitVecVal(C3, 16))   # gemischt (verhindert Brute-Force)
assert s.check() == sat
m = s.model()
v = [m[x].as_long() for x in (a, b, c, d)]
print("Lizenz: DHBW1-%04X-%04X-%04X-%04X" % tuple(v))
