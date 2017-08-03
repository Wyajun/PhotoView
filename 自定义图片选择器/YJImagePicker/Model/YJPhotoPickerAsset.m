//
//  YJPhotoPickerAsset.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YJPhotoPickerMgr.h"
#import "YJPhotoHeader.h"
@interface YJPhotoPickerCam:YJPhotoPickerAsset
@property(nonatomic,strong)NSString *timeString;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *orgImage;
@property(nonatomic,strong)UIImage *cacheImage;
-(instancetype)initWithImage:(UIImage*)image;
@end

@interface YJPhotoPickerAssetiOS7:YJPhotoPickerAsset
@property(nonatomic,strong)ALAsset *alasset;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *orgImage;
-(instancetype)initWithALAsset:(ALAsset*)asset;
@end
@interface YJPhotoPickerAssetiOS8Later : YJPhotoPickerAsset
@property(nonatomic,strong)PHAsset *alasset;
@property(nonatomic,strong)UIImage *cacheImage;
@property(nonatomic,strong)void(^assetImage)( UIImage *image);
@property(nonatomic,strong)void(^compressImage) (UIImage *orgImage);
@property(nonatomic)PHImageRequestID   imageRequestID;
-(instancetype)initWithPHAsset:(PHAsset*)asset;
@end
@implementation YJPhotoPickerCam
-(instancetype)initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        self.orgImage = image;
        self.image = image;
        self.timeString = [NSString stringWithFormat:@"%@",[NSDate date]];
    }
    return self;
}

-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    
    thumbImage(self.image);
}
-(void)setCompressionImage:(void (^)(UIImage *))compressionImage {
    compressionImage(self.orgImage);
}
-(BOOL)isEqual:(id)object {
    id<YJPhotoPickerAssetProtocol> asset = object;
    return  [self.assetURL isEqualToString:asset.assetURL];
}
-(UIImage *)originImage {
    return self.orgImage;
}
-(NSString *)assetURL {
    return self.timeString;
}
@end

@implementation YJPhotoPickerAsset
@dynamic thumbImage,originImage,isVideoType,compressionImage,asset,assetURL,isCacheImg,cacheImg;
+(instancetype)initWithasset:(id)asset {
    if ([asset isKindOfClass:[ALAsset class]]) {
        return [[YJPhotoPickerAssetiOS7 alloc] initWithALAsset:asset];
    }
    if ([asset isKindOfClass:[PHAsset class]]) {
        return [[YJPhotoPickerAssetiOS8Later alloc] initWithPHAsset:asset];
    }
    return nil;
}
+(instancetype)initWithImage:(UIImage *)image {
    return [[YJPhotoPickerCam alloc] initWithImage:image];
}
@end
@implementation YJPhotoPickerAssetiOS7
-(instancetype)initWithALAsset:(ALAsset *)asset {
    self = [super init];
    if (self) {
        self.alasset = asset;
    }
    return self;
}
-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    UIImage *image = [UIImage imageWithCGImage:[self.alasset thumbnail]];
    thumbImage(image);
}
-(void)setCompressionImage:(void (^)(UIImage *))compressionImage {
    
    UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
    compressionImage(image);
}
-(UIImage *)originImage {
    return  [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
}
-(BOOL)isEqual:(id)object {
    id<YJPhotoPickerAssetProtocol> asset = object;
    return  [self.assetURL isEqualToString:asset.assetURL];
}
-(NSString *)assetURL {
    return [[self.alasset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
}
-(BOOL)isCacheImg {
    return YES;
}
-(UIImage *)cacheImg {
    return [UIImage imageWithCGImage:[self.alasset thumbnail]];
}
@end
@implementation YJPhotoPickerAssetiOS8Later

-(instancetype)initWithPHAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        self.alasset = asset;
    }
    return self;
}
-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    _assetImage = nil;
    if (self.cacheImage) {
        thumbImage(self.cacheImage);
        return;
    }
    [[YJPhotoPickerMgr sharePhotoPickerMgr] cancelImageRequest:self.imageRequestID];
    _assetImage = thumbImage;
    __weak typeof(self)weak = self;
    NSInteger width = kScreenWidth/4;
    if (width > 101) {
        width = 101;
    }
   self.imageRequestID = [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:self.alasset photoWidth:width synchronous:NO completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
       @autoreleasepool {
           weak.cacheImage = image;
           if (weak.assetImage) {
               weak.assetImage(image);
           }
       }
       
    }];
}
-(void)setCompressionImage:(void (^)(UIImage *))compressionImage {
    self.compressImage = compressionImage;
    __weak typeof(self)weak = self;
    [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:self.alasset photoWidth:kScreenWidth synchronous:NO completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
        weak.compressionImage(image);
    }];
}
-(BOOL)isEqual:(id)object {
    id<YJPhotoPickerAssetProtocol> asset = object;
    return  [self.assetURL isEqualToString:asset.assetURL];
}
-(NSString *)assetURL {
    return  self.alasset.localIdentifier;
}
-(UIImage *)originImage {
    
    __block UIImage *orgimage = nil;
    [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:self.alasset photoWidth:kScreenWidth synchronous:YES completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
        orgimage = image;
    }];
    return orgimage;
}
-(BOOL)isCacheImg {
    if (self.cacheImage) {
        return  YES;
    }
    return NO;
}
-(UIImage *)cacheImg {
    return self.cacheImage;
}
-(void)removeAllObjects {
    self.cacheImage = nil;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
}

@end