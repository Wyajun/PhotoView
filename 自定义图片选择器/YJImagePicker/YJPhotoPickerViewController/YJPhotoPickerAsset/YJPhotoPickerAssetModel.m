//
//  YJPhotoPickerAssetModel.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerAssetModel.h"
#import "YJPhotoPickerMgr.h"
@interface YJPhotoPickerAssetModel()
@property(nonatomic,strong)id<YJPhotoPickerGroupProtocol>group;
@property(nonatomic,strong)NSArray <id<YJPhotoPickerAssetProtocol>> *assetList;
@end
@implementation YJPhotoPickerAssetModel

-(instancetype)initWithGroup:(id<YJPhotoPickerGroupProtocol>)group {
    self = [super init];
    if (self) {
        self.group = group;
    }
    return self;
}

-(void)fetchAssets:(void (^)())callback {
    __weak typeof(self)weak = self;
    [[YJPhotoPickerMgr sharePhotoPickerMgr] getGroupPhotosWithGroup:self.group finished:^(NSArray<id<YJPhotoPickerAssetProtocol>> *assetList) {
        weak.assetList = assetList;
        callback();
    }];
}

-(NSArray <id<YJPhotoPickerAssetProtocol>> *)assets {
    return self.assetList;
}
@end
