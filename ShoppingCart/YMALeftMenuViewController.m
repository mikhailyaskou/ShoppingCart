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

@interface YMALeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

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
    
    //left menu with rounded corner
    
    CGRect frame = self.view.frame;
    frame.size.width = self.view.frame.size.width - self.view.frame.size.width / 5;

    UIBezierPath *maskPath = [UIBezierPath
            bezierPathWithRoundedRect:frame
                    byRoundingCorners:( UIRectCornerBottomRight | UIRectCornerTopRight)
                          cornerRadii:CGSizeMake(CGRectGetHeight(frame)/5, 0)
    ];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    
    
    
    CALayer *containerLayer = [[CALayer alloc]insertSublayer:self.view.layer];
    
     [self.view.layer addSublayer:containerLayer];
    
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(20.0f, 20.0f);
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = maskPath.CGPath;

    

   
   }


@end
