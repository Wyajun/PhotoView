//
//  YJPhotoPickerFetchProtocol.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YJPhotoPickerGroupProtocol.h"
#import "YJPhotoPickerAssetProtocol.h"

typedef void(^GroupAllBack)(NSArray<id<YJPhotoPickerGroupProtocol>> *group);
typedef void(^GroupAllAsset)(NSArray<id<YJPhotoPickerAssetProtocol>> *assetList);

@protocol YJPhotoPickerFetchProtocol <NSObject>
/*
 * 获取所有的组
 */
-(void)fetchAllPhotos:(GroupAllBack)callback;
/**
 * 传入一个组获取组里面的Asset
 */
- (void) getGroupPhotosWithGroup : (id<YJPhotoPickerGroupProtocol>) pickerGroup finished:(GroupAllAsset ) callBack;
@optional
/**
 * 传入phAsset
 */
- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth synchronous:(BOOL)sync completion:(void (^)(UIImage *, NSDictionary *, BOOL isDegraded))completion;
/**
 * 清楚图片缓存
 */
-(void)cleanAllAsset;
/*
 *
 */
-(void)cancelImageRequest:(PHImageRequestID)requestID;
@end
