//
//  Order+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "Order+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int16_t orderId;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, retain) NSSet<OrderBook *> *bookOrders;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addBookOrdersObject:(OrderBook *)value;
- (void)removeBookOrdersObject:(OrderBook *)value;
- (void)addBookOrders:(NSSet<OrderBook *> *)values;
- (void)removeBookOrders:(NSSet<OrderBook *> *)values;

@end

NS_ASSUME_NONNULL_END
