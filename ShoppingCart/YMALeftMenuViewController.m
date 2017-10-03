//
//  YMALeftMenuViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMALeftMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YMACircularGradientView.h"
#import "PGDrawerTransition.h"

@interface YMALeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet YMACircularGradientView *menuView;

@end

@implementation YMALeftMenuViewController

+ (YMALeftMenuViewController *)sharedInstance {
    static YMALeftMenuViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _sharedInstance = [sb instantiateViewControllerWithIdentifier:@"YMALeftMenuViewController"];
    });
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //round image with white border
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 6.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //left menu with rounded corner and shadow under it
    //create menu BezierPath for menu and shadow shape;
    CGRect frame = self.view.frame;
    frame.size.width = self.view.frame.size.width - self.view.frame.size.width / 5;
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:frame
                              byRoundingCorners:( UIRectCornerBottomRight | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(CGRectGetHeight(frame)/5, 0)
                              ];
    //add mask to menu
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.menuView.layer.mask = maskLayer;
    //add shadow to view under menu
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor colorWithRed:0.11 green:0.88 blue:0.88 alpha:1.0].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(10, 0);
    self.view.layer.shadowRadius = 50;
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = maskPath.CGPath;
}

- (IBAction)mainButtonTapped:(id)sender {  
    [self makeTransitionToViewControllerWithIdentifier:@"YMAGoodsViewController"];
}

- (IBAction)ordersButtonTapped:(id)sender {
    [self makeTransitionToViewControllerWithIdentifier:@"YMAOrdersViewController"];
}

- (IBAction)cartButtonTapped:(id)sender {
    [self makeTransitionToViewControllerWithIdentifier:@"YMACartOrderModalViewController"];
}

-(void)makeTransitionToViewControllerWithIdentifier:(NSString *)identifier {
     [self.drawerTransition dismissDrawerViewController];
    if (![self.drawerTransition.targetViewController.restorationIdentifier isEqualToString:identifier]) {       
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.drawerTransition.targetViewController.navigationController showViewController:view sender:nil];
        [self.drawerTransition setTargetViewController:view];
    }
}



@end
