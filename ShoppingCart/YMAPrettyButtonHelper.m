//
//  YMAPrettyButtonHelper.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 01.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAPrettyButtonHelper.h"

@implementation YMAPrettyButtonHelper

+ (void)makePrettyButton:(UIButton *)button {
    button.layer.cornerRadius = 8.0f;
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowRadius = 12;
    button.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
}

@end
