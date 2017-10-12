//
//  YMAOrderTableViewCell.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 02.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrderTableViewCell.h"

@interface YMAOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation YMAOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.mainView.bounds];
    self.mainView.layer.masksToBounds = NO;
    self.mainView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.mainView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.mainView.layer.shadowOpacity = 0.5f;
    //self.mainView.layer.shadowPath = shadowPath.CGPath;
}

@end
