//
//  ViewPagerHeader_Private.h
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "ViewPagerHeader.h"

@interface ViewPagerHeader()

- (void)panBegan:(CGPoint)initialLocation;
- (void)panChanged:(CGPoint)position direction:(PanDirection)direction;
- (void)panEnded;

- (void)animateTo:(CGFloat)position duration:(CGFloat)duration option:(UIViewAnimationOptions)option direction:(PanDirection)direction;

@end
