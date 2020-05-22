//
//  ZQEasyShowLoadingView.m
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQEasyShowLoadingView.h"
#import "ZQEasyConfigHeader.h"

#import "ZQEasyShowBackgroundView.h"
#import "UIView+ZQEasyShowExt.h"
#import "ZQEasyShowLabel.h"

@interface ZQEasyShowLoadingView()<CAAnimationDelegate>

@property (nonatomic,strong)ZQEasyShowOptions *options ;

@property (nonatomic,strong)NSString *showText ;//展示的文字
@property (nonatomic,strong)NSString *showImageName ;//展示的图片

@property (nonatomic,strong)UIView *loadingBgView ;//上面放着 textlabel 和 imageview
@property (nonatomic,strong)UILabel *textLabel ;
@property (nonatomic,strong)UIImageView *imageView ;

@property (nonatomic,strong)UIActivityIndicatorView *imageViewIndeicator ;


@end

@implementation ZQEasyShowLoadingView

- (void)dealloc
{
}


+ (void)showLoading
{
    [self showLoadingText:@""];
}

+ (void)showLoadingText:(NSString *)text
{
    UIView *showView = [ZQEasyShowConfig topViewController].view ;
    if ([ZQEasyShowOptions sharedEasyShowOptions].loadingShowOnWindow) {
        showView = [UIApplication sharedApplication].keyWindow ;
    }
    [self showLoadingText:text inView:showView];
}

+ (void)showLoadingText:(NSString *)text inView:(UIView *)superView
{
    [self showLoadingText:text imageName:nil inView:superView];
}

+ (void)showLoadingText:(NSString *)text imageName:(NSString *)imageName
{
    UIView *showView = [ZQEasyShowConfig topViewController].view ;
    if ([ZQEasyShowOptions sharedEasyShowOptions].loadingShowOnWindow) {
        showView = [UIApplication sharedApplication].keyWindow ;
    }
    [self showLoadingText:text imageName:imageName inView:showView];
}

+ (void)showLoadingText:(NSString *)text imageName:(NSString *)imageName inView:(UIView *)superView
{
    [self showLoadingWithText:text inView:superView imageName:imageName];
}

+ (void)showLoadingWithText:(NSString *)text
                    inView:(UIView *)view
                 imageName:(NSString *)imageName
{
    
    if (nil == view) {
        NSAssert(NO, @"there shoud have a superview");
        return ;
    }
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
        });
    }
    
    //显示之前---->隐藏还在显示的视图
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            ZQEasyShowLoadingView *showView = (ZQEasyShowLoadingView *)subview ;
            [showView removeSelfFromSuperView];
        }
    }
    
    ZQEasyShowLoadingView *showView = [[ZQEasyShowLoadingView alloc] initWithFrame:CGRectZero];
    showView.showText = text ;
    showView.showImageName = imageName ;
    [showView showViewWithSuperView:view];
   
}

+ (void)hiddenLoading
{
    UIView *showView = [ZQEasyShowConfig topViewController].view ;
    if ([ZQEasyShowOptions sharedEasyShowOptions].loadingShowOnWindow) {
        showView = [UIApplication sharedApplication].keyWindow ;
    }
    [self hiddenLoading:showView];
}

+ (void)hiddenLoading:(UIView *)superView
{
    NSEnumerator *subviewsEnum = [superView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            ZQEasyShowLoadingView *showView = (ZQEasyShowLoadingView *)subview ;

            [showView removeSelfFromSuperView];
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor =  [UIColor clearColor]; // [UIColor greenColor] ;//
    }
    return self ;
}

- (void)showViewWithSuperView:(UIView *)superView
{
    //展示视图的frame
    
    CGSize imageSize = CGSizeZero ;
    switch (self.options.loadingShowType) {
        case LoadingShowTypeTurnAround:
        case LoadingShowTypeTurnAroundLeft:
        case LoadingShowTypeIndicator:
        case LoadingShowTypeIndicatorLeft:
            imageSize = CGSizeMake(ZQEasyShowLoadingImageWH, ZQEasyShowLoadingImageWH);
            break;
        case LoadingShowTypePlayImages:
        case LoadingShowTypePlayImagesLeft:
        {
            NSAssert(self.options.loadingPlayImagesArray, @"you should set a image array!") ;
            UIImage *image = self.options.loadingPlayImagesArray.firstObject ;
            CGSize tempSize = image.size ;
            if (tempSize.height > ZQEasyShowLoadingImageMaxWH) {
                tempSize.height = ZQEasyShowLoadingImageMaxWH ;
            }
            if (tempSize.width > ZQEasyShowLoadingImageMaxWH) {
                tempSize.width = ZQEasyShowLoadingImageMaxWH ;
            }
            imageSize = tempSize ;
        }break ;
        case LoadingShowTypeImageUpturn:
        case LoadingShowTypeImageUpturnLeft:
        case LoadingShowTypeImageAround:
        case LoadingShowTypeImageAroundLeft:
        {
            UIImage *image = [[UIImage imageNamed:self.showImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            CGSize tempSize = image.size ;
            if (tempSize.height > ZQEasyShowLoadingImageMaxWH) {
                tempSize.height = ZQEasyShowLoadingImageMaxWH ;
            }
            if (tempSize.width > ZQEasyShowLoadingImageMaxWH) {
                tempSize.width = ZQEasyShowLoadingImageMaxWH ;
            }
            imageSize = tempSize ;
        }break ;
        default:
            break;
    }

    
    if (!ISEMPTY_S(self.showText)) {
        self.textLabel.text = self.showText ;
    }
    
    CGFloat textMaxWidth = ZQEasyShowLoadingMaxWidth - (self.options.loadingShowType%2 ? :(ZQEasyShowLoadingImageWH+ZQEasyShowLoadingImageEdge*2)) ;//当为左右形式的时候减去图片的宽度
    CGSize textSize = [self.textLabel sizeThatFits:CGSizeMake(textMaxWidth, MAXFLOAT)];
    if (ISEMPTY_S(self.showText)) {
        textSize = CGSizeZero ;
    }
   
    //显示区域的宽高
    CGSize displayAreaSize = CGSizeZero ;
    if (self.options.loadingShowType%2) {
        //左右形式
        displayAreaSize.width = imageSize.width + ZQEasyShowLoadingImageEdge*2 + textSize.width ;
        displayAreaSize.height = MAX(imageSize.height+ ZQEasyShowLoadingImageEdge*2, textSize.height) ;
    }
    else{
        //上下形式
        displayAreaSize.width = MAX(imageSize.width+2*ZQEasyShowLoadingImageEdge, textSize.width);
        displayAreaSize.height = imageSize.height+2*ZQEasyShowLoadingImageEdge + textSize.height ;
    }

    
    if (self.options.loadingSuperViewReceiveEvent) {
        //父视图能够接受事件 。 显示区域的大小=self的大小=displayAreaSize

        [self setFrame:CGRectMake((kScreen_Width-displayAreaSize.width)/2, (kScreen_Height-displayAreaSize.height)/2, displayAreaSize.width, displayAreaSize.height)];
    }
    else{
        //父视图不能接收-->self的大小应该为superview的大小。来遮盖
        
        [self setFrame: CGRectMake(0, 0, superView.width, superView.height)] ;
      
        self.loadingBgView.center = self.center ;

    }
    
    self.loadingBgView.frame = CGRectMake(0,0, displayAreaSize.width,displayAreaSize.height) ;
    if (!self.options.loadingSuperViewReceiveEvent) {
        self.loadingBgView.center = self.center ;
    }
    
    self.imageView.frame = CGRectMake(ZQEasyShowLoadingImageEdge, ZQEasyShowLoadingImageEdge, imageSize.width, imageSize.height) ;
    if (!(self.options.loadingShowType%2)) {
        self.imageView.centerX = self.loadingBgView.width/2 ;
    }
   
    CGFloat textLabelX = 0 ;
    CGFloat textLabelY = 0 ;
    if (self.options.loadingShowType%2) {//左右形式
        textLabelX = self.imageView.right  ;
        textLabelY =  (self.loadingBgView.height-textSize.height)/2 ;
    }
    else{
        textLabelX = 0 ;
        textLabelY = self.imageView.bottom + ZQEasyShowLoadingImageEdge ;
    }
    self.textLabel.frame = CGRectMake(textLabelX, textLabelY, textSize.width, textSize.height );
    
    [superView addSubview:self];
    if (self.options.loadingCycleCornerWidth > 0) {
        [_loadingBgView setRoundedCorners:self.options.loadingCycleCornerWidth];
    }
    
    switch (self.options.loadingShowType) {
        case LoadingShowTypeTurnAround:
        case LoadingShowTypeTurnAroundLeft:
            [self drawAnimationImageViewLoading];
            break;
        case LoadingShowTypeIndicator:
        case LoadingShowTypeIndicatorLeft:
            [self.imageView addSubview:self.imageViewIndeicator];
            break ;
        case LoadingShowTypePlayImages:
        case LoadingShowTypePlayImagesLeft:
        {
            UIImage *tempImage  = self.options.loadingPlayImagesArray.firstObject ;
            if (tempImage) {
                self.imageView.image = tempImage ;
            }
        }
            break ;
        case LoadingShowTypeImageUpturn:
        case LoadingShowTypeImageUpturnLeft:
            
        case LoadingShowTypeImageAround:
        case LoadingShowTypeImageAroundLeft:
        {
            UIImage *image = [[UIImage imageNamed:self.showImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (image) {
                self.imageView.image = image ;
            }
            else{
                NSAssert(NO, @"iamgeName is illgal ");
            }
        } break ;
        default:
            break;
    }
    
    
    void (^completion)(void) = ^{
        switch (self.options.loadingShowType) {
            case LoadingShowTypeTurnAround:
            case LoadingShowTypeTurnAroundLeft:
                [self drawAnimiationImageView:NO];
                break;
            case LoadingShowTypeIndicator:
            case LoadingShowTypeIndicatorLeft:
                [self.imageViewIndeicator startAnimating];
                break ;
            case LoadingShowTypePlayImages:
            case LoadingShowTypePlayImagesLeft:
            {
                NSMutableArray *tempArray= [NSMutableArray arrayWithCapacity:20];
                for (int i = 0 ; i < self.options.loadingPlayImagesArray.count; i++) {
                    UIImage *img = self.options.loadingPlayImagesArray[i] ;
                    if ([img isKindOfClass:[UIImage class]]) {
                        [tempArray addObject:img];
                    }
                }
                self.imageView.animationImages = tempArray ;
                self.imageView.animationDuration = ZQEasyShowAnimationTime ;
//                self.imageView.animationRepeatCount = NSIntegerMax ;
                [self.imageView startAnimating];
                
            }break ;
            case LoadingShowTypeImageUpturn:
            case LoadingShowTypeImageUpturnLeft:
                [self drawAnimiationImageView:YES];
                break ;
            case LoadingShowTypeImageAround:
            case LoadingShowTypeImageAroundLeft:
                [self drawGradientaLayerAmination];
                break ;
            default:
                break;
        }
    };
   
    
    switch (self.options.loadingAnimationType) {
        case LoadingAnimationTypeNone:
            completion() ;
            break;
        case LoadingAnimationTypeBounce:
            [self showBounceAnimationStart:YES completion:completion];
            break ;
        case LoadingAnimationTypeFade:
            [self showFadeAnimationStart:YES completion:completion ] ;
            break ;
        default:
            break;
    }
    
}

- (void)drawGradientaLayerAmination
{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    CGFloat layerRadius = self.imageView.width/2*1.0f ;
    shapeLayer.frame = CGRectMake(.0f, .0f,  layerRadius*2.f+3,  layerRadius*2.f+3) ;
    
    CGFloat cp = layerRadius+3/2.f;
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(cp, cp) radius:layerRadius startAngle:.0f endAngle:.75f*M_PI clockwise:YES];
    shapeLayer.path = p.CGPath;
    
    shapeLayer.strokeColor = self.options.loadingTintColor.CGColor;
    shapeLayer.lineWidth=2.0f;

    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(.0f, .5f);
    gradientLayer.endPoint = CGPointMake(1.f, .5f);
    gradientLayer.frame = shapeLayer.frame ;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:6];
    for(int i=10;i>=0;i-=2) {
        [tempArray addObject:(__bridge id)[self.options.loadingTintColor colorWithAlphaComponent:i*.1f].CGColor];
    }
    gradientLayer.colors = tempArray;
    gradientLayer.mask = shapeLayer;
    [self.imageView.layer addSublayer:gradientLayer];

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(2.f*M_PI);
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;

    [gradientLayer addAnimation:animation forKey:@"GradientLayerAnimation"];
}
- (void)removeSelfFromSuperView
{
    NSAssert([NSThread isMainThread], @"needs to be accessed on the main thread.");
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
        });
    }
    
    
    void (^completion)(void) = ^{
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    };
    switch (self.options.loadingAnimationType) {
        case LoadingAnimationTypeNone:
            completion() ;
            break;
        case LoadingAnimationTypeBounce:
            [self showBounceAnimationStart:NO completion:completion];
            break ;
        case LoadingAnimationTypeFade:
            [self showFadeAnimationStart:NO completion:completion ] ;
            break ;
        default:
            break;
    }
}


#pragma mark - animation
// 转圈动画
- (void)drawAnimiationImageView:(BOOL)isImageView
{
    NSString *keyPath = isImageView ? @"transform.rotation.y" : @"transform.rotation.z" ;
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue=@(0);
    animation.toValue=@(M_PI*2);
    animation.duration=isImageView ? 1.3 : .8;
    animation.repeatCount=HUGE;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageView.layer addAnimation:animation forKey:@"animation"];
}


- (void)showFadeAnimationStart:(BOOL)isStart completion:(void(^)(void))completion
{
    self.alpha = isStart ? 0.1f : 1.0f;
    [UIView animateWithDuration:ZQEasyShowAnimationTime animations:^{
        self.alpha = isStart ? 1.0 : 0.1f ;
    } completion:^(BOOL finished) {
        if (completion) {
            completion() ;
        }
    }];
}
- (void)showBounceAnimationStart:(BOOL)isStart completion:(void(^)(void))completion
{
    if (isStart) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = ZQEasyShowAnimationTime ;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        popAnimation.delegate = self ;
        [popAnimation setValue:completion forKey:@"handler"];
        [self.loadingBgView.layer addAnimation:popAnimation forKey:nil];
        return ;
    }
    CABasicAnimation *bacAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bacAnimation.duration = ZQEasyShowAnimationTime ;
    bacAnimation.beginTime = .0;
    bacAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.3f :0.5f :-0.5f];
    bacAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    bacAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[bacAnimation];
    animationGroup.duration =  bacAnimation.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;

//    animationGroup.delegate = self ;
//    [animationGroup setValue:completion forKey:@"handler"];
    [self.loadingBgView.layer addAnimation:animationGroup forKey:nil];
   
    [self performSelector:@selector(ddd) withObject:nil afterDelay:bacAnimation.duration];
}
- (void)ddd
{
    [self removeFromSuperview];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}
//加载loading的动画
- (void)drawAnimationImageViewLoading
{
    CGPoint centerPoint= CGPointMake(self.imageView.width/2.0f, self.imageView.height/2.0f) ;
    UIBezierPath *beizPath=[UIBezierPath bezierPathWithArcCenter:centerPoint radius:centerPoint.x startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    CAShapeLayer *centerLayer=[CAShapeLayer layer];
    centerLayer.path=beizPath.CGPath;
    centerLayer.fillColor=[UIColor clearColor].CGColor;//填充色
    centerLayer.strokeColor=self.options.loadingTintColor.CGColor;//边框颜色
    centerLayer.lineWidth=2.0f;
    centerLayer.lineCap=kCALineCapRound;//线框类型
    
    [self.imageView.layer addSublayer:centerLayer];
    
}


#pragma mark - getter

- (ZQEasyShowOptions *)options
{
    if (nil == _options) {
        _options = [ZQEasyShowOptions sharedEasyShowOptions];
    }
    return _options ;
}
- (UIView *)loadingBgView
{
    if (nil == _loadingBgView) {
        _loadingBgView = [[UIView alloc]init] ;
        _loadingBgView.backgroundColor = self.options.loadingBackgroundColor ;
        [self addSubview:_loadingBgView];
    }
    return _loadingBgView ;
}
- (UIImageView *)imageView
{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.tintColor = self.options.loadingTintColor ;
        [self.loadingBgView addSubview:_imageView];
    }
    return _imageView ;
}
- (UILabel *)textLabel
{
    if (nil == _textLabel) {
        _textLabel = [[ZQEasyShowLabel alloc]initWithContentInset:UIEdgeInsetsMake(10, 20, 10, 20)];
        _textLabel.textColor = self.options.loadingTintColor;
        _textLabel.font = self.options.loadingTextFount ;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter ;
        _textLabel.numberOfLines = 0 ;
        [self.loadingBgView addSubview:_textLabel];
    }
    return _textLabel ;
}

- (UIActivityIndicatorView *)imageViewIndeicator
{
    if (nil == _imageViewIndeicator) {
        UIActivityIndicatorViewStyle style = self.options.loadingShowType%2 ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleWhiteLarge ;
        _imageViewIndeicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        _imageViewIndeicator.tintColor = self.options.loadingTintColor ;
        _imageViewIndeicator.color = self.options.loadingTintColor ;
        _imageViewIndeicator.backgroundColor = [UIColor clearColor];
        _imageViewIndeicator.frame = self.imageView.bounds ;
    }
    return _imageViewIndeicator ;
}

@end
