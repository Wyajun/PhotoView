//
//  YJPhotoPickerViewController.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerViewController.h"
#import "YJPhotoPickerAssetViewController.h"
#import "YJPhotoPickerModel.h"
#import "YJPhotoPickerView.h"
#import "YJPhotoPickerMgr.h"
#import "Masonry.h"
@interface YJPhotoPickerViewController()
@property(nonatomic,weak)YJPhotoPickerView *pickerView;
@property(nonatomic,strong)YJPhotoPickerModel *pickerModel;
@end
@implementation YJPhotoPickerViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    YJPhotoPickerView  *pickerView = [[YJPhotoPickerView alloc] init];
    [self.view addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.left.and.right.mas_equalTo(0);
    }];
    pickerView.pushVc = self;
    self.pickerModel = [[YJPhotoPickerModel alloc] init];
    self.pickerView = pickerView;
    self.pickerView.pickerModel = self.pickerModel;
    self.title = @"照片";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)pushFristPickerModel {
    YJPhotoPickerAssetViewController *assetViewController = [[YJPhotoPickerAssetViewController alloc] init];
    
    assetViewController.group = [self.pickerModel.group firstObject];
    [self.navigationController pushViewController:assetViewController animated:NO];
}

+(void)showViewController:(UIViewController *)vc pickerModel:(YJPhotoPickerConfigModel *)pickerConfigModel {
    YJPhotoPickerViewController *picker = [[YJPhotoPickerViewController alloc] init];
    [YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel = pickerConfigModel;
    [vc presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
}

@end
