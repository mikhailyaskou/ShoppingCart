//
//  YMAGoodsCell.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoodsCell.h"
#import "YMAPrettyButtonHelper.h"

@interface YMAGoodsCell ()
@property (weak, nonatomic) IBOutlet UIButton *inCartButton;

@end

@implementation YMAGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inCartButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.inCartButton.layer.shadowOpacity = 0.5f;
    self.inCartButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.inCartButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.inCartButton.layer.borderWidth = 0.5f;
    self.inCartButton.layer.cornerRadius = 6;
}

- (IBAction)addToCart:(UIButton *)sender {

    //add this condition to all the actions becz u need to get the index path of tapped cell contains the button
    if ([self.delegate respondsToSelector:@selector(touchedTheCell:)]) {
        [self.delegate touchedTheCell:sender];
    }
}


@end
