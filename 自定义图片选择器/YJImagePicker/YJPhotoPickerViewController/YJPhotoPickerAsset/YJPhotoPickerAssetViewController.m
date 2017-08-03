//
//  YJPhotoPickerAssetViewController.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerAssetViewController.h"
#import "Masonry.h"
#import "YJPhotoPickerAssetView.h"
#import "YJPhotoPickerAssetModel.h"
#import "YJPhotoPickerMgr.h"
@interface YJPhotoPickerAssetViewController()
@property(nonatomic,weak)YJPhotoPickerAssetView *pickerView;
@property(nonatomic,strong)YJPhotoPickerAssetModel *assetModel;
@end
@implementation YJPhotoPickerAssetViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    YJPhotoPickerAssetView  *pickerView = [[YJPhotoPickerAssetView alloc] init];
    [self.view addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.left.and.right.mas_equalTo(0);
    }];
    pickerView.pushVc = self;
    self.assetModel = [[YJPhotoPickerAssetModel alloc] initWithGroup:self.group];
    self.pickerView = pickerView;
    self.pickerView.assetModel = self.assetModel;
    self.title = self.group.groupName;
    UIButton *doneBnt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [doneBnt setTitle:@"完成" forState:UIControlStateNormal];
    [doneBnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBnt addTarget:self action:@selector(doneButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:doneBnt];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)doneButtonPress {
    [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel selectedEnd];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
