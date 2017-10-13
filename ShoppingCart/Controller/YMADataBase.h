//
//  YMADataBase.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface YMADataBase : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (id)sharedDataBase;

- (NSManagedObjectContext *)managedObjectContext;
- (NSPersistentContainer *)persistentContainer;
- (void)saveContext;
- (void)saveContext:(NSManagedObjectContext *)context;
- (void)clearCoreData;
- (void)deleteObjectAndSave:(NSManagedObject *)object;
- (NSManagedObjectContext *)newBackgroundContext;
- (NSFetchedResultsController *)fetchedResultsControllerWithDataName:(NSString *)entityName
                                                           predicate:(NSPredicate * _Nullable)predicate
                                                         sotretByKey:(NSString *_Nullable)sortKey;
- (void)deleteAllEtitysWithEntityName:(NSString *_Nonnull)name;
- (NSArray *)allEntitiesWithName:(NSString *)entityName inContext:(NSManagedObjectContext *)context;
- (NSManagedObject *)findOrCreateEntityWithName:(NSString *)entityName
                                findByFieldName:(NSString *)fieldName
                                      withValue:(NSString *)value
                                      inContext:(NSManagedObjectContext *)context;
- (NSManagedObject *)findOrCreateEntityWithName:(NSString *)entityName
                                findByFieldName:(NSString *)fieldName
                                      withValue:(NSString *)value
                       searchInArrayWithEntitys:(NSArray *)allEntities
                                      inContext:(NSManagedObjectContext *)context;

@end
