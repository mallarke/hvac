//
//  RootViewController.m
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"

#pragma mark - RootViewController extension -

@interface RootViewController()

@property (nonatomic, retain) RootView *view;

@end

#pragma mark - RootViewController implementation

@implementation RootViewController

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{

    }

    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - View life cycle methods -

- (void)loadView
{
    self.view = [RootView object];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

@end
