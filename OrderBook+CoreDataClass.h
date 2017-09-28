//
//  OrderBook+CoreDataClass.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods, Order;

NS_ASSUME_NONNULL_BEGIN

@interface OrderBook : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "OrderBook+CoreDataProperties.h"
