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
- (void)clearCoreData;
-(NSManagedObjectContext *)newBackgroundContext;

@end
