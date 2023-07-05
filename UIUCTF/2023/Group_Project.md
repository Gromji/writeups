## Group Project

Upon connecting to the server, we are given three values g, p and A. Then, we are asked to give value for k, which is later used in code. But, before it is used there is a check

```python
if k == 1 or k == p - 1 or k == (p - 1) // 2:
	print("[$] I'm not that dumb...")
```

As we can see there is no check for k = 0. We can utilize this and send 0, after which we can know for sure what the key will be that will be used to encrypt the message. Since, S is the value that is being used for key, S = pow(Bk, a, p) and Bk = pow(B, k, p), when we give 0 for k, Bk would get assigned 1 and S would also be 1. Now we can do the same operation that is being done to S and get the key.

```python
from Crypto.Util.number import long_to_bytes
from Crypto.Cipher import AES
import hashlib

c = # Value we get after we pass 0 to the program
c = c.to_bytes((c.bit_length() + 7) // 8, "big")
S = 1

key = hashlib.md5(long_to_bytes(S)).digest()
cipher = AES.new(key, AES.MODE_ECB)
print(cipher.decrypt(c))
```
