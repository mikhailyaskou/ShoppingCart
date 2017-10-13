//
//  YMALeftMenuViewController.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGDrawerTransition;

@interface YMALeftMenuViewController : UIViewController

@property (nonatomic, strong) PGDrawerTransition *drawerTransition;

+ (YMALeftMenuViewController *)sharedInstance;

@end
