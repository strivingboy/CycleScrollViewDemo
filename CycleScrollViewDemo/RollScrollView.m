//
//  RollScrollView.m
//  CycleScrollViewDemo
//
//  Created by tusu on 15/6/7.
//
//

#import "RollScrollView.h"
#import "UIColor+Extents.h"

// Tab 分割线高度
#define kTabSplitLineHeight 20
// Tab 按钮开始Id
#define kTabBaseId 100
// Tab 按钮空隙
#define KTabGap 0
// Tab Title字体大小
#define kTabTitleFontSize 16.0f
// Tab Title 默认颜色
#define kTabTitleColorNormal @"#000000"
// Tab Title 选中颜色
#define kTabTitleColorSelected @"#EC7239"
// Tab 背景颜色
#define kTabTitleBkColor @"#FEFEFE"
// Tab 分割条颜色
#define kTabTitleSplitLineColor @"#DFE3E6"

@interface RollScrollView()<UIScrollViewDelegate>

@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSInteger userSelectedId;        //点击按钮选择名字ID
@property (nonatomic) UIImageView *shadowImageView;    //选中阴影
@property (nonatomic) NSMutableArray *buttonOriginXArray;
@property (nonatomic) NSMutableArray *buttonWithArray;
@property (nonatomic) UIView *buttomLineView;
@end

@implementation RollScrollView

- (instancetype)initWithFrame:(CGRect)frame topTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        _titlesArray = titles;
        self.delegate = self;
        self.backgroundColor = [UIColor colorFromHexString:kTabTitleBkColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _userSelectedId = kTabBaseId;
        _buttonOriginXArray = [NSMutableArray array];
        _buttonWithArray = [NSMutableArray array];
        [self initWithTitleTabs];
        return self;
    }
    return nil;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)initWithTitleTabs
{
    CGFloat xPos = KTabGap;
    for (NSInteger i = 0; i < _titlesArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [_titlesArray objectAtIndex:i];
        [button setTag:i + kTabBaseId];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kTabTitleFontSize];
        [button setTitleColor:[UIColor colorFromHexString:kTabTitleColorNormal]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorFromHexString:kTabTitleColorSelected]
                     forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectTabButton:)
         forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width
                               -(_titlesArray.count + 2)*KTabGap) / _titlesArray.count;
        
        button.frame = CGRectMake(xPos, 0, buttonWidth+KTabGap, self.frame.size.height);
        [_buttonOriginXArray addObject:@(xPos)];
        xPos += buttonWidth+KTabGap;
        [_buttonWithArray addObject:@(button.frame.size.width)];
        [self addSubview:button];
        UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(xPos,
                                                                     (self.frame.size.height - kTabSplitLineHeight)/2,
                                                                     1,
                                                                     kTabSplitLineHeight)];
        splitLine.backgroundColor = [UIColor colorFromHexString:kTabTitleSplitLineColor];
        [self addSubview:splitLine];
    }
    
    self.contentSize = CGSizeMake(xPos, 0);
    _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KTabGap,
                                                                     self.frame.size.height - 2,
                                                                     [[_buttonWithArray objectAtIndex:0] floatValue],
                                                                     2)];
    [_shadowImageView setImage:[UIImage imageNamed:@"bottom_line"]];
    [self addSubview:_shadowImageView];
    
    _buttomLineView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               self.frame.size.height-1,
                                                               self.frame.size.width,
                                                               1)];
    _buttomLineView.backgroundColor = [UIColor colorFromHexString:kTabTitleSplitLineColor];
    [self addSubview:_buttomLineView];
    
}

- (void)selectTabButton:(UIButton *)sender
{
    NSInteger tag = sender.tag - kTabBaseId;
    if (sender.tag != _userSelectedId) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedId];
        lastButton.selected = NO;
        _userSelectedId = sender.tag;
    }
    if (!sender.selected) {
        sender.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x,
                                                  self.frame.size.height - 2,
                                                  [[_buttonWithArray objectAtIndex:tag] floatValue],
                                                  2)];
        } completion:^(BOOL finished) {
            if (self.selectedTabIndex) {
                self.selectedTabIndex(sender.tag - kTabBaseId);
            }
        }];
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    // 在此处理超过一屏幕tab页
    NSInteger tag = sender.tag - kTabBaseId;
    float originX = [[_buttonOriginXArray objectAtIndex:tag] floatValue];
    float width = [[_buttonWithArray objectAtIndex:tag] floatValue];
    
    if (sender.frame.origin.x - self.contentOffset.x >
        [UIScreen mainScreen].bounds.size.width-(KTabGap+width)) {
        [self setContentOffset:CGPointMake(originX - 100, 0)  animated:YES];
    }
    
    if (sender.frame.origin.x - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}

- (void)unSelectLastButton
{
    UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedId];
    lastButton.selected = NO;
}

- (void)swithTabToIndex:(NSInteger)tabId
{
    [self unSelectLastButton];
    UIButton *button = (UIButton *)[self viewWithTag:tabId+kTabBaseId];
    if (!button.selected) {
        button.selected = YES;
        _userSelectedId = button.tag;
    }
}

- (void)updateTabOffsetWithDirection:(ScrollDirection)direction withPercent:(CGFloat)percent atIndex:(NSInteger)tabId
{
    UIButton *button = (UIButton *)[self viewWithTag:tabId+kTabBaseId];
    CGFloat tabWith =  [[_buttonWithArray objectAtIndex:button.tag-kTabBaseId] floatValue];
    CGFloat xPos = 0.f;
    if (direction == ScrollDirectionLeft) {
        xPos =  button.frame.origin.x + tabWith * percent;
    } else if (direction == ScrollDirectionRight) {
        xPos =  button.frame.origin.x - tabWith * (1- percent);
    } else {
        xPos =  button.frame.origin.x;
    }
    [_shadowImageView setFrame:CGRectMake(xPos,
                                          self.frame.size.height - 2,
                                          tabWith,
                                          2)];
}

@end
