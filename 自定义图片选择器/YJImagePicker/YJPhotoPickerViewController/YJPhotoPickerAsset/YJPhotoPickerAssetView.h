//
//  YJPhotoPickerAssetView.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPhotoPickerAssetModel.h"
@interface YJPhotoPickerAssetView : UIView
@property(nonatomic,strong)YJPhotoPickerAssetModel *assetModel;
@property(nonatomic,weak)UIViewController *pushVc;
@end
