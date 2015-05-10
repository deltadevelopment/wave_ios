//
//  DropView.m
//  wave
//
//  Created by Simen Lie on 10.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "DropView.h"
#import "UIHelper.h"
@implementation DropView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    //Drop topBar
    self.topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], 50)];
    
    //Drop profilePicture
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    
    self.profilePicture.image = [UIImage imageNamed:@"miranda-kerr.jpg"];
    self.profilePicture.layer.cornerRadius = 15;
    self.profilePicture.clipsToBounds = YES;
    
    //Drop Name Label
    self.dropTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, -2, [UIHelper getScreenWidth] - 52, 50)];
    //nameLabel.text = [drop username];
    [UIHelper applyThinLayoutOnLabel:self.dropTitle withSize:18 withColor:[UIColor whiteColor]];
    [self.dropTitle setMinimumScaleFactor:12.0/17.0];
    self.dropTitle.adjustsFontSizeToFitWidth = YES;
    
    //Shadow View
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 32, [UIHelper getScreenWidth], [UIHelper getScreenHeight]/4)];
    [UIHelper addShadowToView:shadowView];
    
    //Attach elements
    [self.topBar addSubview:self.dropTitle];
    [self.topBar addSubview:self.profilePicture];
    
    [self addSubview:shadowView];
    [self addSubview:self.topBar];
    
    return self;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
