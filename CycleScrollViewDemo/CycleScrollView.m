//
//  DarenCenterScrollView.m
//  CycleScrollViewDemo
//
//  Created by strivingboy on 15/5/11.
//
//

#import "CycleScrollView.h"


@interface CycleScrollView()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *pageViews;

@property (nonatomic) NSInteger totalPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) Class viewClass;
@end

@implementation CycleScrollView

- (instancetype)initWithFrame:(CGRect)frame pageViewNumber:(NSInteger)number PageViewClass:(Class)cls;
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [NSMutableArray array];
        _totalPages = number;
        _currentPage = 0;
        _viewClass = cls;
        [self initScrollView];
    }
    return self;
}

- (void)dealloc
{
    _scrollView.delegate = nil;
}

- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollView];
    for (NSInteger i = 0; i < 3; i++) {
        UIView *view= [[_viewClass alloc] initWithFrame:self.bounds];
        [_pageViews addObject:view];
        view.frame = CGRectOffset(view.frame, view.frame.size.width * i, 0);
        [_scrollView addSubview:view];
    }
}

- (NSInteger)currentPageIndex
{
    return _currentPage;
}

- (NSInteger)validPageValue:(NSInteger)value
{
    if (value == -1) {
        value = _totalPages - 1;
    }
    if (value == _totalPages) {
        value = 0;
    }
    return value;
}

- (void)loadViewsData
{
    NSInteger pre = [self validPageValue:_currentPage - 1];
    NSInteger last = [self validPageValue:_currentPage + 1];
    assert(_pageViewDataAtIndex);
    assert(_pageViews.count == 3);
    _pageViewDataAtIndex(_pageViews[0], pre);
    _pageViewDataAtIndex(_pageViews[1], _currentPage);
    _pageViewDataAtIndex(_pageViews[2], last);
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)switchPageToIndex:(NSInteger)index
{
    _currentPage = index;
    [self loadViewsData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    // 下一页
    if(offsetX >= (2 * self.frame.size.width)) {
        _currentPage = [self validPageValue:_currentPage+1];
        [self loadViewsData];
    }
    
    // 上一页
    if(offsetX <= 0) {
        _currentPage = [self validPageValue:_currentPage-1];
        [self loadViewsData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    if (self.scrolledToPageAtIndex) {
        self.scrolledToPageAtIndex(_currentPage);
    }
}

@end
