//
//  DarenCenterScrollView.h
//  CycleScrollViewDemo
//
//  Created by strivingboy on 15/5/11.
//
//

#import <UIKit/UIKit.h>
#import "ScrollDirection.h"

@interface CycleScrollView : UIView
@property (nonatomic, copy) void(^scrolledToPageAtIndex)(NSInteger index);
@property (nonatomic, copy) void(^pageViewDataAtIndex)(UIView *view, NSInteger index);
@property (nonatomic, copy) void(^scrollingPercent)(ScrollDirection direction, CGFloat percent, NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame pageViewNumber:(NSInteger)number PageViewClass:(Class)cls;

- (void)switchPageToIndex:(NSInteger)index;

- (NSInteger)currentPageIndex;
@end
