//
//  YJPhotoPickerModel.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/13.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJPhotoPickerAssetProtocol.h"
@interface YJPhotoPickerConfigModel : NSObject
@property(nonatomic)NSInteger MaxSelectAsset;
@property(nonatomic,copy)void(^selectedAsset)(NSArray <id<YJPhotoPickerAssetProtocol>> *);
@property(nonatomic,strong)NSArray <id<YJPhotoPickerAssetProtocol>> *selectedAssetList;


-(void)addAsset:(id<YJPhotoPickerAssetProtocol>)asset;
-(void)removeAsset:(id<YJPhotoPickerAssetProtocol>)asset;
-(BOOL)isExitAsset:(id<YJPhotoPickerAssetProtocol>)asset;
-(void)clearAsset;
-(void)selectedEnd;
@end
