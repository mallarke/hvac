//
//  ViewPager.m
//  HVAC Planner
//
//  Created by mallarke on 7/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "ViewPager.h"

#import "ViewPagerHeader_Private.h"

/* 
 * WARNING: if you make any changes to this struct, you need to match those changes in
 * - (void)moveContent:(MoveContentOptions)options because of the blocks being used
 * 
 * pass in NULL for the duration if you don't want any animation.  
 * pass in NULL for the index if you don't want to set it
 *
 */
typedef struct
{
    CGFloat x;
    const CGFloat *animationDuration;
    UIViewAnimationOptions animationOption;
    const int *index;
    PanDirection panDirection;
    BOOL didFinish;
} MoveContentOptions;

MoveContentOptions MoveContentOptionsZero = { 0, NULL, UIViewAnimationOptionCurveLinear, NULL, PanDirection_NONE, false };

#pragma mark - ViewPager extension -

@interface ViewPager()

@property (nonatomic, readwrite) int currentIndex;
@property (readonly) int maxIndex;

@property (retain) ViewPagerHeader *header;
@property (retain) UIView *contentContainer;

@property (assign) CGPoint initialTouchLocation;
@property (assign) CGPoint currentTouchLocation;
@property (assign) PanDirection currentPanDirection;

@property (assign) BOOL isAnimating;

- (void)invalidate;

- (void)handlePan:(UIPanGestureRecognizer *)gesture;
- (BOOL)shouldPan:(CGFloat)x;
- (void)finishPan:(CGPoint)location velocity:(CGFloat)velocity;

- (MoveContentOptions)createMoveOptions;
- (void)moveContent:(MoveContentOptions)options;

@end

#pragma mark - ViewPager implementation

@implementation ViewPager

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.header = [ViewPagerHeader object];
        [self addSubview:self.header];
        
        self.contentContainer = [UIView object];
        [self addSubview:self.contentContainer];
        
        UIPanGestureRecognizer *gesture = [UIPanGestureRecognizer object];
        [gesture addTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:gesture];
    }

    return self;
}

- (void)dealloc
{
    self.header = nil;
    self.contentContainer = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)setIndex:(int)index animated:(BOOL)animated
{
    index--;
    
    if(index < 0 || index == self.viewControllers.count)
        return;
    
    dispatch_block_t block = ^
    {
        int x = -(index * self.width);
        CGFloat slowDuration = SLOW_ANIMATION_SPEED;
        
        MoveContentOptions options = [self createMoveOptions];
        options.x = x;
        options.animationDuration = (animated ? &slowDuration : NULL);
        options.index = &index;
        [self moveContent:options];
    };
    
    dispatch_async(dispatch_get_main_queue(), block);
}

#pragma mark - Private methods -

- (void)invalidate
{
    [self.contentContainer removeAllSubviews];

    NSMutableArray *headers = nil;
    if(self.viewControllers.count > 0)
        headers = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    
    CGRect frame = self.bounds;
    frame.origin.y = VIEW_PAGER_HEADER_HEIGHT;
    frame.size.height -= VIEW_PAGER_HEADER_HEIGHT;
    
    CGFloat width = self.width;
    
    for(UIViewController *viewController in self.viewControllers)
    {
        ViewPagerHeaderItem *item = [ViewPagerHeaderItem object];
        item.text = viewController.title;
        [headers addObject:item];
        
        UIView *view = viewController.view;
        view.frame = frame;
        [self.contentContainer addSubview:view];
        
        frame.origin.x += width;
    }
    
    self.header.items = headers;
    self.currentIndex = 0;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if(self.isAnimating)
    {
        return;
    }
    
    CGPoint location = [gesture locationInView:self];
    CGFloat x = (location.x - self.initialTouchLocation.x) - (self.currentIndex * self.width);
    CGPoint velocity = [gesture velocityInView:self];
    
    PanDirection panDirection = get_pan_direction(location, self.initialTouchLocation);

    switch(gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            self.initialTouchLocation = self.currentTouchLocation = location;
            [self.header panBegan:location];
            break;
            
        case UIGestureRecognizerStateChanged:
            if([self shouldPan:x])
            {
                [self.header panChanged:location direction:panDirection];
                
                self.currentTouchLocation = location;
                self.currentPanDirection = panDirection;
                
                MoveContentOptions options = [self createMoveOptions];
                options.x = x;
                
                [self moveContent:options];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if([self shouldPan:x])
            {
                [self finishPan:location velocity:velocity.x];
            }
            
            [self.header panEnded];
            
            self.initialTouchLocation = self.currentTouchLocation = CGPointZero;
            self.currentPanDirection = PanDirection_NONE;
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldPan:(CGFloat)x
{
    if(self.currentIndex == 0 && x > 0)
    {
        return false;
    }
    
    if(self.currentIndex == self.maxIndex && x < -((self.viewControllers.count - 1) * self.width))
    {
        return false;
    }
    
    return true;
}

- (void)finishPan:(CGPoint)location velocity:(CGFloat)velocity
{
    // keep a local ref to the initial touch because once we run our async block, the property will get set to CGPointZero
    CGPoint initialTouch = self.initialTouchLocation;
    
    CGFloat x = location.x - initialTouch.x;
    CGFloat newX = x;
    
    CGFloat distance = (x < 0 ? x * -1 : x);
    PanDirection direction = get_pan_direction(location, initialTouch);
    BOOL didFinish = false;
    int index = self.currentIndex;
    
    if(velocity < 0)
        velocity *= -1;

    if(distance > VIEW_PAGER_MINIMUM_PAN)
    {
        index += (direction == PanDirection_FORWARDS ? 1 : -1);
        newX = index * self.width;
        didFinish = true;
    }
    
    distance = self.width + (direction == PanDirection_FORWARDS ? x : -x);

    newX = -(index * self.width);
    CGFloat animationSpeed = (didFinish ? distance / velocity : FAST_ANIMATION_SPEED);
    if(animationSpeed > SLOW_ANIMATION_SPEED)
        animationSpeed = SLOW_ANIMATION_SPEED;
    
    MoveContentOptions options = [self createMoveOptions];
    options.x = newX;
    options.animationDuration = &animationSpeed;
    options.animationOption = UIViewAnimationOptionCurveEaseOut;
    options.index = &index;
    options.didFinish = didFinish;
    
    [self moveContent:options];
}

- (void)moveContent:(MoveContentOptions)options
{
    CGFloat x = options.x;
    CGFloat animationDuration = (options.animationDuration ? *(options.animationDuration) : 0);
    UIViewAnimationOptions animationOptions = options.animationOption;
    int index = (options.index ? *(options.index) : -1);
    PanDirection panDirection = options.panDirection;
    BOOL didFinish = options.didFinish;

    void (^animation)(void) = ^
    {
        self.contentContainer.x = x;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        if(index >= 0)
        {
            self.currentIndex = index;
        }
        
        self.isAnimating = false;
    };

    if(animationDuration > 0)
    {
        self.isAnimating = true;
        
        [self.header animateTo:x duration:animationDuration option:animationOptions direction:(didFinish ? panDirection : PanDirection_NONE)];
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:animation completion:completion];
    }
    else
    {
        animation();
        completion(true);
    }
}

- (MoveContentOptions)createMoveOptions
{
    MoveContentOptions options = MoveContentOptionsZero;
    
//    CGFloat percentagePanned = 0;
//    
//    switch(self.currentPanDirection)
//    {
//        case PanDirection_NONE:
//            break;
//            
//        case PanDirection_BACKWARDS:
//            percentagePanned = self.currentTouchLocation.x - self.initialTouchLocation.x;
//            break;
//            
//        case PanDirection_FORWARDS:
//            percentagePanned = self.initialTouchLocation.x - self.currentTouchLocation.x;
//            break;
//    }
//    
//    percentagePanned /= self.width;
//    
//    options.percentageCompleted = percentagePanned;
    options.panDirection = self.currentPanDirection;
    
    return options;
}

#pragma mark - Protected methods -

- (void)sizeToFit
{
    self.size = self.superview.size;
}

- (void)layoutSubviews
{
    if(self.isAnimating)
    {
        return;
    }
    
	[super layoutSubviews];

	CGRect bounds = self.bounds;
	CGSize maxSize = bounds.size;
    
    [self.header sizeToFit];
    
    CGFloat width = maxSize.width * self.viewControllers.count;
    
    CGRect frame = self.contentContainer.frame;
    frame.origin.y = VIEW_PAGER_HEADER_HEIGHT;
    frame.size.width = width;
    frame.size.height -= VIEW_PAGER_HEADER_HEIGHT;
    self.contentContainer.frame = frame;
    
    for(UIView *view in self.contentContainer.subviews)
    {
        view.size = maxSize;
    }
}

#pragma mark - Getter/Setter methods -

- (void)setViewControllers:(NSArray *)viewControllers
{
    [[_viewControllers retain] autorelease];
    _viewControllers = [viewControllers retain];
    
    if(viewControllers)
    {
        dispatch_block_t block = ^
        {
            [self invalidate];
            [self setNeedsLayout];
        };
        
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
    self.header.currentIndex = currentIndex;
}

- (int)maxIndex
{
    return self.viewControllers.count - 1;
}

@end
