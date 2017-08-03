# Objective-c--call-static-marisa-trie
a test/demo app using Objective-c++ code to call static marisa-trie C++ lib

## build in XCode
1. Building Settings ---> Header search Paths ---> add  `$SOURCE_ROOT/include` in Debug and Release
2. General ---> Linked Frameworks and Libraries ---> add `libmarisa.a`(path is lib/libmarisa.a)
3. demo code see `ViewController.mm`
4. marisa-trie ref: http://s-yata.github.io/marisa-trie/docs/readme.en.html