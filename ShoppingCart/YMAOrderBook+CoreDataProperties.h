//
//  YMAOrderBook+CoreDataProperties.h
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAOrderBook+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAOrderBook (CoreDataProperties)

+ (NSFetchRequest<YMAOrderBook *> *)fetchRequest;

@property (nullable, nonatomic, retain) YMAGoods *goods;
@property (nullable, nonatomic, retain) YMAOrder *order;

@end

NS_ASSUME_NONNULL_END
