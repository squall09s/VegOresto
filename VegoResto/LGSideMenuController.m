//
//  LGSideMenuController.m
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGSideMenuController.h"

#define kLGSideMenuStatusBarOrientationIsPortrait   UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarOrientationIsLandscape  UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarHidden                  UIApplication.sharedApplication.statusBarHidden
#define kLGSideMenuStatusBarStyle                   UIApplication.sharedApplication.statusBarStyle
#define kLGSideMenuDeviceIsPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kLGSideMenuDeviceIsPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kLGSideMenuSystemVersion                    UIDevice.currentDevice.systemVersion.floatValue
#define kLGSideMenuCoverColor                       [UIColor colorWithWhite:0.f alpha:0.5]
#define kLGSideMenuIsMenuShowing                    (self.isLeftViewShowing)

#define kLGSideMenuIsLeftViewAlwaysVisible \
((_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))


#define kLGSideMenuIsLeftViewStatusBarVisible \
((_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadLandscape))))))


@interface LGSideMenuView : UIView

@property (strong, nonatomic) void (^layoutSubviewsHandler)();

@end

@implementation LGSideMenuView

- (instancetype)initWithLayoutSubviewsHandler:(void(^)())layoutSubviewsHandler
{
    self = [super init];
    if (self)
    {
        _layoutSubviewsHandler = layoutSubviewsHandler;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_layoutSubviewsHandler) _layoutSubviewsHandler();
}

@end

#pragma mark -

@interface LGSideMenuController () <UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGSize savedSize;

@property (strong, nonatomic) UIViewController *rootVC;
@property (strong, nonatomic) LGSideMenuView *leftView;

@property (strong, nonatomic) UIView *rootViewCoverViewForLeftView;

@property (strong, nonatomic) UIView *leftViewCoverView;

@property (strong, nonatomic) UIImageView *backgroundImageViewForLeftView;

@property (strong, nonatomic) UIView *rootViewStyleView;
@property (strong, nonatomic) UIView *leftViewStyleView;

@property (assign, nonatomic) BOOL savedStatusBarHidden;
@property (assign, nonatomic) UIStatusBarStyle savedStatusBarStyle;
@property (assign, nonatomic, getter=isWaitingForUpdateStatusBar) BOOL waitingForUpdateStatusBar;

@property (assign, nonatomic) BOOL currentShouldAutorotate;
@property (assign, nonatomic) BOOL currentPreferredStatusBarHidden;
@property (assign, nonatomic) UIStatusBarStyle currentPreferredStatusBarStyle;
@property (assign, nonatomic) UIStatusBarAnimation currentPreferredStatusBarUpdateAnimation;

@property (strong, nonatomic) NSNumber *leftViewGestireStartX;

@property (assign, nonatomic, getter=isLeftViewShowingBeforeGesture) BOOL leftViewShowingBeforeGesture;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (assign, nonatomic, getter=isUserRootViewScaleForLeftView) BOOL userRootViewScaleForLeftView;
@property (assign, nonatomic, getter=isUserRootViewCoverColorForLeftView) BOOL userRootViewCoverColorForLeftView;
@property (assign, nonatomic, getter=isUserLeftViewCoverColor) BOOL userLeftViewCoverColor;
@property (assign, nonatomic, getter=isUserLeftViewBackgroundImageInitialScale) BOOL userLeftViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserLeftViewInititialScale) BOOL userLeftViewInititialScale;
@property (assign, nonatomic, getter=isUserLeftViewInititialOffsetX) BOOL userLeftViewInititialOffsetX;



@end

@implementation LGSideMenuController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self)
    {
        _rootVC = rootViewController;
        
        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupDefaultProperties];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupDefaults];
}

- (void)setupDefaultProperties
{
    _leftViewAnimationSpeed = 0.5;
    
    _leftViewHidesOnTouch = YES;
    
    _leftViewSwipeGestureEnabled = YES;
    
    _rootViewLayerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _rootViewLayerShadowRadius = 5.f;
    
    _leftViewLayerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _leftViewLayerShadowRadius = 5.f;
    
}

- (void)setupDefaults
{
    self.view.clipsToBounds = YES;
    
    // -----
    
    _shouldShowLeftView = YES;
    
    // -----
    
    _backgroundImageViewForLeftView = [UIImageView new];
    _backgroundImageViewForLeftView.hidden = YES;
    _backgroundImageViewForLeftView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageViewForLeftView.backgroundColor = [UIColor clearColor];
    _backgroundImageViewForLeftView.clipsToBounds = YES;
    [self.view addSubview:_backgroundImageViewForLeftView];
    
    // -----
    
    _rootViewStyleView = [UIView new];
    _rootViewStyleView.hidden = YES;
    _rootViewStyleView.backgroundColor = [UIColor blackColor];
    _rootViewStyleView.layer.masksToBounds = NO;
    _rootViewStyleView.layer.shadowOffset = CGSizeZero;
    _rootViewStyleView.layer.shadowOpacity = 1.f;
    _rootViewStyleView.layer.shouldRasterize = YES;
    [self.view addSubview:_rootViewStyleView];
    
    if (_rootVC)
    {
        [self addChildViewController:_rootVC];
        [self.view addSubview:_rootVC.view];
    }
    
    // -----
    
    _gesturesCancelsTouchesInView = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:_panGesture];
}

#pragma mark - Dealloc

- (void)dealloc
{
    //
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    
    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }
    
    if (!CGSizeEqualToSize(_savedSize, size))
    {
        BOOL appeared = !CGSizeEqualToSize(_savedSize, CGSizeZero);
        
        _savedSize = size;
        
        // -----
        
        [self colorsInvalidate];
        [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing ? 1.f : 0.f)];
        [self leftViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing ? 1.f : 0.f)];
        [self hiddensInvalidateWithDelay:(appeared ? 0.25 : 0.0)];
    }
}

#pragma mark -

- (BOOL)shouldAutorotate
{
    return (kLGSideMenuIsMenuShowing ? _currentShouldAutorotate : (_rootVC ? _rootVC.shouldAutorotate : YES));
}

- (BOOL)prefersStatusBarHidden
{
    return (kLGSideMenuIsMenuShowing ? _currentPreferredStatusBarHidden : (_rootVC ? _rootVC.prefersStatusBarHidden : (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)));
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (kLGSideMenuIsMenuShowing ? _currentPreferredStatusBarStyle : (_rootVC ? _rootVC.preferredStatusBarStyle : UIStatusBarStyleDefault));
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation animation = UIStatusBarAnimationNone;
    
    if (self.isWaitingForUpdateStatusBar)
    {
        _waitingForUpdateStatusBar = NO;
        
        animation = _currentPreferredStatusBarUpdateAnimation;
    }
    else if (_rootVC)
        animation = _rootVC.preferredStatusBarUpdateAnimation;
    
    return animation;
}

- (void)statusBarAppearanceUpdate
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    if (![[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:_currentPreferredStatusBarHidden withAnimation:_currentPreferredStatusBarUpdateAnimation];
        [[UIApplication sharedApplication] setStatusBarStyle:_currentPreferredStatusBarStyle animated:_currentPreferredStatusBarUpdateAnimation];
    }
#endif
}

#pragma mark - Setters and Getters

- (void)setRootViewScaleForLeftView:(CGFloat)rootViewScaleForLeftView
{
    _rootViewScaleForLeftView = rootViewScaleForLeftView;
    
    _userRootViewScaleForLeftView = YES;
}



- (void)setRootViewCoverColorForLeftView:(UIColor *)rootViewCoverColorForLeftView
{
    _rootViewCoverColorForLeftView = rootViewCoverColorForLeftView;
    
    _userRootViewCoverColorForLeftView = YES;
}



- (void)setLeftViewCoverColor:(UIColor *)leftViewCoverColor
{
    _leftViewCoverColor = leftViewCoverColor;
    
    _userLeftViewCoverColor = YES;
}


- (void)setLeftViewBackgroundImageInitialScale:(CGFloat)leftViewBackgroundImageInitialScale
{
    _leftViewBackgroundImageInitialScale = leftViewBackgroundImageInitialScale;
    
    _userLeftViewBackgroundImageInitialScale = YES;
}



- (void)setLeftViewInititialScale:(CGFloat)leftViewInititialScale
{
    _leftViewInititialScale = leftViewInititialScale;
    
    _userLeftViewInititialScale = YES;
}



- (void)setLeftViewInititialOffsetX:(CGFloat)leftViewInititialOffsetX
{
    _leftViewInititialOffsetX = leftViewInititialOffsetX;
    
    _userLeftViewInititialOffsetX = YES;
}



- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (rootViewController)
    {
        if (_rootVC)
        {
            [_rootVC.view removeFromSuperview];
            [_rootVC removeFromParentViewController];
        }
        
        _rootVC = rootViewController;
        
        [self addChildViewController:_rootVC];
        [self.view addSubview:_rootVC.view];
        
        if (_leftView)
        {
            [_leftView removeFromSuperview];
            [_rootViewCoverViewForLeftView removeFromSuperview];
            
            [self.view addSubview:_rootViewCoverViewForLeftView];
            
            if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                [self.view addSubview:_leftView];
            else
                [self.view insertSubview:_leftView belowSubview:_rootVC.view];
            
        }
        
        
        // -----
        
        [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing ? 1.f : 0.f)];
    }
}

- (UIViewController *)rootViewController
{
    return _rootVC;
}

- (UIView *)leftView
{
    return _leftView;
}



- (BOOL)isLeftViewAlwaysVisible
{
    return kLGSideMenuIsLeftViewAlwaysVisible;
}






- (void)setGesturesCancelsTouchesInView:(BOOL)gesturesCancelsTouchesInView
{
    _gesturesCancelsTouchesInView = gesturesCancelsTouchesInView;
    
    _panGesture.cancelsTouchesInView = gesturesCancelsTouchesInView;
}

#pragma mark - Layout Subviews

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    //
}



#pragma mark -

- (void)rootViewLayoutInvalidateWithPercentage:(CGFloat)percentage
{
    
    
    _rootVC.view.transform = CGAffineTransformIdentity;
    _rootViewStyleView.transform = CGAffineTransformIdentity;
    
    if (_rootViewCoverViewForLeftView)
        _rootViewCoverViewForLeftView.transform = CGAffineTransformIdentity;
    
    // -----
    
    CGSize size = self.view.frame.size;
    
    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }
    
    // -----
    
    CGRect rootViewViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    BOOL leftViewAlwaysVisible = NO;
    
    if (kLGSideMenuIsLeftViewAlwaysVisible)
    {
        leftViewAlwaysVisible = YES;
        
        rootViewViewFrame.origin.x += _leftViewWidth;
        rootViewViewFrame.size.width -= _leftViewWidth;
    }
    
    
    if (!leftViewAlwaysVisible)
    {
        if (self.isLeftViewShowing && _leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)
        {
            CGFloat rootViewScale = 1.f+(_rootViewScaleForLeftView-1.f)*percentage;
            
            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);
            
            CGFloat shift = size.width*(1.f-rootViewScale)/2;
            
            rootViewViewFrame = CGRectMake((_leftViewWidth-shift)*percentage, 0.f, size.width, size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
        }
        
    }
    
    _rootVC.view.frame = rootViewViewFrame;
    _rootVC.view.transform = transform;
    
    // -----
    
    CGFloat borderWidth = _rootViewStyleView.layer.borderWidth;
    _rootViewStyleView.frame = CGRectMake(rootViewViewFrame.origin.x-borderWidth, rootViewViewFrame.origin.y-borderWidth, rootViewViewFrame.size.width+borderWidth*2, rootViewViewFrame.size.height+borderWidth*2);
    _rootViewStyleView.transform = transform;
    
    // -----
    
    if (_leftView)
    {
        _rootViewCoverViewForLeftView.frame = rootViewViewFrame;
        _rootViewCoverViewForLeftView.transform = transform;
    }
    
    
}

- (void)leftViewLayoutInvalidateWithPercentage:(CGFloat)percentage
{
    if (_leftView)
    {
        CGSize size = self.view.frame.size;
        
        if (kLGSideMenuSystemVersion < 8.0)
        {
            if (kLGSideMenuStatusBarOrientationIsPortrait)
                size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
            else
                size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
        }
        
        // -----
        
        _leftView.transform = CGAffineTransformIdentity;
        _backgroundImageViewForLeftView.transform = CGAffineTransformIdentity;
        _leftViewStyleView.transform = CGAffineTransformIdentity;
        
        // -----
        
        CGFloat originX = 0.f;
        CGAffineTransform leftViewTransform = CGAffineTransformIdentity;
        CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;
        
        if (!kLGSideMenuIsLeftViewAlwaysVisible)
        {
            _rootViewCoverViewForLeftView.alpha = percentage;
            _leftViewCoverView.alpha = 1.f-percentage;
            
            if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                originX = -(_leftViewWidth+_leftViewStyleView.layer.shadowRadius*2)*(1.f-percentage);
            else
            {
                CGFloat leftViewScale = 1.f+(_leftViewInititialScale-1.f)*(1.f-percentage);
                CGFloat backgroundViewScale = 1.f+(_leftViewBackgroundImageInitialScale-1.f)*(1.f-percentage);
                
                leftViewTransform = CGAffineTransformMakeScale(leftViewScale, leftViewScale);
                backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);
                
                originX = (-(_leftViewWidth*(1.f-leftViewScale)/2)+(_leftViewInititialOffsetX*leftViewScale))*(1.f-percentage);
            }
        }
        
        // -----
        
        CGRect leftViewFrame = CGRectMake(originX, 0.f, _leftViewWidth, size.height);
        if ([UIScreen mainScreen].scale == 1.f)
            leftViewFrame = CGRectIntegral(leftViewFrame);
        _leftView.frame = leftViewFrame;
        
        _leftView.transform = leftViewTransform;
        
        // -----
        
        
        CGFloat borderWidth = _leftViewStyleView.layer.borderWidth;
        _leftViewStyleView.frame = CGRectMake(leftViewFrame.origin.x-borderWidth, leftViewFrame.origin.y-borderWidth, leftViewFrame.size.width+borderWidth*2, leftViewFrame.size.height+borderWidth*2);
        _leftViewStyleView.transform = leftViewTransform;
        
    }
}

- (void)colorsInvalidate
{
    if (_rootViewStyleView)
    {
        _rootViewStyleView.layer.borderWidth = _rootViewLayerBorderWidth;
        _rootViewStyleView.layer.borderColor = _rootViewLayerBorderColor.CGColor;
        _rootViewStyleView.layer.shadowColor = _rootViewLayerShadowColor.CGColor;
        _rootViewStyleView.layer.shadowRadius = _rootViewLayerShadowRadius;
    }
    
    if (kLGSideMenuIsLeftViewAlwaysVisible || self.isLeftViewShowing)
    {
        self.view.backgroundColor = [_leftViewBackgroundColor colorWithAlphaComponent:1.f];
        
        _rootViewCoverViewForLeftView.backgroundColor = _rootViewCoverColorForLeftView;
        
        if (_leftViewCoverView)
            _leftViewCoverView.backgroundColor = _leftViewCoverColor;
        
        if (_leftViewStyleView)
        {
            _leftViewStyleView.backgroundColor = (kLGSideMenuIsLeftViewAlwaysVisible ? [_leftViewBackgroundColor colorWithAlphaComponent:1.f] : _leftViewBackgroundColor);
            _leftViewStyleView.layer.borderWidth = _leftViewLayerBorderWidth;
            _leftViewStyleView.layer.borderColor = _leftViewLayerBorderColor.CGColor;
            _leftViewStyleView.layer.shadowColor = _leftViewLayerShadowColor.CGColor;
            _leftViewStyleView.layer.shadowRadius = _leftViewLayerShadowRadius;
        }
        
        if (_leftViewBackgroundImage)
            _backgroundImageViewForLeftView.image = _leftViewBackgroundImage;
    }
    
    
}

- (void)hiddensInvalidate
{
    [self hiddensInvalidateWithDelay:0.0];
}

- (void)hiddensInvalidateWithDelay:(NSTimeInterval)delay
{
    BOOL rootViewStyleViewHiddenForLeftView = YES;
    
    // -----
    
    if (kLGSideMenuIsLeftViewAlwaysVisible)
    {
        _rootViewCoverViewForLeftView.hidden = YES;
        _leftViewCoverView.hidden = YES;
        _leftView.hidden = NO;
        _leftViewStyleView.hidden = NO;
        _backgroundImageViewForLeftView.hidden = NO;
        
        rootViewStyleViewHiddenForLeftView = NO;
    }
    else if (!self.isLeftViewShowing)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootViewCoverViewForLeftView.hidden = YES;
                               _leftViewCoverView.hidden = YES;
                               _leftView.hidden = YES;
                               _leftViewStyleView.hidden = YES;
                               _backgroundImageViewForLeftView.hidden = YES;
                           });
        }
        else
        {
            _rootViewCoverViewForLeftView.hidden = YES;
            _leftViewCoverView.hidden = YES;
            _leftView.hidden = YES;
            _leftViewStyleView.hidden = YES;
            _backgroundImageViewForLeftView.hidden = YES;
        }
        
        rootViewStyleViewHiddenForLeftView = YES;
    }
    else if (self.isLeftViewShowing)
    {
        _rootViewCoverViewForLeftView.hidden = NO;
        _leftViewCoverView.hidden = NO;
        _leftView.hidden = NO;
        _leftViewStyleView.hidden = NO;
        _backgroundImageViewForLeftView.hidden = NO;
        
        rootViewStyleViewHiddenForLeftView = NO;
    }
    
    // -----
    
    
    // -----
    
    if (rootViewStyleViewHiddenForLeftView)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootViewStyleView.hidden = YES;
                           });
        }
        else _rootViewStyleView.hidden = (rootViewStyleViewHiddenForLeftView);
    }
    else _rootViewStyleView.hidden = NO;
}

#pragma mark - Side Views

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions
{
    NSAssert(_leftView == nil, @"Left view already exists");
    
    _rootViewCoverViewForLeftView = [UIView new];
    _rootViewCoverViewForLeftView.hidden = YES;
    if (_rootVC)
    {
        [self.view addSubview:_rootViewCoverViewForLeftView];
    }
    
    // -----
    
    __weak typeof(self) wself = self;
    
    _leftView = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void)
                 {
                     if (wself)
                     {
                         __strong typeof(wself) self = wself;
                         
                         CGSize size = self.view.frame.size;
                         
                         if (kLGSideMenuSystemVersion < 8.0)
                         {
                             if (kLGSideMenuStatusBarOrientationIsPortrait)
                                 size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
                             else
                                 size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
                         }
                         
                         [self leftViewWillLayoutSubviewsWithSize:CGSizeMake(self.leftViewWidth, size.height)];
                     }
                 }];
    _leftView.backgroundColor = [UIColor clearColor];
    _leftView.hidden = YES;
    if (_rootVC)
    {
        if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
            [self.view addSubview:_leftView];
        else
            [self.view insertSubview:_leftView belowSubview:_rootVC.view];
    }
    
    // -----
    
    _leftViewWidth = width;
    
    _leftViewPresentationStyle = presentationStyle;
    
    _leftViewAlwaysVisibleOptions = alwaysVisibleOptions;
    
    // -----
    
    if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
    {
        _leftViewCoverView = [UIView new];
        _leftViewCoverView.hidden = YES;
        [self.view insertSubview:_leftViewCoverView aboveSubview:_leftView];
    }
    else
    {
        _leftViewStyleView = [UIView new];
        _leftViewStyleView.hidden = YES;
        _leftViewStyleView.layer.masksToBounds = NO;
        _leftViewStyleView.layer.shadowOffset = CGSizeZero;
        _leftViewStyleView.layer.shadowOpacity = 1.f;
        _leftViewStyleView.layer.shouldRasterize = YES;
        [self.view insertSubview:_leftViewStyleView belowSubview:_leftView];
    }
    
    // -----
    
    [_rootViewStyleView removeFromSuperview];
    [self.view insertSubview:_rootViewStyleView belowSubview:_rootVC.view];
    
    // -----
    
    if (!self.isUserRootViewScaleForLeftView)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _rootViewScaleForLeftView = 1.f;
        else
            _rootViewScaleForLeftView = 0.8;
    }
    
    if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
    {
        if (!self.isUserRootViewCoverColorForLeftView)
            _rootViewCoverColorForLeftView = kLGSideMenuCoverColor;
    }
    else
    {
        if (!self.isUserLeftViewCoverColor)
            _leftViewCoverColor = kLGSideMenuCoverColor;
    }
    
    if (!self.isUserLeftViewBackgroundImageInitialScale)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _leftViewBackgroundImageInitialScale = 1.f;
        else
            _leftViewBackgroundImageInitialScale = 1.4;
    }
    
    if (!self.isUserLeftViewInititialScale)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _leftViewInititialScale = 1.f;
        else if (_leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig)
            _leftViewInititialScale = 1.2;
        else
            _leftViewInititialScale = 0.8;
    }
    
    if (!self.isUserLeftViewInititialOffsetX)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _leftViewInititialOffsetX = -_leftViewWidth/2;
    }
    
    // -----
    
    [self leftViewLayoutInvalidateWithPercentage:0.f];
}



#pragma mark - Show Hide

- (void)showLeftViewPrepare
{
    [self.view endEditing:YES];
    
    _leftViewShowing = YES;
    
    // -----
    
    if (kLGSideMenuSystemVersion >= 7.0)
    {
        _savedStatusBarHidden = kLGSideMenuStatusBarHidden;
        _savedStatusBarStyle = kLGSideMenuStatusBarStyle;
        
        [_rootVC removeFromParentViewController];
        
        _currentShouldAutorotate = NO;
        _currentPreferredStatusBarHidden = (kLGSideMenuStatusBarHidden || !kLGSideMenuIsLeftViewStatusBarVisible);
        _currentPreferredStatusBarStyle = _leftViewStatusBarStyle;
        _currentPreferredStatusBarUpdateAnimation = _leftViewStatusBarUpdateAnimation;
        
        _waitingForUpdateStatusBar = YES;
        
        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    // -----
    
    [self leftViewLayoutInvalidateWithPercentage:0.f];
    [self colorsInvalidate];
    [self hiddensInvalidate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillShowLeftViewNotification object:self userInfo:nil];
}

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible && !self.isLeftViewShowing && self.shouldShowLeftView )
    {
        [self showLeftViewPrepare];
        
        [self showLeftViewAnimated:animated fromPercentage:0.f completionHandler:completionHandler];
    }
}

- (void)showLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    
    
    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_leftViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:1.f];
             [self leftViewLayoutInvalidateWithPercentage:1.f];
         }
                                               completion:^(BOOL finished)
         {
             if (finished)
                 [self hiddensInvalidate];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];
             
             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:1.f];
        [self leftViewLayoutInvalidateWithPercentage:1.f];
        
        [self hiddensInvalidate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];
        
        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible && self.isLeftViewShowing)
        [self hideLeftViewAnimated:animated fromPercentage:1.f completionHandler:completionHandler];
}

- (void)hideLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];
    
    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_leftViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:0.f];
             [self leftViewLayoutInvalidateWithPercentage:0.f];
         }
                                               completion:^(BOOL finished)
         {
             _leftViewShowing = NO;
             
             [self hideLeftViewDone];
             
             if (finished)
                 [self hiddensInvalidate];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];
             
             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:0.f];
        [self leftViewLayoutInvalidateWithPercentage:0.f];
        [self hideLeftViewDone];
        
        _leftViewShowing = NO;
        
        [self hiddensInvalidate];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];
        
        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewDone
{
    if (kLGSideMenuSystemVersion >= 7.0)
    {
        [self addChildViewController:_rootVC];
        
        _currentPreferredStatusBarHidden = _savedStatusBarHidden;
        _currentPreferredStatusBarStyle = _savedStatusBarStyle;
        
        _waitingForUpdateStatusBar = YES;
        
        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideLeftViewComleteAfterGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];
    
    _leftViewShowing = NO;
    
    [self hideLeftViewDone];
    [self hiddensInvalidate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];
}

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible)
    {
        if (self.isLeftViewShowing)
            [self hideLeftViewAnimated:animated completionHandler:completionHandler];
        else
            [self showLeftViewAnimated:animated completionHandler:completionHandler];
    }
}


#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self hideLeftViewAnimated:YES completionHandler:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    // -----
    
    CGSize size = self.view.frame.size;
    
    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }
    
    // -----
    
    if (_leftView && self.isLeftViewSwipeGestureEnabled && !kLGSideMenuIsLeftViewAlwaysVisible && self.shouldShowLeftView)
    {
        if (!_leftViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged))
        {
            CGFloat interactiveX = (self.isLeftViewShowing ? _leftViewWidth : 0.f);
            BOOL velocityDone = (self.isLeftViewShowing ? velocity.x < 0.f : velocity.x > 0.f);
            
            CGFloat shiftLeft = -44.f;
            CGFloat shiftRight = (_swipeGestureArea == LGSideMenuSwipeGestureAreaBorders ? (self.isLeftViewShowing ? 22.f : 44.f) :  _rootVC.view.bounds.size.width);
            
            if (velocityDone && location.x >= interactiveX+shiftLeft && location.x <= interactiveX+shiftRight)
            {
                _leftViewGestireStartX = [NSNumber numberWithFloat:location.x];
                _leftViewShowingBeforeGesture = _leftViewShowing;
                
                if (!self.isLeftViewShowing)
                    [self showLeftViewPrepare];
            }
        }
        else if (_leftViewGestireStartX)
        {
            CGFloat firstVar = (self.isLeftViewShowingBeforeGesture ?
                                location.x+(_leftViewWidth-_leftViewGestireStartX.floatValue) :
                                location.x-_leftViewGestireStartX.floatValue);
            
            CGFloat percentage = firstVar/_leftViewWidth;
            
            if (percentage < 0.f) percentage = 0.f;
            else if (percentage > 1.f) percentage = 1.f;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
            {
                [self rootViewLayoutInvalidateWithPercentage:percentage];
                [self leftViewLayoutInvalidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && _leftViewGestireStartX)
            {
                if ((percentage < 1.f && velocity.x > 0.f) || (velocity.x == 0.f && percentage >= 0.5))
                    [self showLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if ((percentage > 0.f && velocity.x < 0.f) || (velocity.x == 0.f && percentage < 0.5))
                    [self hideLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if (percentage == 0.f)
                    [self hideLeftViewComleteAfterGesture];
                else if (percentage == 1.f)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];
                
                _leftViewGestireStartX = nil;
            }
        }
    }
    
    // -----
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [touch.view isEqual:_rootViewCoverViewForLeftView] ;
}

#pragma mark - Support

+ (void)animateStandardWithDuration:(NSTimeInterval)duration animations:(void(^)())animations completion:(void(^)(BOOL finished))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:animations
                         completion:completion];
    }
    else
    {
        [UIView animateWithDuration:duration*0.66
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:completion];
    }
}

@end
