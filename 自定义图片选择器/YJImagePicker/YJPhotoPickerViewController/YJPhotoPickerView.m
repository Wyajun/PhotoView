//
//  YJPhotoPickerView.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerView.h"
#import "YJPhotoPickerCell.h"
#import "Masonry.h"
#import "YJPhotoPickerAssetViewController.h"
@interface YJPhotoPickerView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic) BOOL firstShow;
@end
static NSString *const cellId = @"YJPhotoPickerCell";

@implementation YJPhotoPickerView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.firstShow = YES;
        [self creatTableView];
    }
    return self;
}
-(void)creatTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[YJPhotoPickerCell class] forCellReuseIdentifier:cellId];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
}
#pragma mark --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.pickerModel.group) {
        
    }
    return self.pickerModel.group.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJPhotoPickerCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    pickerCell.group = self.pickerModel.group[indexPath.row];
    return pickerCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<YJPhotoPickerGroupProtocol>group = self.pickerModel.group[indexPath.row];
    [self pushViewControllerWithGroup:group];
}

-(void)pushViewControllerWithGroup:(id<YJPhotoPickerGroupProtocol>)group {
    YJPhotoPickerAssetViewController *assetViewController = [[YJPhotoPickerAssetViewController alloc] init];
    assetViewController.group = group;
    [self.pushVc.navigationController pushViewController:assetViewController animated:YES];
}

#pragma mark --
-(void)setPickerModel:(YJPhotoPickerModel *)pickerModel {
    _pickerModel = pickerModel;
    __weak typeof(self)weak = self;
    [self.pickerModel fetchGroup:^{
        if ([NSThread isMainThread]) {
            if (weak.firstShow) {
                [weak pushFristPickerModel];
                weak.firstShow = NO;
            }
            [weak.tableView reloadData];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weak.firstShow) {
                    [weak pushFristPickerModel];
                    weak.firstShow = NO;
                }
                [weak.tableView reloadData];
            });
        }
       
        
    }];
    
}
-(void)pushFristPickerModel {
    YJPhotoPickerAssetViewController *assetViewController = [[YJPhotoPickerAssetViewController alloc] init];
    
    assetViewController.group = [self.pickerModel.group firstObject];
    [self.pushVc.navigationController pushViewController:assetViewController animated:NO];
}
@end
