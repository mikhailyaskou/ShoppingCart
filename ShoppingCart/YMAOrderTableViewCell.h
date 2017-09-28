//
//  YMAOrderTableViewCell.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 02.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMAOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
