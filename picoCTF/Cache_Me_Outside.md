# Cache Me Outside

Challenge give us a binary, a command with which this binary was compiled and libc.so.6 file which is used by binary. To see what program is about, it would be good to do these two things: 1. Run the program with gdb 2. decompile it and inspect the pseudocode.

## Running the binary with gdb

To run the program we need a linker that is compatible with the libc that is given by the challenge. There are two ways to do this. We can either run the following code

```python
from os import *
import sys

args = sys.argv

if (len(args) < 2):
        print("Missing argument for libc path")
        exit(-1)

libc_path = args[1]

fd = open(libc_path, O_RDONLY)

pattern = b"GNU C Library (Ubuntu GLIBC "

dump = read(fd, path.getsize(libc_path))

index = dump.find(pattern)
start = index + len(pattern)
offset = dump[start:].find(b"-")
print(f"Libc version: {dump[start: start + offset].decode()}")
```

and find the libc version. After that we can manually get the compatible linker (2.27) and run the code.

Alternatively, we can do all this automatically by utilizing [pwninit](https://github.com/io12/pwninit). Consider that this is the current state of our challenge directory:

> Makefile  flag.txt  heapedit  libc.so.6

If we run pwninit here, state becomes

> Makefile  flag.txt  heapedit  heapedit_patched  ld-2.27.so  libc.so.6  solve.py

Here we can just run heapedit_patched with gdb. I recommend using pwndbg plugin for gdb.

## Exploiting the code

After inspecting the pseudocode (Which I retrieved with [IDA](https://hex-rays.com/ida-free/)), we can see that there are some heap allocations happening. There are two messages put into the allocated blocks, one is the flag which we are interested in and other is some other string we are not interested in. In the for loop there are 7 blocks allocated which all contain the flag. Then, after the loop one more malloc is called in which the other string is stored. Now we get to the part where we need knowledge about **tcache**. I will refer to block with flag that is being freed as "win block" and the other block thats being freed as "lose block". Two frees that we see change the tcache struct in the following way

> Right before the frees tcache does not contain any entries for blocks of size 0x80
> After first free, win block's pointer is put into tcache struct. **TCACHE_STRUCT --> WIN_BLOCK**
> After second free, lose block's pointer is put into tcache struct. **TCACHE_STRUCT --> LOSE_BLOCK --> WIN_BLOCK**

If we try to malloc 0x80 size block now, we are going to get lose block and other string is going to be printed. But to exploit that Program gives us a powerful tool, we can overwrite one byte. We can specify where we want to overwrite with offset from some mallocd block. Since the tcache struct points to lose block, our goal is to overwrite that pointer to point to some block with our flag in it. We can search for pointers with pwndbg's search, which can take hexadecimal argument if we give -x flag to it (note that we must give arguments in little endian on little endian system). This offset we can calculate with gdb and wont change, since the code is compiled with --no-pie. If we know the offset we can overwrite it with a value, which makes it point to a block with our flag in it. After that, win block will be allocated and printed, giving us the flag.
