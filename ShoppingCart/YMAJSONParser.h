//
//  YMAJSONPaerser.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAJSONParser : NSObject

+ (YMAJSONParser *)sharedInstance;

- (void)parseByURL:(NSURL *)url completionHandler:(void(^)(NSArray *array))completionHandler;

@end
