//
//  YMAGreenButton.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.10.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAShopButton.h"

@implementation YMAShopButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 6;
}

@end
