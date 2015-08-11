//
//  ViewController.m
//  CSMagnifyAnimationExample
//
//  Created by chaos on 8/11/15.
//  Copyright (c) 2015 ace. All rights reserved.
//

#import "ViewController.h"
#import "CSMagnifyView.h"

@interface ViewController ()

@property (nonatomic, weak) CSMagnifyView *mView;
@property (nonatomic, weak) CSMagnifyView *smallmView;
@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"pic.jpg"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.text = @"OSX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。";
    label.frame = self.view.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:label];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addMagnifyViewWithSize:CGSizeMake(150, 150)];
    [self addSmallMagnifyViewWithSize:CGSizeMake(50, 50)];
    
}

- (void)addMagnifyViewWithSize:(CGSize)size
{
    CSMagnifyView *mView = [[CSMagnifyView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    mView.needMagnifyView = self.imageView;
    UIPanGestureRecognizer *panPressRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(userPanPressedGuestureDetected:)];
    [mView addGestureRecognizer:panPressRecognizer];
    
    [self.view addSubview:mView];
    mView.touchPoint = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.mView = mView;
    
    [self addAniamtionLikeGameCenterBubble];
}

- (void)addSmallMagnifyViewWithSize:(CGSize)size
{
    CSMagnifyView *mView = [[CSMagnifyView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    mView.needMagnifyView = self.mView;
    mView.isSmall = YES;
    [self.mView addSubview:mView];
    mView.touchPoint = CGPointMake(CGRectGetWidth(self.mView.bounds)/2 , CGRectGetHeight(self.mView.bounds)/2 );
    self.smallmView = mView;
    
    [self addOrbitAniamtion];
}

- (void)userPanPressedGuestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        [self.mView.layer removeAnimationForKey:@"shakeAnimation"];
    }
    
    CSMagnifyView *mView = (CSMagnifyView *)recognizer.view;
    CGPoint point = [recognizer locationInView:self.view];
    mView.touchPoint = point;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self addCircleAnimation];
    }
}

- (void)addCircleAnimation
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 1.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.mView.frame, self.mView.bounds.size.width / 2 - 3, self.mView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.mView.layer addAnimation:pathAnimation forKey:@"shakeAnimation"];
    
}

- (void)addAniamtionLikeGameCenterBubble
{
    [self addCircleAnimation];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.mView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.mView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
    
}

- (void)addOrbitAniamtion
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.delegate = self;
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 3.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.mView.bounds, 30, 30);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.smallmView.layer addAnimation:pathAnimation forKey:@"circleAnimation"];
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSmallmViewDisplay)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    }
}

- (void)updateSmallmViewDisplay
{
    CALayer *layer = self.smallmView.layer.presentationLayer;
    self.smallmView.touchPoint = layer.position;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
