//
//  InfoView.m
//  CycleScrollViewDemo
//
//  Created by strivingboy on 15/5/11.
//
//

#import "InfoView.h"

@implementation InfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:frame];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:18.f];
        [self addSubview:_label];
    }
    return self;
}
@end
