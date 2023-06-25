In this challenge we are provided with an url, where we are asked to enter the flag and submit it.

Name of the challenge gives us a little hint that we need to do something with assembly.

After analyzing the JS of the page, we can see that there is object called WebAssembly being used. This object is passed a return value of the fetch function called right before it. If we put some brakepoints and see the values, we can see that value passed to fetch is

> /JIFxzHyW8W

Note that this value is taken from the array defined right at the top of the JS script.

So, from base-url/JIFxzHyW8W some kind of assembly is fetched. We can also see this web assembly in the sources tab of inspect element. Right at the end of that file we can see the flag.
