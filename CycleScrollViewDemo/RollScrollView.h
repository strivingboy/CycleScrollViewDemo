//
//  RollScrollView.h
//  CycleScrollViewDemo
//
//  Created by tusu on 15/6/7.
//
//

#import <UIKit/UIKit.h>

@interface RollScrollView : UIScrollView

@property (nonatomic, copy) void(^selectedTabIndex)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray *)titles;

- (void)swithTabToIndex:(NSInteger)tabId;

@end
