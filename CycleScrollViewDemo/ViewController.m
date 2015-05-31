//
//  ViewController.m
//  CycleScrollViewDemo
//
//  Created by strivingboy on 15/5/11.
//
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "InfoView.h"

@interface ViewController ()
@property (nonatomic) CycleScrollView *scrollView;
@property (nonatomic) NSArray *dataModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCycleScrollView];
}

- (void)addCycleScrollView
{
    _dataModel = @[@"first page", @"second page", @"third page", @"fourth page", @"fifth page"];
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                                   self.view.frame.size.width,
                                                                                   self.view.frame.size.height)
                                                         pageViewNumber:_dataModel.count
                                                          PageViewClass:[InfoView class]];
    _scrollView = scrollView;
    __weak typeof (self) weakSelf = self;
    _scrollView.scrolledToPageAtIndex = ^(NSInteger index) {
        [weakSelf switchToIndex:index];
    };
    _scrollView.pageViewDataAtIndex = ^(UIView *view, NSInteger index){
        [weakSelf getPageViewData:view atIndex:index];
    };
    [self.view addSubview:scrollView];
    [_scrollView switchPageToIndex:0];
}

- (void)switchToIndex:(NSInteger)index
{
    NSLog(@"CurrentPage index: %ld", (long)index);
}

- (void)getPageViewData:(UIView *)view atIndex:(NSInteger)index
{
    NSString *title = [_dataModel objectAtIndex:index];
    InfoView *infoView = (InfoView *)view;
    infoView.label.text = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
