//
//  YJPhotoPreviewView.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/13.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPreviewView.h"
#import "YJPhotoPreviewCell.h"
#import "Masonry.h"
#import "YJPhotoHeader.h"

#define BUBBLE_DIAMETER     [UIScreen mainScreen].bounds.size.width
#define BUBBLE_PADDING      20.0

@interface YJPhotoPreviewView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectView;
@end
static NSString *const cellIdentifier = @"YJPhotoPickerAssetCell";
@implementation YJPhotoPreviewView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatCollectView];
    }
    return self;
}
-(void)creatCollectView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = BUBBLE_PADDING;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 修复最后空白问题，contentsize不够问题
    layout.footerReferenceSize =CGSizeMake(BUBBLE_PADDING, kScreenHeight);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[YJPhotoPreviewCell class] forCellWithReuseIdentifier:cellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.clipsToBounds = NO;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth + BUBBLE_PADDING);
    }];
    self.collectView = collectionView;
}
-(void)setConfigModel:(YJPhotoPickerConfigModel *)configModel {
    _configModel = configModel;
    [self.collectView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.configModel.selectedAssetList.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.asset = self.configModel.selectedAssetList[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"ssddfkdslfjkkkkkk");
}
@end
