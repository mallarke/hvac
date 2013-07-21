//
//  ViewPagerHeader.h
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - ViewPagerHeaderItem interface -

@interface ViewPagerHeaderItem : UIView

@property (nonatomic, retain) NSString *text;

@end

#pragma mark - ViewPagerHeader interface -

@interface ViewPagerHeader : UIView

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, retain) NSArray *items;

@end
