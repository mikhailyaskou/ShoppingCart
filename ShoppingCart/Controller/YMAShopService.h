//
//  YMAShopService.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMAGoods;
@class YMAUser;
@class YMAOrder;

@class NSManagedObjectID;
@class NSManagedObjectContext;

@interface YMAShopService : NSObject

+ (id)sharedShopService;

- (void)addToCart:(NSManagedObjectID *)productId;

- (NSManagedObjectID *)currentUserManagedObjectID;

- (NSManagedObjectID *)currentOrderManagedObjectID;
- (void)sendCurrentOrder;

@end
