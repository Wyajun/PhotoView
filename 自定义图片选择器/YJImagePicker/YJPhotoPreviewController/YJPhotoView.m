//
//  YJPhotoView.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/14.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoView.h"
#import "Masonry.h"
@interface YJPhotoView ()
{
    BOOL _zoomByDoubleTap;
   
}
@property(nonatomic,strong) UIImageView *imageView;
@end
@implementation YJPhotoView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
//        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        }];
        
        // 属性
        self.delegate = self;
        //		self.showsHorizontalScrollIndicator = NO;
        //		self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

//设置imageView的图片
- (void)configImageViewWithImage:(UIImage *)image{
    _imageView.image = image;
}


#pragma mark - photoSetter
-(void)setAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    _asset = asset;
    [self showImage];
}
#pragma mark 显示图片
- (void)showImage
{
    [self photoStartLoad];
    
    
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    __weak typeof(self)weak = self;
    _asset.compressionImage = ^(UIImage *image) {
        weak.scrollEnabled = YES;
        weak.imageView.image = image;
        [weak adjustFrame];
    };
    
//    if (_photo.image) {
//        [_photoLoadingView removeFromSuperview];
//        _imageView.image = _photo.image;
//        self.scrollEnabled = YES;
//    } else {
//        _imageView.image = _photo.placeholder;
//        self.scrollEnabled = NO;
//        // 直接显示进度条
//        [_photoLoadingView showLoading];
//        [self addSubview:_photoLoadingView];
//        
//        ESWeakSelf;
//        ESWeak_(_photoLoadingView);
//        ESWeak_(_imageView);
//        
//        [SDWebImageManager.sharedManager downloadImageWithURL:_photo.url options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            ESStrong_(_photoLoadingView);
//            if (receivedSize > kMinProgress) {
//                __photoLoadingView.progress = (float)receivedSize/expectedSize;
//            }
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            ESStrongSelf;
//            ESStrong_(_imageView);
//            __imageView.image = image;
//            [_self photoDidFinishLoadWithImage:image];
//        }];
//    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
//    if (image) {
//        self.scrollEnabled = YES;
//        _photo.image = image;
//        [_photoLoadingView removeFromSuperview];
//        
//        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
//            [self.photoViewDelegate photoViewImageFinishLoad:self];
//        }
//    } else {
//        [self addSubview:_photoLoadingView];
//        [_photoLoadingView showFailure];
//    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = _imageView.image.size.width;
    CGFloat imageHeight = _imageView.image.size.height;
    
    // 设置伸缩比例
    CGFloat imageScale = boundsWidth / imageWidth;
    CGFloat minScale = MIN(0.5, imageScale);
    
    CGFloat maxScale = 3.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
    
    self.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
    _imageView.frame = imageFrame;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (_zoomByDoubleTap) {
        CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
        insetY = MAX(insetY, 0.0);
        if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
            CGRect imageViewFrame = _imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            _imageView.frame = imageViewFrame;
        }
    }
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _zoomByDoubleTap = NO;
    CGFloat insetY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(_imageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (ABS(_imageView.frame.origin.y - insetY) > 0.5) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect imageViewFrame = _imageView.frame;
            imageViewFrame = CGRectMake(imageViewFrame.origin.x, insetY, imageViewFrame.size.width, imageViewFrame.size.height);
            _imageView.frame = imageViewFrame;
        }];
    }
}

#pragma mark - 手势处理
//单击隐藏
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
//    // 移除进度条
//    [_photoLoadingView removeFromSuperview];
//    
//    // 通知代理
//    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
//        [self.photoViewDelegate photoViewSingleTap:self];
//    }
}
//双击放大
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _zoomByDoubleTap = YES;
    
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self];
        CGFloat scale = self.maximumZoomScale/ self.zoomScale;
        CGRect rectTozoom=CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self zoomToRect:rectTozoom animated:YES];
    }
}

- (void)dealloc
{
    // 取消请求
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

@end
