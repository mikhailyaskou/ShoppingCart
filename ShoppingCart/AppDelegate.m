//
//  AppDelegate.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "AppDelegate.h"
#import "YMADataBase.h"
#import "YMADataBase.h"
#import "YMABackEnd.h"
#import "YMAShopService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 //   [YMADataBase.sharedDataBase clearCoreData];
   // [YMADataBase.sharedDataBase deleteAllEtitysWithEntityName:@"YMAGoods"];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [YMADataBase.sharedDataBase saveContext];
}

@end
