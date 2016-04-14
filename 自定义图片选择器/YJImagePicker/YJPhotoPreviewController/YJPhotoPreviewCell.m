//
//  YJPhotoPreviewCell.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/13.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPreviewCell.h"
#import "Masonry.h"
#import "YJPhotoView.h"
#import "YJPhotoHeader.h"
@interface YJPhotoPreviewCell()
@property(nonatomic,strong)YJPhotoView *imgView;
@property(nonatomic,strong)UIButton *actionBnt;
@end
@implementation YJPhotoPreviewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self creatViews];
    }
    return self;
}
-(void)creatViews {
    _imgView = [[YJPhotoView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
//    _imgView.contentMode = UIViewContentModeScaleAspectFill;
//    _imgView.clipsToBounds = YES;
    
    [self.contentView addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
//    UIButton *actionBnt = [[UIButton alloc] init];
//    actionBnt.backgroundColor = [UIColor redColor];
//    [actionBnt setImage:[UIImage imageNamed:@"photo_def_previewVc"] forState:UIControlStateNormal];
//    [actionBnt setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
//    [self.contentView addSubview:actionBnt];
//    [actionBnt addTarget:self action:@selector(actionBnuttonPress:) forControlEvents:UIControlEventTouchUpInside];
//    [actionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.and.right.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(87, 187));
//    }];
//    _actionBnt = actionBnt;
    
}
-(void)setAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    _asset = asset;
    _imgView.asset = asset;
    
}

-(void)actionBnuttonPress:(UIButton *)sender {
//    if (sender.selected) {
//        [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel removeAsset:self.asset];
//    }else {
//        [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel addAsset:self.asset];
//    }
//    sender.selected = !sender.selected;
    NSLog(@"bntpress");
}

@end
