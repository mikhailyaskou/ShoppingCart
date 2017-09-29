//
//  YMAOrder+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrder+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAOrder (CoreDataProperties)

+ (NSFetchRequest<YMAOrder *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int16_t orderId;
@property (nonatomic) int16_t state;
@property (nullable, nonatomic, retain) NSSet<YMAOrderBook *> *bookOrders;
@property (nullable, nonatomic, retain) YMAUser *user;

@end

@interface YMAOrder (CoreDataGeneratedAccessors)

- (void)addBookOrdersObject:(YMAOrderBook *)value;

- (void)removeBookOrdersObject:(YMAOrderBook *)value;

- (void)addBookOrders:(NSSet<YMAOrderBook *> *)values;

- (void)removeBookOrders:(NSSet<YMAOrderBook *> *)values;

@end

NS_ASSUME_NONNULL_END
