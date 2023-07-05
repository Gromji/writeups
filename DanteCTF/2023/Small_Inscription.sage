#!/usr/bin/sage

from Crypto.Util.number import *

msg_base = b'There is something reeeally important you should know, the flag is '

e = 3 # Given public key
ct = # Given ciphertext
N = # Given N

# Iterate over length of message
for i in range(1, 30):
    msg_guess = bytes_to_long(msg_base) * pow(256, i)

    PR.<x> = PolynomialRing(Zmod(N)) # Construct a polynomial ring

    # This code has been written according to the documentation of small_roots function in SageMath
    # ct === (msg_guess + x0)^e (mod N) so we want to find root of f(x) = (msg_guess + x)^e (mod N) 
    # now our goal is to find a root for f(x) === 0 (mod N)
    f = (msg_guess + x)^e - ct 		       
    
    # Try to find a small root for it using Coppersmith method (which uses LLL)
    # Default values for this function seem to work fine			   
    root = f.small_roots() 
    
    if len(root) != 0:
        msg = int(msg_guess + root[0])
        break

msg_decoded = long_to_bytes(msg).decode()

print(msg_decoded)
