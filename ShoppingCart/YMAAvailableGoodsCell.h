//
//  YMAAvailableGoodsCell.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 02.10.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCellDelegate.h"

@interface YMAAvailableGoodsCell : UITableViewCell <CartCellDelegate>

@property (nonatomic, weak) id<CartCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
