define launch
shell make
target remote 127.0.0.1:3333
file fw.elf
monitor reset init
load fw.elf
monitor reset init
c
end

define reset
monitor reset init
c
end
