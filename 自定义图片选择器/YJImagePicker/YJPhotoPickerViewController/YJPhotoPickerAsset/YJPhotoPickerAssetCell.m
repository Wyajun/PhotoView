//
//  YJPhotoPickerAssetCell.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerAssetCell.h"
#import "YJPhotoPickerMgr.h"
#import "Masonry.h"
@interface YJPhotoPickerAssetCell()
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIButton *actionBnt;
@end
@implementation YJPhotoPickerAssetCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatViews];
    }
    return self;
}
-(void)creatViews {
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIButton *actionBnt = [[UIButton alloc] init];
    [actionBnt setImage:[UIImage imageNamed:@"photo_def_previewVc"] forState:UIControlStateNormal];
    [actionBnt setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
    [self.contentView addSubview:actionBnt];
    [actionBnt addTarget:self action:@selector(actionBnuttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [actionBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    _actionBnt = actionBnt;
}
-(void)setAsset:(id<YJPhotoPickerAssetProtocol>)asset {
    _asset = asset;
     asset.thumbImage = ^(UIImage *image) {
         _imgView.image = image;
    };
    _actionBnt.selected = [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel isExitAsset:asset];
}

-(void)actionBnuttonPress:(UIButton *)sender {
    if (sender.selected) {
        [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel removeAsset:self.asset];
    }else {
        [[YJPhotoPickerMgr sharePhotoPickerMgr].pickerModel addAsset:self.asset];
    }
    sender.selected = !sender.selected;
}

@end
