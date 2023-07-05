## At Home

Challenge gives us three values e, n and c (encrypted flag). If we look at how flag is encrypted we can see that it is just flag * e (mod n). So we have that c === flag * e (mod n). Therefore, we can find the inverse of e mod n and multiply c with that number, c * e^-1 === flag (mod n).

```python
from os import *

chal = read(open("./chal.txt", O_RDONLY), path.getsize("./chal.txt")).decode()

splits = chal.split()

e = int(splits[2])
n = int(splits[5])
c = int(splits[8])

# c = (flag * e) mod n
# flag = c * e^-1 mod n

inverse = pow(e, -1, n)
print(((c * inverse) % n).to_bytes(256, "big"))
```
