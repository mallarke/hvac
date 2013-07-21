//
//  RootView.m
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "RootView.h"

#import "ViewPager.h"

#pragma mark - RootView extension -

@interface RootView() <ViewPagerDelegate>

@property (retain) ViewPager *viewPager;

@end

#pragma mark - RootView implementation

@implementation RootView

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.layer.contents = (id)[UIImage image:BASE_TEXTURE_IMAGE].CGImage;
        
        NSMutableArray *vcs = [NSMutableArray array];
        
        UIViewController *vc = [UIViewController object];
        vc.title = @"Rectangle";
        [vcs addObject:vc];
        
        vc = [UIViewController object];
        vc.title = @"Round";
        vc.view.backgroundColor = PURPLE_COLOR;
        [vcs addObject:vc];
        
        vc = [UIViewController object];
        vc.title = @"Bob";
        [vcs addObject:vc];
        
        self.viewPager = [ViewPager object];
        self.viewPager.delegate = self;
        self.viewPager.viewControllers = vcs;
        [self addSubview:self.viewPager];
    }

    return self;
}

- (void)dealloc
{
    self.viewPager = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];

    [self.viewPager sizeToFit];
}

#pragma mark - Getter/Setter methods -

#pragma mark - ViewPagerDelegate methods -

@end
