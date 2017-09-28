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
#import <CoreData/CoreData.h>
#import "Order+CoreDataClass.h"
#import "Goods+CoreDataProperties.h"
#import "YMADateHelper.h"
#import "Order+CoreDataClass.h"
#import "YMAShopService.h"
#import "OrderBook+CoreDataProperties.h"


@interface YMADataBase () <NSURLSessionDelegate>

@end

@implementation YMABackEnd

+ (NSURL *)NSURLWithResourcesName:(NSString*)name {
    NSString *urlAsString = [NSString stringWithFormat:@"http://localhost:3000/%@", name];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    return [NSURL URLWithString:encodedUrlAsString];
}

+ (void)fetchPhone {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[self NSURLWithResourcesName:@"catalog"]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        NSError *e = nil;
                        
                        if (!jsonResponse) {
                            NSLog(@"Error parsing JSON: %@", e);
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                for (NSDictionary *item in jsonResponse) {
                                    Goods *entityProduct =
                                    [NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
                                    [entityProduct setValue:item[@"id"] forKey:@"code"];
                                    [entityProduct setValue:item[@"title"] forKey:@"name"];
                                    [entityProduct setValue:@([item[@"price"] doubleValue]) forKey:@"price"];
                                    NSLog(@"%@", entityProduct.name);
                                }
                                [[YMADataBase sharedDataBase] saveContext];
                            });
                        }
                    } else {
                        //Web server is returning an error
                    }
                } else {
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}

+ (void)fetchOrders {
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
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSManagedObjectContext *moc = [[YMADataBase sharedDataBase]managedObjectContext];
                                for (NSDictionary *item in jsonResponse) {
                                    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:moc];
                                    [[[YMAShopService sharedShopService] currentUser] addOrdersObject:order];
                                    [order setValue:[YMADateHelper dateFromString:item[@"date"]] forKey:@"date"];
                                    [order setValue:@([item[@"id"] integerValue]) forKey:@"orderId"];
                                    [order setValue:@([item[@"state"] doubleValue]) forKey:@"state"];
                                    NSArray *goodsIds = [item[@"catalog"] valueForKey:@"id"];
                                    for (NSNumber *idGoods in goodsIds) {
                                        OrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"OrderBook" inManagedObjectContext:moc];
                                        orderBook.goods = [[YMAShopService sharedShopService] goodsById:idGoods];
                                        orderBook.order = order;
                                        [order addBookOrdersObject:orderBook];
                                    }
                                }
                                [[YMADataBase sharedDataBase] saveContext];
                            });
                        }
                    } else {
                        //Web server is returning an error
                    }
                } else {
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}


+ (void) post:(Order *)order {
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self NSURLWithResourcesName:@"order"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSArray *goodsIdArray = order.bookOrders.allObjects;
    NSMutableArray *codesOfGoods = [NSMutableArray new];
    
    for (OrderBook *goodsOrder in goodsIdArray) {
        
        NSDictionary *goodsID = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:goodsOrder.goods.code], @"id", nil];
        [codesOfGoods addObject: goodsID];
    }
    NSString *orderDate = [YMADateHelper stringFromDate:order.date];
    NSString *orderState = [NSString stringWithFormat:@"%d", order.state];
    NSString *orderId = [NSString stringWithFormat:@"%d", order.orderId];
    NSDictionary *mapData = [[NSDictionary alloc]initWithObjectsAndKeys:orderDate, @"date", orderState, @"state", codesOfGoods, @"catalog", orderId, @"id", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {       
    }];
    
    [postDataTask resume];
    
}

@end
