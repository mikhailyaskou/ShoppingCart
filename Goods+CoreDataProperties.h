//
//  Goods+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "Goods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest;

@property (nonatomic) BOOL aviable;
@property (nonatomic) int32_t code;
@property (nonatomic) double discount;
@property (nullable, nonatomic, retain) NSObject *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double price;
@property (nullable, nonatomic, retain) NSSet<OrderBook *> *orderBooks;

@end

@interface Goods (CoreDataGeneratedAccessors)

- (void)addOrderBooksObject:(OrderBook *)value;
- (void)removeOrderBooksObject:(OrderBook *)value;
- (void)addOrderBooks:(NSSet<OrderBook *> *)values;
- (void)removeOrderBooks:(NSSet<OrderBook *> *)values;

@end

NS_ASSUME_NONNULL_END
