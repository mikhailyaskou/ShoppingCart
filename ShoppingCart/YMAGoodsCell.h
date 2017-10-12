//
//  YMAGoodsCell.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchDelegateForGoodsCell <NSObject>
- (void)touchedTheCell:(UIButton *)button;
@end

@interface YMAGoodsCell : UITableViewCell

@property (nonatomic, assign) id <TouchDelegateForGoodsCell> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
