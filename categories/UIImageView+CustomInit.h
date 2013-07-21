//
//  UIImageView+CustomInit.h
//  libgp
//
//  Created by mallarke on 5/21/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CustomInit)

+ (id)imageViewWithName:(NSString *)name;
+ (id)imageView:(UIImage *)image;

@end
