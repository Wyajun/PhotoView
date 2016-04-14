//
//  YJPhotoPickerCell.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerCell.h"
#import "Masonry.h"
@interface YJPhotoPickerCell ()
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation YJPhotoPickerCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        make.left.mas_equalTo(0);
        make.top.and.bottom.mas_equalTo(0);
        make.width.equalTo(_imgView.mas_height);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_imgView.mas_right).with.offset(10);
    }];
    UIView *div = [[UIView alloc] init];
    div.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:div];
    [div mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(.5);
        make.bottom.mas_equalTo(0);
    }];
}
-(void)setGroup:(id<YJPhotoPickerGroupProtocol>)group {
    _group = group;
    group.thumbImage =^(UIImage *image) {
         _imgView.image = image;
    };
    _titleLab.text = [NSString stringWithFormat:@"%@(%@)",group.groupName,@(group.assetsCount)];
}
@end
