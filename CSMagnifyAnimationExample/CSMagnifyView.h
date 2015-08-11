//
//  CSMagnifyView.h
//  CSMagnifyAnimation
//
//  Created by chaos on 8/10/15.
//  Copyright (c) 2015 ace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMagnifyView : UIView

@property (nonatomic, weak) UIView *needMagnifyView; //需要放大的view

@property (nonatomic, assign) CGPoint touchPoint; //触摸点

@property (nonatomic, assign) BOOL isSmall;
@end
