//
//  YJPhotoPickerAssetModel.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJPhotoPickerAssetProtocol.h"
#import "YJPhotoPickerGroupProtocol.h"
@interface YJPhotoPickerAssetModel : NSObject
@property(nonatomic,strong)NSArray <id<YJPhotoPickerAssetProtocol>> *assets;
-(instancetype)initWithGroup:(id<YJPhotoPickerGroupProtocol>)group;
-(void)fetchAssets:(void(^)())callback;
@end
