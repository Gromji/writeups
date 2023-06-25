In this exercise we are given a file in which there are packets captured by wireshark.
> shark1.pcapng

Exercise description is hinting that we should analyze data being sent and received.

So, if open the file with wireshark and go through tcp streams we can find interesting data that might look like this
> **cvpbPGS{c33xno00_1_f33_h_qrnqorrs}**

After I tried to decipher it with **ROT13** I got the flag.
```
import codecs

def rot13_decode(text):
        return codecs.decode(text, 'rot_13')

print(rot13_decode('cvpbPGS{c33xno00_1_f33_h_qrnqorrs}'))
```
