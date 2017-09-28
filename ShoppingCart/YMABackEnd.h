//
//  YMABackEnd.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 27.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Order;

@interface YMABackEnd : NSObject

+ (void)fetchPhone;
+ (void)post:(Order *)order;
+ (void)fetchOrders;

@end
