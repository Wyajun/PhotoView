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
@interface YJPhotoPickerAssetiOS7:YJPhotoPickerAsset
@property(nonatomic,strong)ALAsset *alasset;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *orgImage;
-(instancetype)initWithALAsset:(ALAsset*)asset;
@end
@interface YJPhotoPickerAssetiOS8Later : YJPhotoPickerAsset
@property(nonatomic,strong)PHAsset *alasset;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *orgImage;
-(instancetype)initWithPHAsset:(PHAsset*)asset;
@end
@implementation YJPhotoPickerAsset
@dynamic thumbImage,originImage,isVideoType,compressionImage,asset,assetURL;
+(instancetype)initWithasset:(id)asset {
    if ([asset isKindOfClass:[ALAsset class]]) {
        return [[YJPhotoPickerAssetiOS7 alloc] initWithALAsset:asset];
    }
    if ([asset isKindOfClass:[PHAsset class]]) {
        return [[YJPhotoPickerAssetiOS8Later alloc] initWithPHAsset:asset];
    }
    return nil;
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
    if (!self.image) {
        self.image = [UIImage imageWithCGImage:[self.alasset thumbnail]];
    }
    thumbImage(self.image);
}
-(void)setCompressionImage:(void (^)(UIImage *))compressionImage {
    if (!self.orgImage) {
        UIImage *image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
        self.orgImage = image;
    }
    compressionImage(self.orgImage);
}
-(BOOL)isEqual:(id)object {
    id<YJPhotoPickerAssetProtocol> asset = object;
    return  [self.assetURL isEqualToString:asset.assetURL];
}
-(NSString *)assetURL {
    return [[self.alasset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
}
@end
@implementation YJPhotoPickerAssetiOS8Later

-(instancetype)initWithPHAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.alasset = asset;
    }
    return self;
}
-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    if (self.image) {
        thumbImage(self.image);
    }else{
        __weak typeof(self)weak = self;
        [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:self.alasset photoWidth:150 synchronous:NO completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
            weak.image = image;
            thumbImage(image);
        }];
    }
}
-(void)setCompressionImage:(void (^)(UIImage *))compressionImage {
    if (self.orgImage) {
        compressionImage(self.orgImage);
    }else{
        if(self.image) {
            return compressionImage(self.image);
        }
        __weak typeof(self)weak = self;
        [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:self.alasset photoWidth:kScreenWidth synchronous:NO completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
            weak.image = image;
             compressionImage(image);
        }];
    }
}
-(BOOL)isEqual:(id)object {
    id<YJPhotoPickerAssetProtocol> asset = object;
    return  [self.assetURL isEqualToString:asset.assetURL];
}
-(NSString *)assetURL {
    return  self.alasset.localIdentifier;
}
@end