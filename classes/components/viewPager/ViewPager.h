//
//  ViewPager.h
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewPagerDelegate;

@interface ViewPager : UIView

@property (assign) id<ViewPagerDelegate> delegate;

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, readonly) int currentIndex;

- (void)setIndex:(int)index animated:(BOOL)animated;

@end

@protocol ViewPagerDelegate <NSObject>



@end
