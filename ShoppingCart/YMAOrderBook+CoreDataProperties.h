//
//  YMAOrderBook+CoreDataProperties.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrderBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAOrderBook (CoreDataProperties)

+ (NSFetchRequest<YMAOrderBook *> *)fetchRequest;

@property (nullable, nonatomic, retain) YMAGoods *goods;
@property (nullable, nonatomic, retain) YMAOrder *order;

@end

NS_ASSUME_NONNULL_END
