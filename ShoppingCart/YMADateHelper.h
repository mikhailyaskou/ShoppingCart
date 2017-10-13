//
//  YMADateHelper.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 01.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMADateHelper : NSObject

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

@end
