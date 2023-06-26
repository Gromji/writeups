# New Caesar

Challenge encrypts the flag with so called "New Caesar". It is easy to trace back and reverse the operations done on the flag to obtain the flag. Little bit of brute forcing is done for the key which is used to encrypt the flag (We are told that length of the key is 1).


```python
import string

LOWERCASE_OFFSET = ord("a")
ALPHABET = string.ascii_lowercase[:16]
encoded_flag = "mlnklfnknljflfjljnjijjmmjkmljnjhmhjgjnjjjmmkjjmijhmkjhjpmkmkmljkjijnjpmhmjjgjj"

def shift(c, k):
    t1 = ord(c) - LOWERCASE_OFFSET
    t2 = k - LOWERCASE_OFFSET
    return ALPHABET[(t1 - t2) % len(ALPHABET)]

def decode(encoded):
    dec = ""
    for i in range(0, len(encoded), 2):
        first = encoded[i]
        second = encoded[i + 1]
        first_half = "{0:04b}".format(ALPHABET.index(first))
        second_half = "{0:04b}".format(ALPHABET.index(second))
        c = chr(int(first_half + second_half, 2))
        dec += c
    return dec

for k in range(0xFF):
    shifted = ""
    for c in encoded_flag:
        shifted += shift(c, k)
    print(decode(shifted))
```
