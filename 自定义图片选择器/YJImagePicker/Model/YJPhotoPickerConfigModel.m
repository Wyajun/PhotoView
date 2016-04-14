//
//  YJPhotoPickerModel.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/13.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerConfigModel.h"
@interface YJPhotoPickerConfigModel()
@property(nonatomic,strong)NSMutableArray *assetList;
@end
@implementation YJPhotoPickerConfigModel
-(void)setSelectedAssetList:(NSArray<id<YJPhotoPickerAssetProtocol>> *)selectedAssetList {
    for (id asset in selectedAssetList) {
        [self addAsset:asset];
    }
}
-(NSArray<id<YJPhotoPickerAssetProtocol>> *)selectedAssetList {
    return self.assetList;
}
-(void)addAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    [self.assetList addObject:asset];
}
-(void)removeAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    
    [self.assetList removeObject:asset];
}
-(BOOL)isExitAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    
    return [self.assetList containsObject:asset];
}

-(void)clearAsset {
    self.assetList = nil;
    self.MaxSelectAsset = 1;
}
-(void)selectedEnd {
    self.selectedAsset(self.assetList);
}
-(NSMutableArray *)assetList {
    if (_assetList) {
        return _assetList;
    }
    _assetList = [[NSMutableArray alloc] init];
    return _assetList;
}
@end
