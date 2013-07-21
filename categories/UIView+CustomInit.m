//
//  UIView+CustomInit.m
//  libUIComponents
//
//  Created by mallarke on 12/19/12.
//  Copyright (c) 2012 givepulse, Inc. All rights reserved.
//

#import "UIView+CustomInit.h"

@implementation UIView (CustomInit)

+ (id)viewWithFrame:(CGRect)frame
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

- (void)removeAllSubviews
{
    for(UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
