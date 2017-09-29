//
//  YMAUser+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAUser+CoreDataProperties.h"

@implementation YMAUser (CoreDataProperties)

+ (NSFetchRequest<YMAUser *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"YMAUser"];
}

@dynamic address;
@dynamic name;
@dynamic phoneNumber;
@dynamic orders;

@end
