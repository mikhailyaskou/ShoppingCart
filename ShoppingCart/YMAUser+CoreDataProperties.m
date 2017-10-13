//
//  YMAUser+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
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
