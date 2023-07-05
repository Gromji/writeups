## Morphing Time

When we start the program, we are given five values g, p, A, c1 and c2 (this last one is the encrypted message). If we look at the code, our attack surface is just the decrypt function, because the two values we pass modify the arguments of this function. To be more precise this is the code that gets ran:
```python
decrypt((c1 * c1_) % p, (c2 * c2_) % p)
```
c1_ and c2_ are values that we pass. If this decrypt function was called with c1 and c2 flag would get printed. Now lets trace what is happening in decrypt function. 

**c1 * c1_ is the first argument**
**c2 * c2_ is the second argument**

```python
pow(c1, a, p)
```

**(c1 * c1_)^a (mod p)** 
**c1^a * c1_^a (mod p)** 

```python
m = pow(m, -1, p)
(c2 * m) % p 
```

**c2 * c2_ * (c1^a * c1_^a)^-1 (mod p)**
**c2 * c2_ * c1^a^-1 * c1_^a^-1 (mod p)**

As we can see from the last line, in this simplified form it is easy to see that we need to give such values, that c2_ * c1_^a^-1 == 1 (mod p). That is because, normally, when c1 and c2 are passed to the function those two parts aren't involved in the computation. The fact that we were given A (g^a (mod p)) gives us the possibility to retrieve flag. We just need to give A as c2_ and g as c1_. c2_ * c1_^a^-1 (mod p) becomes A * g^a^-1 (mod p). Since g^a == A, result of that computation will indeed be 1.
