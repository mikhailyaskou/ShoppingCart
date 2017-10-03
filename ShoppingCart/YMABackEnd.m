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

@implementation YMABackEnd

+ (void)fetchPhoneWithCompletionHandler:(void (^)())completionHandler {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:@"http://localhost:3000/catalog"]
                           completionHandler:^(NSArray *jsonResponse) {
                               NSOperation *mainOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAGoods *entityProduct = [NSEntityDescription insertNewObjectForEntityForName:@"YMAGoods" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
                                       entityProduct.code = [item[@"id"] integerValue];
                                       entityProduct.name = item[@"title"];
                                       entityProduct.price = [item[@"price"] doubleValue];
                                       entityProduct.available = [item[@"available"] integerValue];
                                       entityProduct.image = item[@"image"];
                                       NSLog(@"%@", entityProduct.name);
                                   }
                                   [YMADataBase.sharedDataBase saveContext];
                               }];
                               NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   completionHandler();
                               }];
                               [completionOperation addDependency:mainOperation];
                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                               [queue addOperation:mainOperation];
                               [queue addOperation:completionOperation];
                           }];

}

+ (void)fetchOrdersWithCompletionHandler:(void (^)())completionHandler {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:@"http://localhost:3000/order"]
                           completionHandler:^(NSArray *jsonResponse) {
                               NSOperation *mainOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   NSManagedObjectContext *moc = [YMADataBase.sharedDataBase managedObjectContext];
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAOrder *order = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrder" inManagedObjectContext:moc];
                                       [[YMAShopService.sharedShopService currentUser] addOrdersObject:order];
                                       order.date = [YMADateHelper dateFromString:item[@"date"]];
                                       order.orderId = item[@"id"];
                                       order.state = item[@"state"];
                                       NSArray *goodsIds = [item[@"catalog"] valueForKey:@"id"];
                                       for (NSNumber *idGoods in goodsIds) {
                                           YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrderBook" inManagedObjectContext:moc];
                                           orderBook.goods = [YMAShopService.sharedShopService goodsById:idGoods];
                                           orderBook.order = order;
                                           [order addBookOrdersObject:orderBook];
                                       }
                                   }
                                   [[YMADataBase sharedDataBase] saveContext];
                               }];
                               NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   completionHandler();
                               }];
                               [completionOperation addDependency:mainOperation];
                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                               [queue addOperation:mainOperation];
                               [queue addOperation:completionOperation];
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

@end
