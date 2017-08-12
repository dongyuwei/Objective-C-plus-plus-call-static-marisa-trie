#import <Cocoa/Cocoa.h>
#import "marisa.h"
#include <iostream>

NSMutableDictionary*    wordsWithFrequency;

int main(int argc, const char * argv[]) {
    NSDate *start = [NSDate date];
    
    marisa::Trie trie;
    marisa::Agent agent;
    agent.set_query("bad");
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"google-words-trie" ofType:@"bin"];
    const char *path2 = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    try {
        trie.load(path2);
    } catch (const marisa::Exception &ex) {
        std::cerr << ex.what() << ": failed to load a dictionary file: "
        << "dict/google-words-trie.bin" << std::endl;
    }
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    NSLog(@"read trie:%f", timeInterval);
    
    NSDate *start2 = [NSDate date];
    
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    while (trie.predictive_search(agent)) {
//        NSLog(@"%s : %ld", agent.key().ptr(), agent.key().id());
        NSNumber* frequency = [NSNumber numberWithInteger: agent.key().id()];
        NSDictionary* wordWithFrequency = @{@"w": [NSString stringWithUTF8String: agent.key().ptr()], @"f": frequency};
        [candidates addObject: wordWithFrequency];
    }
    NSTimeInterval timeInterval2 = [start2 timeIntervalSinceNow];
    NSLog(@"read trie:%f", timeInterval2);
    
    NSArray *sorted = [candidates sortedArrayUsingComparator:^NSComparisonResult(id item1, id item2) {
        int n = [[item2 objectForKey: @"f"] intValue] - [[item1 objectForKey: @"f"] intValue];
        if (n > 0){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if (n < 0){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *words = [[NSMutableArray alloc] init];
    for (NSDictionary* item in sorted) {
        [words addObject: [item objectForKey: @"w"]];
    }
    NSLog(@"words %@", words);


    

    return 0;
//    return NSApplicationMain(argc, argv);
}
