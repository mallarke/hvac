//
//  DataController.h
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

@property (readonly) NSArray *favorites;

+ (DataController *)sharedData;

- (void)addFavorite:(id)item;

- (void)saveDataContext;

@end
