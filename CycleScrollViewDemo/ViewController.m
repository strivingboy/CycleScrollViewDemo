//
//  ViewController.m
//  CycleScrollViewDemo
//
//  Created by strivingboy on 15/5/11.
//
//

#import "ViewController.h"
#import "RollScrollView.h"
#import "CycleScrollView.h"
#import "InfoView.h"

@interface ViewController ()
@property (nonatomic) RollScrollView *rollScrollView;
@property (nonatomic) CycleScrollView *cycleScrollView;
@property (nonatomic) NSArray *dataModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataModel];
    [self addRollScrollView];
    [self addCycleScrollView];
}

- (void)initDataModel
{
     _dataModel = @[@"first page", @"second page", @"third page"];
}

- (void)addRollScrollView
{
    CGRect frame = CGRectZero;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = 44.f;
    frame.origin.y = 20.f;
    RollScrollView *scrollView = [[RollScrollView alloc] initWithFrame:frame
                                                          topTitles:_dataModel];
    _rollScrollView = scrollView;
    __weak typeof (self) weakSelf = self;
    _rollScrollView.selectedTabIndex = ^(NSInteger index) {
        [weakSelf switchPageViewToIndex:index];
    };
    [self.view addSubview:_rollScrollView];
}

- (void)addCycleScrollView
{
   
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0.f, 64.f,
                                                                                   self.view.frame.size.width,
                                                                                   self.view.frame.size.height)
                                                         pageViewNumber:_dataModel.count
                                                          PageViewClass:[InfoView class]];
    _cycleScrollView = scrollView;
    __weak typeof (self) weakSelf = self;
    _cycleScrollView.scrolledToPageAtIndex = ^(NSInteger index) {
        [weakSelf switchToIndex:index];
    };
    _cycleScrollView.pageViewDataAtIndex = ^(UIView *view, NSInteger index){
        [weakSelf getPageViewData:view atIndex:index];
    };
    _cycleScrollView.scrollingPercent = ^(ScrollDirection direction, CGFloat percent, NSInteger index) {
        [weakSelf updateTabContentOffset:direction withPercent:percent atIndex:index];
    };
    [self.view addSubview:scrollView];
    [_cycleScrollView switchPageToIndex:0];
}

- (void)switchPageViewToIndex:(NSInteger)index
{
    [_cycleScrollView switchPageToIndex:index];
}

- (void)switchToIndex:(NSInteger)index
{
    [_rollScrollView swithTabToIndex:index];
}

- (void)updateTabContentOffset:(ScrollDirection)direction withPercent:(CGFloat)percent atIndex:(NSInteger)index
{
    [_rollScrollView updateTabOffsetWithDirection:direction withPercent:percent atIndex:index];
}

- (void)getPageViewData:(UIView *)view atIndex:(NSInteger)index
{
    NSString *title = [_dataModel objectAtIndex:index];
    InfoView *infoView = (InfoView *)view;
    infoView.label.text = title;
    if (index == 0) {
        infoView.backgroundColor = [UIColor greenColor];
    } else if (index == 1) {
        infoView.backgroundColor = [UIColor redColor];
    } else if (index ==  2) {
        infoView.backgroundColor = [UIColor blueColor];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
