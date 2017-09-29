//
//  YMAOrderBook+CoreDataClass.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YMAGoods, YMAOrder;

NS_ASSUME_NONNULL_BEGIN

@interface YMAOrderBook : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "YMAOrderBook+CoreDataProperties.h"
