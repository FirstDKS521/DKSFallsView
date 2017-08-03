//
//  ViewController.m
//  DKSFallsView
//
//  Created by aDu on 2017/8/2.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "ViewController.h"
#import "CustomeViewLayout.h"
#import "CustomCell.h"

#define K_Cell @"cell"
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CustomViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.collectionView];
}

#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_Cell forIndexPath:indexPath];
    return cell;
}

#pragma mark ====== 设置高度 ======
- (CGFloat)customFallLayout:(CustomeViewLayout *)customFallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    return arc4random() % 50 + 100;
}

#pragma mark ====== init ======
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CustomeViewLayout *flowLayout = [[CustomeViewLayout alloc] init];
        flowLayout.columnCount = 2; //共多少列
        flowLayout.columnSpacing = 10; //列间距
        flowLayout.rowSpacing = 10; //行间距
        //设置collectionView整体的上下左右之间的间距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        flowLayout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_Width, K_Height) collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:K_Cell];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
