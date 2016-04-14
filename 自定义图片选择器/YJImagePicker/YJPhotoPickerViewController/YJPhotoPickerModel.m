//
//  YJPhotoPickerModel.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerModel.h"
#import "YJPhotoPickerMgr.h"
@interface YJPhotoPickerModel()
@property(nonatomic,strong)NSArray <id<YJPhotoPickerGroupProtocol>> *groupList;
@end


@implementation YJPhotoPickerModel
-(void)fetchGroup:(void (^)())callback {
    __weak typeof(self)weak = self;
    [[YJPhotoPickerMgr sharePhotoPickerMgr] fetchAllPhotos:^(NSArray<id<YJPhotoPickerGroupProtocol>> *group) {
        weak.groupList = group;
        callback();
    }];
}
-(NSArray <id<YJPhotoPickerGroupProtocol>> *)group {
    return self.groupList;
}
@end
