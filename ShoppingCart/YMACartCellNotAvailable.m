//
//  YMACartCellNotAvailable.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 02.10.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMACartCellNotAvailable.h"

@implementation YMACartCellNotAvailable

- (void)awakeFromNib {
    [super awakeFromNib];
    [self rotate:self.nameLabel];
    [self rotate:self.codeLabel];
    [self rotate:self.descriptionLabel];
}

- (void)rotate:(UILabel *)label {
    label.transform = CGAffineTransformMakeRotation(M_PI * (2) / 180.0);
}

@end
