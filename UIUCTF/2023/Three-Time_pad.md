## Three-Time pad

Challenge gives us three encrypted messages (c1, c2, c3) and one plain text message (p2, which when encrypted gives us c2). Challenge also tells us that encryption message being used is the following: **cipher_text = message XOR key**. Since we have plain text for one of the encrypted message and challenge also tells us that key is being reused, we can get the key with following operation: **key = message XOR cipher_text**.

```python
from os import *

c1 = read(open("./c1", O_RDONLY), path.getsize("./c1"))
c2 = read(open("./c2", O_RDONLY), path.getsize("./c2"))
c3 = read(open("./c3", O_RDONLY), path.getsize("./c3"))
p2 = read(open("./p2", O_RDONLY), path.getsize("./p2"))

key = bytes([a ^ b for a, b in zip(c2, p2)])

print(bytes([a ^ b for a, b in zip(c1, key[:len(c1)])]))
print(bytes([a ^ b for a, b in zip(c3, key[:len(c3)])]))
```
