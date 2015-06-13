//
//  RollScrollView.h
//  CycleScrollViewDemo
//
//  Created by tusu on 15/6/7.
//
//

#import <UIKit/UIKit.h>
#import "ScrollDirection.h"

@interface RollScrollView : UIScrollView

@property (nonatomic, copy) void(^selectedTabIndex)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray *)titles;

- (void)swithTabToIndex:(NSInteger)tabId;

- (void)updateTabOffsetWithDirection:(ScrollDirection)direction withPercent:(CGFloat)percent atIndex:(NSInteger)tabId;

@end
