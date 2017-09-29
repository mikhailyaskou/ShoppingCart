//
//  YMACircularGradientView.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMACircularGradientView.h"

@implementation YMACircularGradientView


- (void)drawRect:(CGRect)rect {
    // Drawing Code
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Draw A Gradient from yellow to Orange
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor blueColor].CGColor, (id)[UIColor colorWithRed:0.11 green:0.88 blue:0.88 alpha:1.0].CGColor, nil];
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColors(myColorspace, (CFArrayRef) colors, nil);

    double circleWidth = self.viewForBaselineLayout.frame.size.width;
    double circleHeight = self.viewForBaselineLayout.frame.size.height;
    CGPoint theCenter = CGPointMake(circleWidth/2, circleHeight/2);
    // Account for orientation changes
    double radius = circleHeight;
    if (circleHeight < circleWidth) {
        radius = circleWidth;
    }
    CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation;
    CGContextDrawRadialGradient(context, myGradient, theCenter, 0.0, theCenter, radius/1.7, options);
}

@end
