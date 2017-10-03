//
//  YMAUser+CoreDataProperties.h
//  
//
//  Created by Mikhail Yaskou on 02.10.17.
//
//

#import "YMAUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface YMAUser (CoreDataProperties)

+ (NSFetchRequest<YMAUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSSet<YMAOrder *> *orders;

@end

@interface YMAUser (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(YMAOrder *)value;
- (void)removeOrdersObject:(YMAOrder *)value;
- (void)addOrders:(NSSet<YMAOrder *> *)values;
- (void)removeOrders:(NSSet<YMAOrder *> *)values;

@end

NS_ASSUME_NONNULL_END
