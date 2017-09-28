//
//  YMADateHelper.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 01.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateHelper.h"

static NSString *const YMADateFormat = @"dd.MM.yyyy";

@implementation YMADateHelper

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:YMADateFormat];
    return [formatter dateFromString:dateString];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [NSCalendar.currentCalendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
            NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
}
@end
