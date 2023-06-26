# ARMssembly 1

Challenge tells us that if we call the given assembly code with some arguments it will print win. That argument we call it with, is the flag. So, since was little bit lazy to alanyze the assembly code, I compiled it with **aarch64-linux-gnu-gcc**, emulated it with **qemu-static** and tried a small bruteforce (emulation is super slow). Luckily, I found the flag within the first 100 numbers. This is **not** the intended solution.

> for i in {1..100}; do ./a.out $i | grep win; echo $i; done;
