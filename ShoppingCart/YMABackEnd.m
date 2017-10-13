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
#import "YMAOrderBook+CoreDataClass.h"
#import "YMAJSONParser.h"
#import "YMAConstants.h"


static NSString *const YMACatalogURL = @"http://localhost:3000/catalog";
static NSString *const YMAOrderURL = @"http://localhost:3000/order";
static NSString *const YMACodeFieldName = @"code";
static NSString *const YMAIdFieldName = @"id";
static NSString *const YMATitleFieldName = @"title";
static NSString *const YMAPriceFieldName = @"price";
static NSString *const YMAAvailableFieldName = @"available";
static NSString *const YMAImageFieldName = @"image";
static NSString *const YMAOrderIdFieldName = @"orderId";
static NSString *const YMADateFieldName = @"date";
static NSString *const YMAStateFieldName = @"state";
static NSString *const YMACatalogFieldName = @"catalog";

@implementation YMABackEnd

+ (void)fetchPhoneWithCompletionHandler:(void (^)())completionHandler {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:YMACatalogURL]
                           completionHandler:^(NSArray *jsonResponse) {
                               NSManagedObjectContext *moc = [YMADataBase.sharedDataBase newBackgroundContext];
                               NSOperation *mainOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   NSArray *allEntity = [YMADataBase.sharedDataBase allEntitiesWithName:YMAGoodsEntitiesName inContext:moc];
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAGoods *entityProduct = (YMAGoods *) [YMADataBase.sharedDataBase findOrCreateEntityWithName:YMAGoodsEntitiesName
                                                                                                                     findByFieldName:YMACodeFieldName
                                                                                                                           withValue:item[YMAIdFieldName]
                                                                                                            searchInArrayWithEntitys:allEntity
                                                                                                                           inContext:moc];
                                       entityProduct.code = [item[YMAIdFieldName] intValue];
                                       entityProduct.name = item[YMATitleFieldName];
                                       entityProduct.price = [item[YMAPriceFieldName] doubleValue];
                                       entityProduct.available = [item[YMAAvailableFieldName] intValue];
                                       entityProduct.image = item[YMAImageFieldName];
                                       NSLog(@"%@", entityProduct.name);
                                   }
                                   [YMADataBase.sharedDataBase saveContext:moc];
                               }];
                               NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   if (completionHandler) {
                                       completionHandler();
                                   }
                               }];
                               [completionOperation addDependency:mainOperation];
                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                               [queue addOperation:mainOperation];
                               [queue addOperation:completionOperation];
                           }];

}

+ (void)fetchOrdersWithCompletionHandler:(void (^)())completionHandler {
    [YMAJSONParser.sharedInstance parseByURL:[NSURL URLWithString:YMAOrderURL]
                           completionHandler:^(NSArray *jsonResponse) {
                               //main operation
                               NSOperation *mainOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   NSManagedObjectContext *moc = [YMADataBase.sharedDataBase newBackgroundContext];
                                   //get current user if not exist it will be created in sharedShopService;
                                   YMAUser *currentUser = [moc existingObjectWithID:[YMAShopService.sharedShopService currentUserManagedObjectID] error:nil];

                                   NSArray *allGoods = [YMADataBase.sharedDataBase allEntitiesWithName:YMAGoodsEntitiesName inContext:moc];
                                   NSArray *allOrders = [YMADataBase.sharedDataBase allEntitiesWithName:YMAOrderEntityName inContext:moc];
                                   for (NSDictionary *item in jsonResponse) {
                                       YMAOrder *order = (YMAOrder *) [YMADataBase.sharedDataBase findOrCreateEntityWithName:YMAOrderEntityName
                                                                                                             findByFieldName:YMAOrderIdFieldName
                                                                                                                   withValue:item[YMAIdFieldName]
                                                                                                    searchInArrayWithEntitys:allOrders
                                                                                                                   inContext:moc];
                                       if (order.date == nil) {
                                           [currentUser addOrdersObject:order];
                                       }
                                       //update order data
                                       order.date = [YMADateHelper dateFromString:item[YMADateFieldName]];
                                       order.orderId = [item[YMAIdFieldName] intValue];
                                       order.state = [item[YMAStateFieldName] intValue];
                                       //remove all order positions before reloading
                                       [order removeBookOrders:order.bookOrders];
                                       NSArray *goodsIds = [item[YMACatalogFieldName] valueForKey:YMAIdFieldName];
                                       //create all order positions
                                       for (NSNumber *idGoods in goodsIds) {
                                           YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:YMAOrderBookEntityName inManagedObjectContext:moc];
                                           YMAGoods *entityProduct = (YMAGoods *) [YMADataBase.sharedDataBase findOrCreateEntityWithName:YMAGoodsEntitiesName
                                                                                                                         findByFieldName:YMACodeFieldName withValue:idGoods
                                                                                                                searchInArrayWithEntitys:allGoods
                                                                                                                               inContext:moc];
                                           //add order positions
                                           [entityProduct addOrderBooksObject:orderBook];
                                           [order addBookOrdersObject:orderBook];
                                       }
                                   }

                                   [YMADataBase.sharedDataBase saveContext:moc];
                               }];
                               NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
                                   if (completionHandler) {
                                       completionHandler();
                                   }
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
    NSURL *url = [NSURL URLWithString:YMAOrderURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSArray *goodsIdArray = order.bookOrders.allObjects;
    NSMutableArray *codesOfGoods = [NSMutableArray new];
    for (YMAOrderBook *goodsOrder in goodsIdArray) {
        NSDictionary *goodsID = @{YMAIdFieldName: @(goodsOrder.goods.code)};
        [codesOfGoods addObject:goodsID];
    }
    NSString *orderDate = [YMADateHelper stringFromDate:order.date];
    NSString *orderState = [NSString stringWithFormat:@"%d", order.state];
    NSString *orderId = [NSString stringWithFormat:@"%d", order.orderId];
    NSDictionary *mapData = @{YMACatalogFieldName: codesOfGoods,
            YMAStateFieldName: orderState,
            YMADateFieldName: orderDate
    };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            NSLog(@"Error %@", error);
    }];
    [postDataTask resume];
}

@end

