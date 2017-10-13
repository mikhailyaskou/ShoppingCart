//
//  YMAJSONParser.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAJSONParser.h"

@implementation YMAJSONParser

+ (YMAJSONParser *)sharedInstance {
    static YMAJSONParser *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YMAJSONParser alloc] init];
    });
    return _sharedInstance;
}

- (void)parseByURL:(NSURL *)url completionHandler:(void (^)(NSArray *array))completionHandler {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSError *e = nil;
                if (!jsonResponse) {
                    NSLog(@"Error parsing JSON: %@", e);
                }
                else {
                    completionHandler(jsonResponse);
                }
            }
            else {
                NSLog(@"Web server is returning an error");
            }
        }
        else {
            NSLog(@"error : %@", error.description);
        }
    }] resume];
}

@end
