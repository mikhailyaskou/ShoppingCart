//
//  YMADataBase.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADataBase.h"

@interface YMADataBase ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation YMADataBase


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

+ (id)sharedDataBase {
    static YMADataBase *sharedDataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataBase = [[self alloc] init];
    });
    return sharedDataBase;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    return self.persistentContainer.viewContext;
}

- (NSManagedObjectContext *)newBackgroundContext {
    return [self.persistentContainer newBackgroundContext];
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ShoppingCart"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Core Data Fetch Data

- (NSFetchedResultsController *)fetchedResultsControllerWithDataName:(NSString *)entityName
                                                           predicate:(NSPredicate * _Nullable)predicate
                                                         sotretByKey:(NSString *)sortKey {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES];
    [request setSortDescriptors:@[lastNameSort]];
    NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                        managedObjectContext:self.managedObjectContext
                                                                                          sectionNameKeyPath:nil
                                                                                                   cacheName:nil];
    NSError *error = nil;
    if (![resultsController performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    return resultsController;
}

#pragma mark - Core Data Operations

- (void)clearCoreData {
    NSArray<NSEntityDescription *> *entityDescriptions = self.persistentContainer.managedObjectModel.entities;
    for (NSEntityDescription *entityDescription in entityDescriptions) {
        [self deleteAllEtitysWithEntityName:entityDescription.name];
    }
}

- (void)deleteAllEtitysWithEntityName:(NSString *)name {
    [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context){
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:name];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        NSError *deleteError = nil;
        [self.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
        [self saveContext:context];
    }];
}

@end
