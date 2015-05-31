# CycleScrollViewDemo
ios 循环滚动 demo

实现方式： 始终保持三个view, 每次切换始终显示中间那个view

	// 滚动到第几页的block  
	@property (nonatomic, copy) void(^scrolledToPageAtIndex)(NSInteger index);

	// 获取第几页数据的block
	@property (nonatomic, copy) void(^pageViewDataAtIndex)(UIView *view, NSInteger index);

	-(instancetype)initWithFrame:(CGRect)frame pageViewNumber:(NSInteger)number PageViewClass:(Class)cls;

	// 手动切换到第几页
	-(void)switchPageToIndex:(NSInteger)index;
	
	// 当前显示第几页
	-(NSInteger)currentPageIndex;
