GHeptane architecture CPU.
CPU name: sederams
See copying.txt and NOTICE files for derrivative works.
Note there are some spurious extra files which aren't needed but i havent deleted them.
L1 caches in rtl/cache
L2 cache in rtl/l2cache
cams and other similar things int rtl/cams (but not all cams are there).
load/store cams in rtl/lsq
reservation station, main backend, regfiles in rtl/backend
control unit in rtl/cntrl
frontend+decoder in rtl/frontend
NOTE: Architectrual changes pending. The ISA on the website is out of date.
The isa is no longer vliw based its risc like since the instructions can cross bundles of 32 bytes and pages.
Please note that to implement this cpu it is assumed that you'll want to use something like 12 phase dynamic logic.
if you implement it with static logic it will be low clock but not very low.
