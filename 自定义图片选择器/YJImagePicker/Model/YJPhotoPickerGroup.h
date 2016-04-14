//
//  YJPhotoPickerGroup.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YJPhotoPickerGroupProtocol.h"
#import "YJPhotoPickerAssetProtocol.h"
@interface YJPhotoPickerGroup : NSObject<YJPhotoPickerGroupProtocol>

@property (nonatomic , strong) NSArray<id<YJPhotoPickerAssetProtocol>>* assetList;
+(instancetype)initWithGroup:(id)group;
@end
