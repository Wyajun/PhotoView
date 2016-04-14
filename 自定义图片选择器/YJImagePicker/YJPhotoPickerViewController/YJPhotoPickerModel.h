//
//  YJPhotoPickerModel.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJPhotoPickerGroupProtocol.h"
@interface YJPhotoPickerModel : NSObject
@property(nonatomic,strong)NSArray <id<YJPhotoPickerGroupProtocol>> *group;
-(void)fetchGroup:(void(^)())callback;
@end
