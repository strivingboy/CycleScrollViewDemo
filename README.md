# CycleScrollViewDemo + RollScrollView
ios 循环滚动 demo

实现方式： 始终保持三个view, 每次切换始终显示中间那个view

	// 滚动到第几页的block  
	@property (nonatomic, copy) void(^scrolledToPageAtIndex)(NSInteger index);

	// 获取第几页数据的block
	@property (nonatomic, copy) void(^pageViewDataAtIndex)(UIView *view, NSInteger index);
	
	// 当前滚动进度	
	@property (nonatomic, copy) void(^scrollingPercent)(ScrollDirection direction, CGFloat percent, NSInteger index);
	
	-(instancetype)initWithFrame:(CGRect)frame pageViewNumber:(NSInteger)number PageViewClass:(Class)cls;

	// 手动切换到第几页
	-(void)switchPageToIndex:(NSInteger)index;
	
	// 当前显示第几页
	-(NSInteger)currentPageIndex;

添加顶部滚动视图，效果如下

<div align=center>
<img src="scroll.gif" width="320" height="568" alt="demo gif"/>
</div>
