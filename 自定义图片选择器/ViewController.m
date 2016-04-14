//
//  ViewController.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/8.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "YJPhotoPickerViewController.h"
@interface ViewController ()
@property(nonatomic,strong)NSArray *assetList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [button addTarget:self action:@selector(pickerViewShow) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)pickerViewShow {
    
    YJPhotoPickerConfigModel *configModel = [[YJPhotoPickerConfigModel alloc] init];
    configModel.selectedAssetList = self.assetList;
    configModel.MaxSelectAsset = 9;
    configModel.selectedAsset = ^(NSArray <id<YJPhotoPickerAssetProtocol>> *assetList) {
        self.assetList = assetList;
    };
    
    [YJPhotoPickerViewController showViewController:self pickerModel:configModel];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
