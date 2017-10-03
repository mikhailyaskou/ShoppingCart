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

@interface YMAShopService : NSObject

@property (nonatomic, strong) NSMutableArray *cart;

+ (id)sharedShopService;

- (void)addToCart:(YMAGoods *)product;

- (void)removeFromCar:(YMAGoods *)product;

- (YMAUser *)currentUser;

- (YMAOrder *)currentOrder;

- (NSArray *)goodsFromOrder:(YMAOrder *)order;

- (YMAGoods *)goodsById:(NSNumber *)idGoods;

- (void)addProductToCurrentOrder;

- (void)sendOrder;

@end
