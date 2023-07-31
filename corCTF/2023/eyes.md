## Eyes

This challenge creates three matrices: A, B and C. A is a random N x N matrix and B is a random vector of length N. C is the matrix that contains the flag, so our goal is to get C.

> x.T * A * x + B.T * x + C 

This is the computation done with these matrices. Here x is a vector of 0's and 1's and additionally, all but first three elements are always zero. x vectors are created in the following way:

> matrix(F, N, 1, [int(i) for i in list(bin(n)[2:][::-1].ljust(N, '0'))])

Here n is some number. We are given a prime number with which GF is created and we are also given seven different values which come from the matrix multiplication that I mentioned earlier. To create x vectors for each computation values ranging from 1 to 7 are used for n. Now that we know all this, we can multiply these matrices by ourselves and write down 7 different equations. After that, we can use the solver.

```python
from z3 import *
from Crypto.Util.number import long_to_bytes

variables = Ints('a11 a12 a13 a22 a23 a33 b11 b21 b31 c')
a11, a12, a13, a22, a23, a33, b11, b21, b31, c = variables

solver = Solver()

p = 1873089703968291141600166892623234932796169766648225659075834963115683566265697596115468506218441065194050127470898727249982614285036691594726454694776985338487833409983284911305295748861807972501521427415609
l = [676465814304447223312460173335785175339355609820794166139539526721603814168727462048669021831468838980965201045011875121145342768742089543742283566458551844396184709048082643767027680757582782665648386615861, 1472349801957960100239689272370938102886275962984822725248081998254467608384820156734807260120564701715826694945455282899948399224421878450502219353392390325275413701941852603483746312758400819570786735148132, 202899433056324646894243296394578497549806047448163960638380135868871336000334692955799247243847240605199996942959637958157086977051654225700427599193002536157848015527462060033852150223217790081847181896018, 1065982806799890615990995824412253076607488063240855100580513221962298598002468338823225586171107539104635808108356492123167315175110515086192932230998426512947581115358738651206273178867911944034690138825583, 1676559204037482856674710667663849447914859348633288513196735253002541076530170853584406282605482862202276451646974549657672382936948091649764874334064431407644457518190694888175499630744741620199798070517691, 13296702617103868305327606065418801283865859601297413732594674163308176836719888973529318346255955107009306239107173490429718438658382402463122134690438425351000654335078321056270428073071958155536800755626, 1049859675181292817835885218912868452922769382959555558223657616187915018968273717037070599055754118224873924325840103339766227919051395742409319557746066672267640510787473574362058147262440814677327567134194]

solver.add(a11 >= 0, a12 >= 0, a13 >= 0, a22 >= 0, a23 >= 0, a33 >= 0, b11 >= 0, b21 >= 0, b31 >= 0, c >= 0)
solver.add(a11 < p, a12 < p, a13 < p, a22 < p, a23 < p, a33 < p, b11 < p, b21 < p, b31 < p, c < p)
solver.add((a11 + b11 + c) % p == l[0])
solver.add((a22 + b21 + c) % p == l[1])
solver.add((a11 + a12 + a22 + b11 + b21 + c) % p == l[2])
solver.add((a33 + b31 + c) % p == l[3])
solver.add((a11 + a13 + a33 + b11 + b31 + c) % p == l[4])
solver.add((a22 + a23 + a33 + b21 + b31 + c) % p == l[5])
solver.add((a11 + a12 + a13 + a22 + a23 + a33 + b11 + b21 + b31 + c) % p == l[6])

while solver.check() == sat:
    m = solver.model()
    solver.add(c != m[c])
    if (b"corctf" in long_to_bytes(m[c].as_long())):
        print(long_to_bytes(m[c].as_long()))
```