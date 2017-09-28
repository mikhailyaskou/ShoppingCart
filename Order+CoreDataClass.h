//
//  Order+CoreDataClass.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderBook, User;

NS_ASSUME_NONNULL_BEGIN

@interface Order : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Order+CoreDataProperties.h"
