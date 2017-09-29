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
    // Initialization code
    [YMAPrettyButtonHelper makePrettyButton:self.inCartButton];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addToCart:(UIButton *)sender {

    //add this condition to all the actions becz u need to get the index path of tapped cell contains the button
    if ([self.delegate respondsToSelector:@selector(touchedTheCell:)]) {
        [self.delegate touchedTheCell:sender];
    }
}


@end
