//
//  UIImageView+CustomInit.m
//  libgp
//
//  Created by mallarke on 5/21/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import "UIImageView+CustomInit.h"

@implementation UIImageView (CustomInit)

+ (id)imageViewWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [self imageView:image];
}

+ (id)imageView:(UIImage *)image
{
    return [[[self alloc] initWithImage:image] autorelease];
}

@end
