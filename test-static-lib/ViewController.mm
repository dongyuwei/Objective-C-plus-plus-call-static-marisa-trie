//
//  ViewController.m
//  test-static-lib
//
//  Created by dongyuwei on 8/3/17.
//  Copyright © 2017 dongyuwei. All rights reserved.
//

#import "ViewController.h"

//Building Settings ---> Header search Paths ---> add  `$SOURCE_ROOT/include` in Debug and Release
//General ---> Linked Frameworks and Libraries ---> add `libmarisa.a`(path is lib/libmarisa.a)
#import "marisa.h"
#include <iostream>

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"===viewDidLoad==");
    
    marisa::Keyset keyset;
    keyset.push_back("a");
    keyset.push_back("app");
    keyset.push_back("apple");
    
    marisa::Trie trie;
    trie.build(keyset);
    
    marisa::Agent agent;
    agent.set_query("apple");
    while (trie.common_prefix_search(agent)) {
        std::cout.write(agent.key().ptr(), agent.key().length());
        std::cout << ": " << agent.key().id() << std::endl;
    }
    
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
