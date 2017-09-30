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
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ShoppingCart"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
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
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - Core Data Operations

- (void)clearCoreData {
    [self deleteAllEtitysWithEntityName:@"YMAOrder"];
    [self deleteAllEtitysWithEntityName:@"YMAGoods"];
    [self deleteAllEtitysWithEntityName:@"YMAOrderBook"];
}

- (void)deleteAllEtitysWithEntityName:(NSString *)name {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:name];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        NSError *deleteError = nil;
        [self.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
        [[YMADataBase sharedDataBase] saveContext];
    });
}

@end
