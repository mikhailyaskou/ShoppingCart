//
//  YMAOrder+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAOrder+CoreDataProperties.h"

@implementation YMAOrder (CoreDataProperties)

+ (NSFetchRequest<YMAOrder *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"YMAOrder"];
}

@dynamic date;
@dynamic orderId;
@dynamic state;
@dynamic bookOrders;
@dynamic user;

@end
