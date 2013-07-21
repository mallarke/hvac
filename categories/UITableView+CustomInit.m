//
//  UITableView+CustomInit.m
//  libUIComponents
//
//  Created by mallarke on 12/27/12.
//  Copyright (c) 2012 givepulse, Inc. All rights reserved.
//

#import "UITableView+CustomInit.h"

@implementation UITableView (CustomInit)

- (id)initTableView:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate
{
    self = [super init];
    
    if(self)
    {
        self.dataSource = datasource;
        self.delegate = delegate;
        self.separatorColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

+ (id)tableView:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate
{
    return [[[self alloc] initTableView:datasource delegate:delegate] autorelease];
}

@end
