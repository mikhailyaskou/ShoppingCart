//
//  YMAGoodsCell.h
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>


//@class CellTypeOne; //if u want t pass cell to controller
@protocol TouchDelegateForGoodsCell <NSObject> //this delegate is fired each time you clicked the cell
- (void)touchedTheCell:(UIButton *)button;
//- (void) touchedTheCell:(CellTypeOne *)cell; //if u want t send entire cell this may give error add `@class CellTypeOne;` at the beginning
@end

@interface YMAGoodsCell : UITableViewCell

@property (nonatomic, assign) id <TouchDelegateForGoodsCell> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
