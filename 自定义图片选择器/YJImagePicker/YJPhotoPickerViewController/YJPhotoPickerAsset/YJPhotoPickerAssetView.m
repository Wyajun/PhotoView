//
//  YJPhotoPickerAssetView.m
//  自定义图片选择器
//
//  Created by 王亚军 on 16/4/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "YJPhotoPickerAssetView.h"
#import "YJPhotoPreviewViewController.h"
#import "YJPhotoPickerAssetCell.h"
#import "Masonry.h"
#import "YJPhotoHeader.h"
#import "YJPhotoPickerMgr.h"
@interface YJPhotoPickerAssetView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectView;
@end
static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 44;
static NSString *const cellIdentifier = @"YJPhotoPickerAssetCell";
@implementation YJPhotoPickerAssetView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatCollectView];
    }
    return self;
}
-(void)creatCollectView {
    
    CGFloat cellW = (kScreenWidth - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellW, cellW);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = CELL_LINE_MARGIN;
    layout.footerReferenceSize = CGSizeMake(kScreenWidth, TOOLBAR_HEIGHT * 2);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[YJPhotoPickerAssetCell class] forCellWithReuseIdentifier:cellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(5, 0,TOOLBAR_HEIGHT, 0);
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.collectView = collectionView;
}

-(void)setAssetModel:(YJPhotoPickerAssetModel *)assetModel {
    _assetModel = assetModel;
    __weak typeof(self)weak = self;
    [self.assetModel fetchAssets:^{
        [weak.collectView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetModel.assets.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJPhotoPickerAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.asset = self.assetModel.assets[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YJPhotoPreviewViewController *proview = [[YJPhotoPreviewViewController alloc] init];
    proview.configModel = [[YJPhotoPickerMgr sharePhotoPickerMgr] pickerModel];
    [self.pushVc.navigationController pushViewController:proview animated:YES];
}

@end
