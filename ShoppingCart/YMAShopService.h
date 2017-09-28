//
//  YMAShopService.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+CoreDataClass.h"
#import "Order+CoreDataClass.h"
#import "Goods+CoreDataClass.h"


@interface YMAShopService : NSObject

@property (nonatomic, strong) NSMutableArray *cart;

+ (id)sharedShopService;

- (void)addToCart:(Goods *)product;
- (void)removeFromCar:(Goods *)product;
- (User *)currentUser;
- (Order *)currentOrder;
- (NSArray *) goodsFromOrder:(Order *)order;
- (Goods *)goodsById:(NSNumber *) idGoods;
- (void)addOrder;
- (void)addProductToCurrentOrder;
- (void)sendOrder;

@end
