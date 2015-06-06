//
//  BucketView.m
//  wave
//
//  Created by Simen Lie on 31.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "BucketView.h"
#import "UIHelper.h"
@implementation BucketView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.uiPageIndicator = [[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] - 70, 8, 60, 30)];
    self.uiPageIndicator.textAlignment = NSTextAlignmentRight;
    self.uiPageIndicator.text = @"-/-";
    [UIHelper applyThinLayoutOnLabel:self.uiPageIndicator withSize:15.0];
    [self addSubview:self.uiPageIndicator];
    return self;
}

-(void)setPageIndicatorText:(NSString *) page{
    self.uiPageIndicator.text = page;
}

@end
