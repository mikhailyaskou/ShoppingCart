//
//  YMABackEnd.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 27.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMABackEnd.h"
#import "AppDelegate.h"
#import "YMADataBase.h"
#import "YMADateHelper.h"
#import "YMAShopService.h"
#import "YMAOrder+CoreDataClass.h"
#import "YMAGoods+CoreDataProperties.h"
#import "YMAUser+CoreDataClass.h"
#import "YMAOrder+CoreDataClass.h"
#import "YMAOrderBook+CoreDataClass.h"
#import "YMAJSONParser.h"

@interface YMADataBase () <NSURLSessionDelegate>

@end

@implementation YMABackEnd

+ (void)fetchPhone {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:@"http://localhost:3000/catalog"]
                           completionHandler:^(NSArray *jsonResponse){
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAGoods *entityProduct = [NSEntityDescription insertNewObjectForEntityForName:@"YMAGoods" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
                                       entityProduct.code = (int32_t) item[@"id"];
                                       entityProduct.name = item[@"title"];
                                       entityProduct.price = [item[@"price"] doubleValue];
                                       NSLog(@"%@", entityProduct.name);
                                   }
                                   [YMADataBase.sharedDataBase saveContext];
                               });
                           }];
}

+ (void)fetchOrders {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:@"http://localhost:3000/order"]
                           completionHandler:^(NSArray *jsonResponse){
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSManagedObjectContext *moc = [YMADataBase.sharedDataBase managedObjectContext];
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAOrder *order = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrder" inManagedObjectContext:moc];
                                       [[YMAShopService.sharedShopService currentUser] addOrdersObject:order];
                                       order.date = [YMADateHelper dateFromString:item[@"date"]];
                                       order.orderId = (int16_t) item[@"id"];
                                       order.state = (int16_t) item[@"state"];
                                       NSArray *goodsIds = [item[@"catalog"] valueForKey:@"id"];
                                       for (NSNumber *idGoods in goodsIds) {
                                           YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrderBook" inManagedObjectContext:moc];
                                           orderBook.goods = [YMAShopService.sharedShopService goodsById:idGoods];
                                           orderBook.order = order;
                                           [order addBookOrdersObject:orderBook];
                                       }
                                       NSLog(@"%@", order.date);
                                   }
                                   [[YMADataBase sharedDataBase] saveContext];
                               });
                           }];
}


+ (void)post:(YMAOrder *)order {

    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/order"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSArray *goodsIdArray = order.bookOrders.allObjects;
    NSMutableArray *codesOfGoods = [NSMutableArray new];
    for (YMAOrderBook *goodsOrder in goodsIdArray) {
        NSDictionary *goodsID = @{@"id": @(goodsOrder.goods.code)};
        [codesOfGoods addObject:goodsID];
    }
    NSString *orderDate = [YMADateHelper stringFromDate:order.date];
    NSString *orderState = [NSString stringWithFormat:@"%d", order.state];
    NSString *orderId = [NSString stringWithFormat:@"%d", order.orderId];
    NSDictionary *mapData = @{@"date": orderDate, @"state": orderState, @"catalog": codesOfGoods, @"id": orderId};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [postDataTask resume];
}

/*+ (void)fetchPhone {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://localhost:3000/catalog"]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        NSError *e = nil;

                        if (!jsonResponse) {
                            NSLog(@"Error parsing JSON: %@", e);
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                for (NSDictionary *item in jsonResponse) {
                                    YMAGoods *entityProduct =
                                            [NSEntityDescription insertNewObjectForEntityForName:@"YMAGoods" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
                                    [entityProduct setValue:item[@"id"] forKey:@"code"];
                                    [entityProduct setValue:item[@"title"] forKey:@"name"];
                                    [entityProduct setValue:@([item[@"price"] doubleValue]) forKey:@"price"];
                                    NSLog(@"%@", entityProduct.name);
                                }
                                [[YMADataBase sharedDataBase] saveContext];
                            });
                        }
                    }
                    else {
                        //Web server is returning an error
                    }
                }
                else {
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}*/

/*+ (void)fetchOrders {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[self NSURLWithResourcesName:@"order"]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        NSError *e = nil;
                        if (!jsonResponse) {
                            NSLog(@"Error parsing JSON: %@", e);
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSManagedObjectContext *moc = [[YMADataBase sharedDataBase] managedObjectContext];
                                for (NSDictionary *item in jsonResponse) {
                                    YMAOrder *order = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrder" inManagedObjectContext:moc];
                                    [[YMAShopService.sharedShopService currentUser] addOrdersObject:order];
                                    [order setValue:[YMADateHelper dateFromString:item[@"date"]] forKey:@"date"];
                                    [order setValue:@([item[@"id"] integerValue]) forKey:@"orderId"];
                                    [order setValue:@([item[@"state"] doubleValue]) forKey:@"state"];
                                    NSArray *goodsIds = [item[@"catalog"] valueForKey:@"id"];
                                    for (NSNumber *idGoods in goodsIds) {
                                        YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrderBook" inManagedObjectContext:moc];
                                        orderBook.goods = [[YMAShopService sharedShopService] goodsById:idGoods];
                                        orderBook.order = order;
                                        [order addBookOrdersObject:orderBook];
                                    }
                                }
                                [[YMADataBase sharedDataBase] saveContext];
                            });
                        }
                    }
                    else {
                        //Web server is returning an error
                    }
                }
                else {
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}*/

@end
