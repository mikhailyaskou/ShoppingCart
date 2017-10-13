//
//  YMAGoods+CoreDataProperties.m
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAGoods+CoreDataProperties.h"

@implementation YMAGoods (CoreDataProperties)

+ (NSFetchRequest<YMAGoods *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"YMAGoods"];
}

@dynamic available;
@dynamic code;
@dynamic image;
@dynamic name;
@dynamic price;
@dynamic orderBooks;

@end
