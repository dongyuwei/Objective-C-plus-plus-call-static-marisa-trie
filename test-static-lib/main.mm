#import <Cocoa/Cocoa.h>
#import "marisa.h"
#include <iostream>

//#include <iostream>
#include <string>
#include <sparsepp/spp.h>

using spp::sparse_hash_map;

NSMutableDictionary*    wordsWithFrequency;

int main(int argc, const char * argv[]) {
    // Create an unordered_map of three strings (that map to strings)
    sparse_hash_map<std::string, std::string> email =
    {
        { "tom",  "tom@gmail.com"},
        { "jeff", "jk@gmail.com"},
        { "jim",  "jimg@microsoft.com"}
    };
    
    // Iterate and print keys and values
    for (const auto& n : email)
        std::cout << n.first << "'s email is: " << n.second << "\n";
    
    // Add a new entry
    email["bill"] = "bg@whatever.com";
    
    // and print it
    std::cout << "bill's email is: " << email["bill"] << "\n";
    
    
    
    NSString* file = [[NSBundle mainBundle] pathForResource:@"google_227800_words" ofType:@"json"];
    
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath: file];
    [inputStream  open];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];

    wordsWithFrequency = [dict mutableCopy];
    [inputStream close];

    
    marisa::Trie trie;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"google_227800_words" ofType:@"bin"];
    const char *path2 = [path cStringUsingEncoding:[NSString defaultCStringEncoding]];
    trie.load(path2);
    
    marisa::Agent agent;
    agent.set_query("good");
    
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    while (trie.predictive_search(agent)) {
        const marisa::Key key = agent.key();
        NSString* word = [[NSString alloc] initWithBytes: key.ptr()
                                               length: key.length()
                                             encoding: NSASCIIStringEncoding];
        
        [candidates addObject: word];
    }
    
    NSArray *sorted = [candidates sortedArrayUsingComparator:^NSComparisonResult(id w1, id w2) {
        int n = [[wordsWithFrequency objectForKey: w1] intValue] - [[wordsWithFrequency objectForKey: w2] intValue];
        if (n > 0){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if (n < 0){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    

    NSLog(@"sorted words %@", sorted);
 
    return NSApplicationMain(argc, argv);
}
