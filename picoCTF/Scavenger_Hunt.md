# Scavenger Hunt

This exercise gives us an url and tells us that there is hidden information hidden around that site.

We can immediately find first and second parts of the flag by simply checking the HTML and CSS of the website. But, when we check the JS, we get the hint "How can I keep Google from indexing my website?". Answer to that is robots.txt. We can use that file to prevent web scavengers and search engines from indexing our website. So, that gives us the part 3 of the flag.

For part 4, we get a hint that says "I think this is an apache server... can you Access the next flag?". With this information, we can look for some files that apache server might use. We can see that .htaccess file is one of such files, used for configuring specific directories.

For part 5, we get a hint that says "I love making websites on my Mac, I can Store a lot of information there". On Mac OS, .DS_Store (Desktop Services store) is a file used to contain visual information about specific folders.

Appending all parts gives us the desired flag.
