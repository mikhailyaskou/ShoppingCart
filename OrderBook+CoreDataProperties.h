//
//  OrderBook+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "OrderBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OrderBook (CoreDataProperties)

+ (NSFetchRequest<OrderBook *> *)fetchRequest;

@property (nullable, nonatomic, retain) Order *order;
@property (nullable, nonatomic, retain) Goods *goods;

@end

NS_ASSUME_NONNULL_END
