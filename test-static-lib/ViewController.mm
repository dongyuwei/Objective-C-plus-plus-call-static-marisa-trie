//
//  ViewController.m
//  test-static-lib
//
//  Created by dongyuwei on 8/3/17.
//  Copyright © 2017 dongyuwei. All rights reserved.
//

#import "ViewController.h"

// just rename ViewController.m to ViewController.mm and drag ViewController.mm to test-static-lib dir in XCode
// Building Settings ---> Header search Paths ---> add  `$SOURCE_ROOT/include` in Debug and Release
// General ---> Linked Frameworks and Libraries ---> add `libmarisa.a`(path is lib/libmarisa.a)
// ref: http://s-yata.github.io/marisa-trie/docs/readme.en.html

#import "marisa.h"
#include <iostream>

@implementation ViewController

- (void)viewDidLoad {
    marisa::Keyset keyset;
    
    keyset.push_back("goods", 5, 52507183);
    keyset.push_back("goodshoot", 9, 303518);
    keyset.push_back("goodson", 7, 224454);
    keyset.push_back("goodsell", 8, 38700);
    
    marisa::Trie trie;
    trie.build(keyset);
    
    marisa::Agent agent;
    agent.set_query("goods");
    while (trie.predictive_search(agent)) {
        std::cout.write(agent.key().ptr(), agent.key().length());
        std::cout << " :: " << agent.key().id() << std::endl;
    }
    
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
