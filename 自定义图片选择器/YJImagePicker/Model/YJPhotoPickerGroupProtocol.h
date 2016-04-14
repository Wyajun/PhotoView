//
//  YJPhotoPickerGroupProtocol.h
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol YJPhotoPickerGroupProtocol <NSObject>
/**
 *  组名
 */
@property (nonatomic , copy) NSString *groupName;

/**
 *  缩略图
 */
@property(nonatomic,copy)void (^thumbImage) (UIImage *);

/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger assetsCount;

/**
 *  类型 : Saved Photos...
 */
@property (nonatomic , copy) NSString *type;
/**
 * group 
 */
@property (nonatomic , strong) id group;
@end
