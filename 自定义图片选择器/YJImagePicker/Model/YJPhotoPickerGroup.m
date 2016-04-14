//
//  YJPhotoPickerGroup.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YJPhotoPickerMgr.h"
@interface YJPhotoPickerGroupiOS7 : YJPhotoPickerGroup
@property(nonatomic,strong)ALAssetsGroup *assetsGroup;
-(instancetype)initWithAssetsGroup:(ALAssetsGroup *)group;
@end
@interface YJPhotoPickerGroupiOS8Later : YJPhotoPickerGroup
@property(nonatomic,strong)PHFetchResult *fetchResult;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)UIImage *lastImage;
-(instancetype)initWithFetchResult:(PHFetchResult *)fetchResult;
@end

@implementation YJPhotoPickerGroup
@dynamic groupName,type,thumbImage,group,assetsCount;
+(instancetype)initWithGroup:(id)group {
    
    if([group isKindOfClass:[ALAssetsGroup class]]) {
        return [[YJPhotoPickerGroupiOS7 alloc] initWithAssetsGroup:group];
    }
    if([group isKindOfClass:[PHFetchResult class]]) {
        return [[YJPhotoPickerGroupiOS8Later alloc] initWithFetchResult:group];
    }
    return nil;
}

@end

@implementation YJPhotoPickerGroupiOS7
-(instancetype)initWithAssetsGroup:(ALAssetsGroup *)group {
    self = [super init];
    if (self) {
        self.assetsGroup = group;
    }
    return self;
}
-(NSString *)groupName {
    return [self.assetsGroup valueForProperty:@"ALAssetsGroupPropertyName"];
}
-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    thumbImage([UIImage imageWithCGImage:[self.assetsGroup posterImage]]);
}
-(NSInteger )assetsCount {
    return [self.assetsGroup numberOfAssets];
}
-(id)group {
    return self.assetsGroup;
}
@end
@implementation YJPhotoPickerGroupiOS8Later

-(instancetype)initWithFetchResult:(PHFetchResult *)fetchResult {
    self = [super init];
    if (self) {
        self.fetchResult = fetchResult;
    }
    return self;
}
-(void)setThumbImage:(void (^)(UIImage *))thumbImage {
    if (self.lastImage) {
        thumbImage(self.lastImage);
        return;
    }
    __weak typeof(self)weak = self;
    [[YJPhotoPickerMgr sharePhotoPickerMgr] getPhotoWithAsset:[self.fetchResult lastObject] photoWidth:150 synchronous:NO completion:^(UIImage *image, NSDictionary *info, BOOL isDegraded) {
        weak.lastImage = image;
        thumbImage(self.lastImage);
    }];
    
}
-(NSInteger)assetsCount {
    return self.fetchResult.count;
}
-(NSString *)groupName {
    return  self.name;
}
-(id)group {
    return self.fetchResult;
}
-(void)setGroupName:(NSString *)groupName {
    self.name = groupName;
}

@end
