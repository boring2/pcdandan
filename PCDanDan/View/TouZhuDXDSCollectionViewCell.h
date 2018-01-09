//
//  TouZhuDXDSCollectionViewCell.h
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBiLiInfo.h"

@protocol TouZhuDXDSCollectionViewCellDelegate <NSObject>
@optional
- (void)clickIconWithIndex:(NSInteger )index withParentIndex:(NSInteger)parentIndex;
@end

@interface TouZhuDXDSCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (void)updateUI;
@property (assign, nonatomic) NSInteger  selectDXDSIndex;//大小单双选择投资数字
@property (assign, nonatomic) NSInteger  selectCSZIndex;//猜数字选择投资数字
@property (assign, nonatomic) NSInteger  selectTSWFIndex;//特殊玩法选择投资数字

// multiselect
@property (strong, nonatomic) NSMutableArray *selectDXDSIndexs;//大小单双多选
@property (strong, nonatomic) NSMutableArray *selectCSZIndexs;//猜数字多选
@property (strong, nonatomic) NSMutableArray *selectTSWFIndexs;//特殊玩法多选

@property (strong, nonatomic) GameBiLiInfo *gameBiLiInfo;
@property (assign, nonatomic) NSInteger showType;//0 大小单双 1、单数字 2、特殊玩法
@property (nonatomic, assign) id<TouZhuDXDSCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@end
