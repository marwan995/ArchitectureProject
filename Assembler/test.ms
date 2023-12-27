in r2
in r3
in r4
ldm r1 f5h
nop
nop
push r1
push r2
nop
nop
pop r1
nop
nop
pop r2
nop
nop
std r2 200h
std r1 202h
ldd r3 202h
ldd r4 200h
nop
std r3 f5h
protect r4
std r4 f5h
ldd r5 f5h
free r4
ldd r5 f5h