//
//  YJPhotoPickerMgr.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerMgr.h"

#import "YJPhotoPickerGroup.h"
#import "YJPhotoPickerAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YJPhotoHeader.h"
@interface YJPhotoPickerMgr ()

-(instancetype)initSuper;

@end

@interface YJPhotoPickerMgriOS7 : YJPhotoPickerMgr
@property(nonatomic,strong)ALAssetsLibrary *library;

@end

@interface YJPhotoPickerMgriOS8Later : YJPhotoPickerMgr
@property(nonatomic,strong)PHCachingImageManager *manger;
@end



@implementation YJPhotoPickerMgr
+(instancetype)sharePhotoPickerMgr {
    static YJPhotoPickerMgr *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (iOS8Later ) {
            share = [[YJPhotoPickerMgriOS8Later alloc] initSuper];
        }else {
        share = [[YJPhotoPickerMgriOS7 alloc] initSuper];
        }
    });
    return share;
}
-(instancetype)initSuper {
    return [super init];
}
-(instancetype)init {
    NSAssert(NO, @"请使用 sharePhotoPickerMgr 方法创建对象");
    return nil;
}
#pragma mark --

#pragma mark --
-(void)fetchAllPhotos:(GroupAllBack)callback {
    
}
-(void)getGroupPhotosWithGroup:(id<YJPhotoPickerGroupProtocol>)pickerGroup finished:(GroupAllAsset)callBack {
    
}

#pragma mark --

@end

@implementation YJPhotoPickerMgriOS7
-(instancetype)initSuper {
    self = [super initSuper];
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
  
}
-(void)fetchAllPhotos:(GroupAllBack)callback {
    NSMutableArray<id<YJPhotoPickerGroupProtocol>> *groups = [[NSMutableArray alloc] init];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            // 包装一个模型来赋值
            YJPhotoPickerGroup *pickerGroup = [YJPhotoPickerGroup initWithGroup:group];
            [groups addObject:pickerGroup];
        }else{
            callback(groups);
        }
    };
    NSInteger type = ALAssetsGroupAll;
    [self.library enumerateGroupsWithTypes:type usingBlock:resultBlock failureBlock:nil];
}
-(void)getGroupPhotosWithGroup:(id<YJPhotoPickerGroupProtocol>)pickerGroup finished:(GroupAllAsset)callBack {
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock result = ^(ALAsset *asset , NSUInteger index , BOOL *stop){
        if (asset) {
            [assets addObject:[YJPhotoPickerAsset initWithasset:asset]];
        }else{
            callBack(assets);
        }
    };
    [pickerGroup.group enumerateAssetsUsingBlock:result];
}
-(void)cancelImageRequest:(PHImageRequestID)requestID {
    
}
-(void)cleanAllAsset {
    
}
@end
@implementation YJPhotoPickerMgriOS8Later
-(instancetype)initSuper {
    self = [super initSuper];
    if (self) {
        self.manger = [[PHCachingImageManager alloc] init];
        
    }
    return self;
}
-(void)fetchAllPhotos:(GroupAllBack)callback {
    
    [self requestAuthorization:^(BOOL success) {
        if (success) {
            [self fetchAllPhotosAuthorization:callback];
        }else {
            callback(nil);
        }
    }];
    
}
-(void)requestAuthorization:(void(^)(BOOL))callback {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
                callback(NO);
                break;
            case PHAuthorizationStatusAuthorized:
                callback(YES);
                break;
            case PHAuthorizationStatusNotDetermined:
                callback(NO);
                break;
            default:
                break;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

-(void)fetchAllPhotosAuthorization:(GroupAllBack)callback {
    
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //        if (!allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;
    // For iOS 9, We need to show ScreenShots Album && SelfPortraits Album
    if (iOS9Later) {
        smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle containsString:@"Deleted"]) continue;
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
        } else {
            [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if (fetchResult.count < 1) continue;
        if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
            [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
        } else {
            [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    callback(albumArr);
}

- (void)getGroupPhotosWithGroup:(id<YJPhotoPickerGroupProtocol>)pickerGroup finished:(GroupAllAsset)callBack {
    PHFetchResult *fetchResult = (PHFetchResult *)pickerGroup.group;
     NSMutableArray *assets = [NSMutableArray array];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        if (asset) {
            [assets addObject:[YJPhotoPickerAsset initWithasset:asset]];
        }
    }];
    callBack(assets);
}
- (YJPhotoPickerGroup *)modelWithResult:(id)result name:(NSString *)name{
    YJPhotoPickerGroup *group  = [YJPhotoPickerGroup initWithGroup:result];
    group.groupName = [self getNewAlbumName:name];
    return group;
}
-(PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth synchronous:(BOOL)sync completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion {
    
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        NSInteger pixelWidth = photoWidth * multiple;
        NSInteger pixelHeight = pixelWidth / aspectRatio;
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.synchronous = sync;
       return  [self.manger requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
           @autoreleasepool {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue] );
            if (downloadFinined) {
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
           }
        }];
   
}
- (NSString *)getNewAlbumName:(NSString *)name {
    if (iOS8Later) {
        NSString *newName;
        if ([name containsString:@"Roll"])         newName = @"相机胶卷";
        else if ([name containsString:@"Stream"])  newName = @"我的照片流";
        else if ([name containsString:@"Added"])   newName = @"最近添加";
        else if ([name containsString:@"Selfies"]) newName = @"自拍";
        else if ([name containsString:@"shots"])   newName = @"截屏";
        else if ([name containsString:@"Videos"])  newName = @"视频";
        else newName = name;
        return newName;
    } else {
        return name;
    }
}
-(void)cleanAllAsset {
    self.manger = [[PHCachingImageManager alloc] init];
}
-(void)cancelImageRequest:(PHImageRequestID)requestID {
    [self.manger cancelImageRequest:requestID];
}
@end

