//
//  DataController.m
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "DataController.h"

#pragma mark - DataController extension -

@interface DataController()

- (id)initialize;

@end

#pragma mark - DataController implementation

@implementation DataController

static DataController *_singleton = nil;

#pragma mark - Constructor/Destructor methods -

+ (DataController *)sharedData
{
    @synchronized(self)
    {
        if(!_singleton)
        {
            _singleton = [[DataController alloc] initialize];
        }
        
        return _singleton;
    }
}

- (id)init
{
    NSAssert(false, @"do not attempt to initialize another instance of %@.  use the singleton instead", NSStringFromClass([self class]));
    return nil;
}

- (id)initialize
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

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

@end

