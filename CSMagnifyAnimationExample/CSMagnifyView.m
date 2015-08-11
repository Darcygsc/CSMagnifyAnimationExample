//
//  CSMagnifyView.m
//  CSMagnifyAnimation
//
//  Created by chaos on 8/10/15.
//  Copyright (c) 2015 ace. All rights reserved.
//

#import "CSMagnifyView.h"

@implementation CSMagnifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    
    self.center = CGPointMake(touchPoint.x,self.isSmall ?touchPoint.y -50 : touchPoint.y);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width/2, self.frame.size.height/2);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, - _touchPoint.x, -_touchPoint.y);
    [self.needMagnifyView.layer renderInContext:context];
    
}


@end
