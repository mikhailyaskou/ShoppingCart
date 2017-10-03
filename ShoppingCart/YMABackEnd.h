//
//  YMABackEnd.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 27.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAOrder;

@interface YMABackEnd : NSObject

+ (void)fetchPhoneWithCompletionHandler:(void (^)())completionHandler;
+ (void)post:(YMAOrder *)order;

@end
