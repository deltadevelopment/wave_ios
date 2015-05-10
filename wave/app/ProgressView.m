//
//  ProgressView.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ProgressView.h"
#import "UIHelper.h"
@implementation ProgressView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
   self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
    self.alpha = 0.7;
    self.clipsToBounds = YES;
    
    self.progressText = [[UILabel alloc] init];
    self.progressText.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 20);
    self.progressText.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
   self.progressText.text = @"Writing to disk...";
    self.progressText.textAlignment = NSTextAlignmentCenter;
    [UIHelper applyThinLayoutOnLabel:self.progressText];
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.center = CGPointMake(40, self.frame.size.height / 2);

    self.spinner.hidesWhenStopped = YES;
    self.spinner.hidden = NO;
   
    [self addSubview:self.spinner];
    [self addSubview:self.progressText];
     [self.spinner startAnimating];
    [self bringSubviewToFront:self.spinner];
    
   self.hidden = YES;
    return self;
}


-(void)setProgressString:(NSString *) text{
    self.progressText.text = text;
}

-(void)startProgress{
    self.hidden = NO;
    self.alpha = 0.7;
    [self.spinner startAnimating];
}
-(void)stopProgress{
    [self.spinner stopAnimating];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
