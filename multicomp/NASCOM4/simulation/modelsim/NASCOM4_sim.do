restart
force clk 1 0, 0 10ns -repeat 20ns
force n_reset 0
# 0: trigger cold reset sequence in SBootROM
# 1: trigger warm reset sequence in SBootROM
force vduffd0 1
# 1: normal
# 0: interrupt
force rxd2 1
force sramData\[7\] 0
force sramData\[6\] 0
force sramData\[5\] 0
force sramData\[4\] 0
force sramData\[3\] 0
force sramData\[2\] 0
force sramData\[1\] 0
force sramData\[0\] 0
run 100ns
force n_reset 1
force sdMISO 0
run 4000ns

# want to get to the point where the code has halted, to make this
# easy to spot and debug
run 22000ns

force rxd2 0
# messy.. assumes interrupt is enabled and will be handled in this time (else the interrupt will be missed
# or taken a second time)
run 400ns
force rxd2 1
run 4000ns
