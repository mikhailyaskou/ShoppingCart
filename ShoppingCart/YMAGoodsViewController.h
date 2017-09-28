//
//  YMAGoodsViewController.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAGoodsCell.h"

@interface YMAGoodsViewController : UITableViewController <TouchDelegateForGoodsCell>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
