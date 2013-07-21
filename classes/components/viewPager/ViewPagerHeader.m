//
//  ViewPagerHeader.m
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "ViewPagerHeader_Private.h"

#define HEADER_MIN_ALPHA 0.4

#pragma mark - ViewPagerHeaderItem extension -

@interface ViewPagerHeaderItem()

@property (assign) int index;
@property (assign) BOOL isMovable;

@property (retain) UIView *backgroundView;
@property (retain) UILabel *label;

@end

#pragma mark - ViewPagerHeaderItem implementation

@implementation ViewPagerHeaderItem

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
	{
        [super setBackgroundColor:TRANSPARENT_COLOR];
        
        self.backgroundView = [UIView object];
        self.backgroundView.alpha = 0.4;
        self.backgroundView.backgroundColor = ORANGE_COLOR;
        [self addSubview:self.backgroundView];
        
        self.label = [UILabel object];
        self.label.backgroundColor = TRANSPARENT_COLOR;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.contentMode = UIViewContentModeCenter;
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)dealloc
{
    self.backgroundView = nil;
    self.label = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)sizeToFit
{
    [self.label sizeToFit];
    
    CGSize constrainedSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.8, VIEW_PAGER_HEADER_HEIGHT);
    CGFloat width = [self.text sizeWithFont:self.label.font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping].width;
    CGSize size = CGSizeMake(width + (SMALL_PADDING * 2), VIEW_PAGER_HEADER_HEIGHT);

    self.size = size;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	CGRect bounds = self.bounds;
    
    CGRect frame = bounds;
    frame.origin.x = SMALL_PADDING;
    frame.size.width -= SMALL_PADDING * 2;
    
    self.label.frame = frame;
    self.backgroundView.frame = bounds;
}

- (UIColor *)backgroundColor
{
    return self.backgroundView.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.backgroundColor = backgroundColor;
}

- (CGFloat)alpha
{
    return self.backgroundView.alpha;
}

- (void)setAlpha:(CGFloat)alpha
{
    self.backgroundView.alpha = alpha;
}

#pragma mark - Getter/Setter methods -

- (NSString *)text
{
    return self.label.text;
}

- (void)setText:(NSString *)text
{
    self.label.text = text;
    [self sizeToFit];
}

@end

#pragma mark - ViewPagerHeader extension -

@interface ViewPagerHeader()

@property (retain) NSMutableArray *movableHeaders;

@property (readonly) ViewPagerHeaderItem *previousHeader;
@property (readonly) ViewPagerHeaderItem *currentHeader;
@property (readonly) ViewPagerHeaderItem *nextHeader;

@property (assign) PanDirection currentPanDirection;
//@property (assign) CGFloat currentPercentageCompleted;
@property (assign) CGFloat lastPosition;
@property (assign) CGFloat currentPosition;

- (void)addMovableHeader:(ViewPagerHeaderItem *)item;
- (void)removeMovableHeader:(ViewPagerHeaderItem *)item;

- (void)checkForCollision:(ViewPagerHeaderItem *)item;

@end

#pragma mark - ViewPagerHeader implementation

@implementation ViewPagerHeader

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
	{
        self.movableHeaders = [NSMutableArray object];
    }
    
    return self;
}

- (void)dealloc
{
    self.items = nil;
    self.movableHeaders = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

//- (void)updatePosition:(CGFloat)position percentageCompleted:(CGFloat)percentage direction:(PanDirection)direction
//{
//    self.currentPanDirection = direction;
//    self.currentPercentageCompleted = percentage;
//    self.currentPosition = position;
//
//    [self setNeedsLayout];
//}

#pragma mark - Private methods -

- (void)addMovableHeader:(ViewPagerHeaderItem *)item
{
    item.isMovable = true;
    [self.movableHeaders addObject:item];
}

- (void)removeMovableHeader:(ViewPagerHeaderItem *)item
{
    item.isMovable = false;
    [self.movableHeaders removeObject:item];
}

- (void)checkForCollision:(ViewPagerHeaderItem *)item
{
    for(ViewPagerHeaderItem *i in self.subviews)
    {
        if(i.isMovable)
        {
            continue;
        }
        
        if(CGRectIntersectsRect(item.frame, i.frame))
        {
            [self addMovableHeader:i];
        }
    }
    
    if(item.x < 0)
    {
        item.x = 0;
    }
    
    if(item.x > (self.width - item.width))
    {
        item.x = self.width - item.width;
    }
}

- (void)panBegan:(CGPoint)initialLocation
{
    self.lastPosition = self.currentPosition = initialLocation.x;
    
    ViewPagerHeaderItem *currentHeader = self.currentHeader;
    if(currentHeader)
        [self addMovableHeader:currentHeader];
}

- (void)panChanged:(CGPoint)position direction:(PanDirection)direction
{
    self.lastPosition = self.currentPosition;
    self.currentPosition = position.x;
    self.currentPanDirection = direction;
    
    [self setNeedsLayout];
}

- (void)panEnded
{
    self.lastPosition = 0;
    self.currentPosition = 0;
    self.currentPanDirection = PanDirection_NONE;
    
    [self.movableHeaders removeAllObjects];
}

- (void)animateTo:(CGFloat)position duration:(CGFloat)duration option:(UIViewAnimationOptions)option direction:(PanDirection)direction
{
    return;
    
    void (^animation)(void) = ^
    {
        ViewPagerHeaderItem *previousHeader = self.previousHeader;
        ViewPagerHeaderItem *currentHeader = self.currentHeader;
        ViewPagerHeaderItem *nextHeader = self.nextHeader;
        
        switch(direction)
        {
            case PanDirection_NONE:
                previousHeader.alpha = HEADER_MIN_ALPHA;
                currentHeader.alpha = 1;
                nextHeader.alpha = HEADER_MIN_ALPHA;
                break;
                
            case PanDirection_BACKWARDS:
                previousHeader.alpha = 1;
                currentHeader.alpha = HEADER_MIN_ALPHA;
                nextHeader.alpha = HEADER_MIN_ALPHA;
                break;
                
            case PanDirection_FORWARDS:
                previousHeader.alpha = HEADER_MIN_ALPHA;
                currentHeader.alpha = HEADER_MIN_ALPHA;
                nextHeader.alpha = 1;
                break;
        }
        
        self.x = position;
    };
    
    self.currentPanDirection = PanDirection_NONE;
//    self.currentPercentageCompleted = 1;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:animation completion:nil];
}

#pragma mark - Protected methods -

- (void)sizeToFit
{
    self.size = CGSizeMake(self.superview.width, VIEW_PAGER_HEADER_HEIGHT);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    // adjust alpha
    {
//    CGFloat diff = (1.0 - self.currentPercentageCompleted) * (1.0 - HEADER_MIN_ALPHA);
        CGFloat diff = 1 - HEADER_MIN_ALPHA;
        
        CGFloat previousAlpha = HEADER_MIN_ALPHA;
        CGFloat currentAlpha = HEADER_MIN_ALPHA +  diff;
        CGFloat nextAlpha = HEADER_MIN_ALPHA;
        
        switch(self.currentPanDirection)
        {
            case PanDirection_NONE:
                break;
                
            case PanDirection_BACKWARDS:
                previousAlpha = 1 - diff;
                break;
                
            case PanDirection_FORWARDS:
                nextAlpha = 1 - diff;
                break;
        }

        self.previousHeader.alpha = previousAlpha;
        self.currentHeader.alpha = currentAlpha;
        self.nextHeader.alpha = nextAlpha;
    }
    
    // adjust positions
    {
        CGFloat diff = self.currentPosition - self.lastPosition;
        
        for(ViewPagerHeaderItem *item in self.movableHeaders)
        {
            item.x += diff;
            
            [self checkForCollision:item];
        }
    }
}

#pragma mark - Getter/Setter methods -

- (void)setItems:(NSArray *)items
{
    [self removeAllSubviews];
    
    [[_items retain] autorelease];
    _items = [items retain];
    
    if(items)
    {
        for(int i = 0; i < items.count; i++)
        {
            ViewPagerHeaderItem *item = [items objectAtIndex:i];
            
            if(![item isKindOfClass:[ViewPagerHeaderItem class]])
            {
                [_items release];
                _items = nil;
                
                return;
            }
            
            item.index = i;
            [self addSubview:item];
        }
        
        if(items.count == 0)
        {
            return;
        }
        
        [self.currentHeader centerHorizontal];
        [self.nextHeader alignRight];
        
        CGFloat x = self.superview.width;
        
        for(int i = 2; i < items.count; i++)
        {
            ViewPagerHeaderItem *item = [items objectAtIndex:i];
            item.x = x;
            
            x += self.superview.width;
        }
    }
}

- (ViewPagerHeaderItem *)previousHeader
{
    int i = self.currentIndex - 1;
    
    if(i < 0)
    {
        return nil;
    }
    
    return [self.subviews objectAtIndex:i];
}

- (ViewPagerHeaderItem *)currentHeader
{
    if(self.currentIndex < self.subviews.count)
    {
        return [self.subviews objectAtIndex:self.currentIndex];
    }
    
    return nil;
}

- (ViewPagerHeaderItem *)nextHeader
{
    int i = self.currentIndex + 1;
    
    if(i >= self.subviews.count)
    {
        return nil;
    }
    
    return [self.subviews objectAtIndex:i];
}

@end
