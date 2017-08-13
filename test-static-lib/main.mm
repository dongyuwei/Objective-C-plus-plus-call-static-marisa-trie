#import <Cocoa/Cocoa.h>
#import "marisa.h"
#include <iostream>

NSMutableDictionary*    wordsWithFrequency;

int main(int argc, const char * argv[]) {
    NSString* file = [[NSBundle mainBundle] pathForResource:@"google_227800_words" ofType:@"json"];
    
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath: file];
    [inputStream  open];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];

    NSMutableDictionary* wordsWithFrequency = [dict mutableCopy];
    [inputStream close];
    
    NSArray * allWords = [wordsWithFrequency allKeys];
    
    marisa::Keyset keyset;
    
    for(NSString* word in allWords){
        keyset.push_back([word UTF8String], [word length], [[wordsWithFrequency objectForKey:word] intValue]);
    }

    
    marisa::Trie trie;
    trie.build(keyset);
    trie.save("/tmp/google_227800_words.bin");
    
    marisa::Agent agent;
    agent.set_query("foots");
    while (trie.predictive_search(agent)) {
        std::cout.write(agent.key().ptr(), agent.key().length());
        std::cout << " =:= " << agent.key().id() << std::endl;
    }

    return NSApplicationMain(argc, argv);
}
