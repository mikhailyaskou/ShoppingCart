//
//  YMAGoodsCell.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoodsCell.h"

@interface YMAGoodsCell ()

@property (weak, nonatomic) IBOutlet UIButton *inCartButton;

@end

@implementation YMAGoodsCell

- (IBAction)addToCart:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellButtonTapped:)]) {
        [self.delegate cellButtonTapped:sender];
    }
}

@end
