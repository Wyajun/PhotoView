//
//  YJPhotoPickerMgr.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJPhotoPickerFetchProtocol.h"
#import "YJPhotoPickerAssetProtocol.h"
#import "YJPhotoPickerConfigModel.h"
@interface YJPhotoPickerMgr : NSObject <YJPhotoPickerFetchProtocol>
@property(nonatomic,strong)YJPhotoPickerConfigModel *pickerModel;
+(instancetype)sharePhotoPickerMgr;
@end

