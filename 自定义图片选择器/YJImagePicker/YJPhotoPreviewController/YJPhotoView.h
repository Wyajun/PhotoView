//
//  YJPhotoView.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/14.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPhotoPickerAssetProtocol.h"
@interface YJPhotoView : UIScrollView <UIScrollViewDelegate>
@property(nonatomic,strong)id<YJPhotoPickerAssetProtocol>asset;
@end
