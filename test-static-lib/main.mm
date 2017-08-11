//
//  main.m
//  test-static-lib
//
//  Created by dongyuwei on 8/3/17.
//  Copyright © 2017 dongyuwei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "marisa.h"
#include <iostream>

int main(int argc, const char * argv[]) {
    NSDate *start = [NSDate date];
    
    marisa::Keyset keyset;
    keyset.push_back("apply", 5, 111);
    keyset.push_back("application", 12, 222);
    keyset.push_back("apple", 5, 3);
    
    marisa::Trie trie;
    trie.build(keyset);
    
    marisa::Agent agent;
    agent.set_query("apple");
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"bin"];
    const char *path2 = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    try {
        trie.load(path2);
    } catch (const marisa::Exception &ex) {
        std::cerr << ex.what() << ": failed to load a dictionary file: "
        << "dict/dict.bin" << std::endl;
    }
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    NSLog(@"read trie:%f", timeInterval);
    
    NSDate *start2 = [NSDate date];
    while (trie.predictive_search(agent)) {
        std::cout.write(agent.key().ptr(), agent.key().length());
        std::cout << ": " << agent.key().id() << std::endl;
    }
    NSTimeInterval timeInterval2 = [start2 timeIntervalSinceNow];
    NSLog(@"read trie:%f", timeInterval2);
    

    return NSApplicationMain(argc, argv);
}
