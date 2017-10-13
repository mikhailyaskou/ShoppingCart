//
//  YMAOrderBook+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAOrderBook+CoreDataProperties.h"

@implementation YMAOrderBook (CoreDataProperties)

+ (NSFetchRequest<YMAOrderBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMAOrderBook"];
}

@dynamic goods;
@dynamic order;

@end
