//
//  YJPhotoPreviewViewController.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/13.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPreviewViewController.h"
#import "Masonry.h"
#import "YJPhotoPreviewView.h"
#import "YJPhotoPickerConfigModel.h"
@interface YJPhotoPreviewViewController()
@property(nonatomic,weak) YJPhotoPreviewView *preView;
@end

@implementation YJPhotoPreviewViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    YJPhotoPreviewView  *preView = [[YJPhotoPreviewView alloc] init];
    [self.view addSubview:preView];
    [preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.left.and.right.mas_equalTo(0);
    }];
    self.preView = preView;
    self.preView.configModel = self.configModel;
}
@end
