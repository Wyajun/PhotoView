//
//  YJPhotoPickerAssetViewController.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPhotoPickerGroupProtocol.h"
@interface YJPhotoPickerAssetViewController : UIViewController
@property(nonatomic,strong)id<YJPhotoPickerGroupProtocol>group;
@end
