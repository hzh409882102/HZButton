//
//  HZButton.m
//  UCSCommon
//
//  Created by huangzh on 2020/6/9.
//  Copyright © 2020 simba.pro. All rights reserved.
//

#import "HZButton.h"
#import <objc/runtime.h>

@implementation HZButton
{
    BOOL                _inited;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

// thanks to @ilikeido
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    if ( NO == _inited )
    {
        [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        _inited = YES;
    }
}

- (void)didTouchUpInside
{
    UIView * view = self;
    while (nil != view )
    {
        [self handleSelectorInViewControllerView:view];
        NSString * selectorName = [NSString stringWithFormat:@"handleUISignal_%@:",_tagString];
        SEL selector = NSSelectorFromString( selectorName );
        if ( nil == view.superview )
            break;

        view = view.superview;
        Class cls = [view class];
        if ([view respondsToSelector:selector])
        {
            [view performSelector:selector withObject:self];
        }
        
    }
}

- (NSObject *)signalTarget
{
    UIViewController * nextController = [self viewController:self];
    if ( nextController )
    {
        return nextController;
    }

    return self;
}

- (UIViewController *)viewController:(UIView *)view
{
    UIResponder * nextResponder = [view nextResponder];

    if ( nextResponder && [nextResponder isKindOfClass:[UIViewController class]] )
    {
        return (UIViewController *)nextResponder;
    }
    
    return nil;
}

- (void)handleSelectorInViewControllerView:(UIView *)view
{
    NSString * selectorName = [NSString stringWithFormat:@"handleUISignal_%@:",_tagString];
    SEL selector = NSSelectorFromString( selectorName );
    UIViewController * vc = [self viewController:view];
    if (vc)
    {
        if ([vc respondsToSelector:selector])
        {
            [vc performSelector:selector withObject:self];
        }
    }
}

@end
