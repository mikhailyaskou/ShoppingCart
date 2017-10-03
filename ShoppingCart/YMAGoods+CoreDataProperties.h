//
//  YMAGoods+CoreDataProperties.h
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAGoods+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAGoods (CoreDataProperties)

+ (NSFetchRequest<YMAGoods *> *)fetchRequest;

@property (nonatomic) BOOL available;
@property (nonatomic) int16_t code;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double price;
@property (nullable, nonatomic, retain) NSSet<YMAOrderBook *> *orderBooks;

@end

@interface YMAGoods (CoreDataGeneratedAccessors)

- (void)addOrderBooksObject:(YMAOrderBook *)value;
- (void)removeOrderBooksObject:(YMAOrderBook *)value;
- (void)addOrderBooks:(NSSet<YMAOrderBook *> *)values;
- (void)removeOrderBooks:(NSSet<YMAOrderBook *> *)values;

@end

NS_ASSUME_NONNULL_END
