Challenge gives us the binary that is running on the given server. We can try to reverse engineer it, but after failing to decompile the code with my cracked IDA Pro and not being able to understand the pseudocode that was displayed in Ghidra (because the code was probably written in some high level language), I decided to play around with the code a bit. So, I found out that if you try to sell a negative amount of item (for example choose option 0 and give -1231231231 as value after first prompt) you suddenly have positive amount of coins (best I can do is guess that there is some kind of integer overflow). Those coins can be used to purchase the Fruitful Flag. 