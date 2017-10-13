//
//  YMAProductCell.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 12.10.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAProductCell.h"

@implementation YMAProductCell

- (IBAction)cellButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellButtonTapped:)]) {
        [self.delegate cellButtonTapped:sender];
    }
}

@end
