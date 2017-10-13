//
//  YMAProductCell.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 12.10.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMAProductCellDelegate <NSObject>
- (void)cellButtonTapped:(UIButton *)sender;
@end

@interface YMAProductCell : UITableViewCell

@property (weak, nonatomic) id <YMAProductCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
