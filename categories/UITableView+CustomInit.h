//
//  UITableView+CustomInit.h
//  libUIComponents
//
//  Created by mallarke on 12/27/12.
//  Copyright (c) 2012 givepulse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CustomInit)

- (id)initTableView:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate;
+ (id)tableView:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate;

@end
