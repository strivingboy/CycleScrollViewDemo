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

@property (nonatomic) CGFloat lastOffset;
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
        _lastOffset = frame.size.width;
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
    NSInteger originIndex = _currentPage;
    _currentPage = index;
    [self loadViewsData];
    if (index > originIndex) {
        // 下一页
        [_scrollView setContentOffset:CGPointZero];
        [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * 2, 0,
                                                    _scrollView.frame.size.width,
                                                    _scrollView.frame.size.height)
                                animated:YES];
    } else {
        // 上一页
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 2, 0)];
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
}

- (ScrollDirection)scrollDirection
{
    if (_scrollView.contentOffset.x > _lastOffset) {
        return ScrollDirectionLeft;
    }
    else if (_scrollView.contentOffset.x < _lastOffset) {
        return ScrollDirectionRight;
    }
    return ScrollDirectionNone;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastOffset = scrollView.contentOffset.x;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.scrollingPercent) {
        self.scrollingPercent([self scrollDirection],
                              ((NSInteger)offsetX % 320) / (CGFloat)_scrollView.frame.size.width,
                              _currentPage);
    }
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
