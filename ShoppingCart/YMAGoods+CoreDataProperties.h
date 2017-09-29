//
//  YMAGoods+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAGoods (CoreDataProperties)

+ (NSFetchRequest<YMAGoods *> *)fetchRequest;

@property (nonatomic) BOOL aviable;
@property (nonatomic) int32_t code;
@property (nonatomic) double discount;
@property (nullable, nonatomic, retain) NSObject *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double price;
@property (nullable, nonatomic, retain) NSSet<YMAOrderBook *> *orderBooks;

@end

@interface YMAGoods (CoreDataGeneratedAccessors)

- (void)addOrderBooksObject:(YMAOrderBook *)value;

- (void)removeOrderBooksObject:(YMAOrderBook *)value;

- (void)addOrderBooks:(NSSet<YMAOrderBook *> *)values;

- (void)removeOrderBooks:(NSSet<YMAOrderBook *> *)values;

@end

NS_ASSUME_NONNULL_END
