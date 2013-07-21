//
//  Utility.m
//  HVAC Planner
//
//  Created by mallarke on 7/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "Utility.h"

static NSDateFormatter *_dateFormatter = nil;

NSString * const kInitialDateFormat = @"yyyy-MM-dd HH:mm:ss z";
NSString * const kDateFormat_noTime = @"MM/dd/yyyy";
NSString * const kDateFormat_fancy = @"MMM d, yyyy";

static NSDateFormatter *dateFormatter(NSString *format)
{
    if(!_dateFormatter)
    {
        _dateFormatter = [NSDateFormatter new];
    }
    
    _dateFormatter.dateFormat = format;
    
    return _dateFormatter;
}

BOOL isNull(id object)
{
    return (object == [NSNull null]);
}

NSString *getDownImageName(NSString *defaultName)
{
    return [defaultName stringByAppendingString:@"_down"];
}

UIButton *makeCustomButton(NSString *imageName, NSString *title, UIFont *font, UIColor *textColor, UIColor *shadowColor)
{
    NSString *downName = getDownImageName(imageName);
    
    UIImage *defaultImage = [UIImage resizableImageNamed:imageName];
    UIImage *downImage = [UIImage resizableImageNamed:downName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:defaultImage forState:UIControlStateNormal];
    [button setBackgroundImage:downImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];    
    
    UILabel *label = button.titleLabel;
    label.font = font;
    label.shadowOffset = CGSizeMake(0, 1);
    
    return button;
}

int intFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return 0;
    }
    
    NSString *string = stringFromDictionary(dictionary, key);
    
    if(!string)
    {
        string = [dictionary objectForKey:key];
        if(isNull(string) || ![string isKindOfClass:[NSNumber class]])
        {
            return 0;
        }
    }
    
    return [string intValue];
}

CGFloat floatFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return 0;
    }
    
    NSString *string = stringFromDictionary(dictionary, key);
    
    if(!string)
    {
        string = [dictionary objectForKey:key];
        if(isNull(string) || ![string isKindOfClass:[NSNumber class]])
        {
            return 0;
        }
    }
    
    return [string floatValue];
}

NSString *stringFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return nil;
    }
    
    NSString *string = [dictionary objectForKey:key];
    if(isNull(string) || ![string isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    if([string isEqualToString:@""])
    {
        return nil;
    }
    
    return string;
}

BOOL boolFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return false;
    }
    
    NSString *string = stringFromDictionary(dictionary, key);
    if(!string)
    {
        return intFromDictionary(dictionary, key);
    }
    
    return [string boolValue];
}

double doubleFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return 0;
    }
    
    NSNumber *number = [dictionary objectForKey:key];
    if(isNull(number))
    {
        return 0;
    }
    
    return [number doubleValue];
}

NSTimeInterval timeIntervalFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return 0;
    }
    
    NSNumber *number = [dictionary objectForKey:key];
    if(isNull(number))
    {
        return 0;
    }
    
    return [number doubleValue];
}

NSDictionary *dictionaryFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return nil;
    }
    
    NSDictionary *content = [dictionary objectForKey:key];
    if(isNull(content) || ![content isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    return content;
}

NSArray *arrayFromDictionary(NSDictionary *dictionary, NSString *key)
{
    if(!key || !dictionary)
    {
        return nil;
    }
    
    NSArray *array = [dictionary objectForKey:key];
    if(isNull(array) || ![array isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    return array;
}

static void convertTime(NSString **time)
{
    *time = [*time stringByReplacingOccurrencesOfString:@"+" withString:@" +"];
    *time = [*time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

NSString *dateFromDictionary(NSDictionary *json, NSString *key)
{
    NSString *date = stringFromDictionary(json, key);
    
    if(date)
    {
        convertTime(&date);
        return date;
    }
    
    return nil;
}

NSDate *dateFromString(NSString *string)
{
    return [dateFormatter(kInitialDateFormat) dateFromString:string];
}

NSString *string(int value)
{
    return [NSString stringWithFormat:@"%i", value];
}

NSString *stringFromDate(NSDate *date, DateFormat format)
{
    NSString *formatText = nil;
    switch(format)
    {
        case DateFormat_INITIAL:
            formatText = kInitialDateFormat;
            break;
            
        case DateFormat_NO_TIME:
            formatText = kDateFormat_noTime;
            break;
            
        case DateFormat_FANCY:
            formatText = kDateFormat_fancy;
            break;
    }
    
    return [dateFormatter(formatText) stringFromDate:date];
}

PanDirection get_pan_direction(CGPoint currentLocation, CGPoint initialLocation)
{
    CGFloat cX = currentLocation.x;
    CGFloat iX = initialLocation.x;
    
    if(cX == iX)
    {
        return PanDirection_NONE;
    }
    
    if(cX < iX)
    {
        return PanDirection_FORWARDS;
    }
    
    return PanDirection_BACKWARDS;
}











