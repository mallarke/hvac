//
//  Utility.h
//  HVAC Planner
//
//  Created by mallarke on 7/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

typedef enum
{
    DateFormat_INITIAL,
    DateFormat_NO_TIME,
    DateFormat_FANCY
} DateFormat;

BOOL isNull(id object);

NSString *getDownImageName(NSString *defaultName);
UIButton *makeCustomButton(NSString *imageName, NSString *title, UIFont *font, UIColor *textColor, UIColor *shadowColor);

int intFromDictionary(NSDictionary *dictionary, NSString *key);
CGFloat floatFromDictionary(NSDictionary *dictionary, NSString *key);
NSString *stringFromDictionary(NSDictionary *dictionary, NSString *key);
BOOL boolFromDictionary(NSDictionary *dictionary, NSString *key);
double doubleFromDictionary(NSDictionary *dictionary, NSString *key);
NSTimeInterval timeIntervalFromDictionary(NSDictionary *dictionary, NSString *key);

NSDictionary *dictionaryFromDictionary(NSDictionary *dictionary, NSString *key);
NSArray *arrayFromDictionary(NSDictionary *dictionary, NSString *key);
NSString *dateFromDictionary(NSDictionary *dictionary, NSString *key);

NSDate *dateFromString(NSString *string);
NSString *string(int value);
NSString *stringFromDate(NSDate *date, DateFormat format);
