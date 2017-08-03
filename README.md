#iOS开发：瀑布流的实现

![效果GIF.gif](http://upload-images.jianshu.io/upload_images/1840399-11bfec804563c6c8.gif?imageMogr2/auto-orient/strip)

效果的实现，主要是对`UICollectionViewLayout`进行封装，我的.h文件中：

```
#import <UIKit/UIKit.h>

@class CustomeViewLayout;
@protocol CustomViewLayoutDelegate <NSObject>

/**
 计算item高度的代理方法，将item的高度与indexPath传给外界
 */
- (CGFloat)customFallLayout:(CustomeViewLayout *)customFallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

//实现了瀑布流功能，但是不能添加头部和底部视图，如项目中有添加头部或底部视图的需求，请慎用！！！
@interface CustomeViewLayout : UICollectionViewLayout

/**
 总列数，默认是2
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 列间距，默认是0
 */
@property (nonatomic, assign) float columnSpacing;

/**
 行间距，默认是0
 */
@property (nonatomic, assign) float rowSpacing;

/**
 section与CollectionView的间距，上、左、下、右，默认是(0, 0, 0, 0)
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 同时设置列间距、行间距、sectionInset

 @param columnSpacing 列间距
 @param rowSpacing 行间距
 @param sectionInset 设置上、左、下、右的距离
 */
- (void)setColumnSpacing:(float)columnSpacing rowSpacing:(float)rowSpacing sectionInset:(UIEdgeInsets)sectionInset;

#pragma mark ====== 代理方法、block二选其一 ======
/**
 一下代理属性与block属性二选其一，用来设置每一个item的高度
 会将item的高度与indexPath传递给外界
 如果两个都设置，block的优先级高，即代理无效
 */

/**
 代理方法，用来计算item的高度
 */
@property (nonatomic, assign) id<CustomViewLayoutDelegate> delegate;

/**
 计算item高度的block，将item的高度与indexPath传递给外界
 */
@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemHeight, NSIndexPath *indexPath);

#pragma mark ====== 构造方法 ======
+ (instancetype)customFallLayoutWithColumnCount:(float)columnCount;
- (instancetype)initWithColumCount:(float)columnCount;

@end

```
上面的文件主要是给外界提供一个接口，可以设置行数、行间距、列间距

实现的文件中，主要是找到`UICollectionView`中，最短的列数的最大Y值，把后面需要添加的item添加到这一列的下面，主要代码如下：

```
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    } else {
        if ([self.delegate respondsToSelector:@selector(customFallLayout:itemHeightForWidth:atIndexPath:)]) {
            itemHeight = [self.delegate customFallLayout:self itemHeightForWidth:itemWidth atIndexPath:indexPath];
        }
    }
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDic[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}
```
具体实现请看demo，里面有说明，[参考文章](http://www.jianshu.com/p/b92e1b1073fd)