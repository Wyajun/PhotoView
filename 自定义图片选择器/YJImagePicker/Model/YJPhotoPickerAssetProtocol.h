//
//  YJPhotoPickerAssetProtocol.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol YJPhotoPickerAssetProtocol <NSObject>
/**
 *  缩略图
 */
@property(nonatomic,copy)void (^thumbImage) (UIImage *);
/**
 *  压缩原图
 */
@property(nonatomic,strong) void (^compressionImage) (UIImage *);
/**
 *  原图
 */
@property(nonatomic,strong) UIImage *originImage;
/**
 *  获取是否是视频类型, Default = false
 */
@property (assign,nonatomic) BOOL isVideoType;

@property (strong,nonatomic) id asset;
/**
 *  获取相册的URL
 */
@property(nonatomic,copy) NSString *assetURL;
@end
