//
//  VoteInfoView.m
//  wave
//
//  Created by Simen Lie on 13.07.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "VoteInfoView.h"
#import "UIHelper.h"

@implementation VoteInfoView
{
    UIVisualEffectView *blurEffectView;
    UIView *funnyView;
    UIView *coolView;
    int startingPosition;
    float funnyValue;
    float coolValue;
    CGPoint coolPos;
    CGPoint funnyPos;
    UIBlurEffect *blurEffect;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(id)initWithDrop:(DropModel *) drop{
    self.drop = drop;
    self = [super init];
    self.frame = CGRectMake(0, 0, [UIHelper getScreenWidth], [UIHelper getScreenHeight]);
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitButton.frame = CGRectMake(10, 10, 35, 35);
    //[self.voteButton setBackgroundColor:[UIColor redColor]];
    [self.exitButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.exitButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"cross.png"] withSize:40] forState:UIControlStateNormal];
    self.exitButton.userInteractionEnabled = YES;
    [self.exitButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self setAlpha:0.0f];
    //self.exitButton.alpha = 0.5;
    [self addBlur];
    
    NSLog(@"the vote for drop %d is %d %d", self.drop.Id, self.drop.total_votes_count, self.drop.most_votes);

    [self addSubview:self.exitButton];
    [self setHidden:YES];
    [self updateInfo];
    return self;
}

-(void)updateInfo{
    __weak typeof(self) weakSelf = self;
    [self.drop fetchVotes:^{
        NSLog(@"the count of funny votes %lu", (unsigned long)[[self.drop funnyVotes] count]);
        NSLog(@"the count of cool votes %lu", (unsigned long)[[self.drop coolVotes] count]);
        [weakSelf createVoteCircles];
    } onError:^(NSError *error){
        
    }];
}

-(void)createVoteCircles{
    int maxSize = 150;
    int minSize = 50;
    if ([self.drop.funnyVotes count] != 0 && [self.drop.coolVotes count] != 0) {
        //Both has votes, create tow circles
        
        int totalfunnyVotes = (float) [self.drop.funnyVotes count];
        int totalCoolVotes = (float) [self.drop.coolVotes count];
        
        //float totalfunnyVotes = 256;
        //float totalCoolVotes = 2560;
        
        if (totalCoolVotes > totalfunnyVotes) {
            float result = (totalfunnyVotes/totalCoolVotes)*100;
            float maxForThis = (maxSize * result)/100;
            NSLog(@"The difference is %f and the size is %f", result, maxForThis);
            maxForThis /= 2;
            [self calculateSize:maxForThis + minSize
                  withCoolValue:(maxSize - maxForThis)+minSize];
        }
        else if (totalCoolVotes < totalfunnyVotes){
            float result = (totalCoolVotes/totalfunnyVotes)*100;
            float maxForThis = (maxSize * result)/100;
            NSLog(@"The difference is %f and the size is %f", result, maxForThis);
            maxForThis /= 2;
            [self calculateSize:(maxSize - maxForThis)+minSize
                  withCoolValue:maxForThis + minSize];
        }
        else{
            [self calculateSize:(maxSize + minSize)/2
                  withCoolValue:(maxSize + minSize)/2];
        }
    }
    else if ([self.drop.funnyVotes count] != 0) {
        //Just funny votes
        [self calculateSize:maxSize
              withCoolValue:0];
        
    }
    else if ([self.drop.coolVotes count] != 0) {
        //Just cool votes
        [self calculateSize:0
              withCoolValue:maxSize];
    }
    else{
        //There are no votes
        [self doe];
    }

}

-(void)doe{
    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.bounds];
    
    // Label for vibrant text
    UILabel *vibrantLabel = [[UILabel alloc] init];
    [vibrantLabel setText:NSLocalizedString(@"no_votes_yet", nil)];
   // [vibrantLabel setMinimumScaleFactor:12.0/17.0];
    [vibrantLabel setFont:[UIFont systemFontOfSize:22.0f]];
    [vibrantLabel sizeToFit];
    //[vibrantLabel setCenter: self.center];
    [vibrantLabel setCenter:CGPointMake(self.center.x, self.center.y -32)];
    
    // Add label to the vibrancy view
    [[vibrancyEffectView contentView] addSubview:vibrantLabel];
    
    // Add the vibrancy view to the blur view
    [[blurEffectView contentView] addSubview:vibrancyEffectView];
}

-(void)calculateSize:(float) funnyValueLocal withCoolValue:(float) coolValueLocal{
    funnyValue = funnyValueLocal;
    coolValue = coolValueLocal;
    NSLog(@"The funny is %f and the cool is %f", funnyValue, coolValue);
    NSLog(@"the middle %f", [UIHelper getScreenWidth] - (funnyValue + coolValue + 20));
    float calc = [UIHelper getScreenWidth] - (funnyValue + coolValue + 20);
    float padding = calc/2;
    if (funnyValue > coolValue) {
        coolPos = CGPointMake(padding, (100 + funnyValue)-coolValue);
        funnyPos = CGPointMake(padding + coolValue + 20, 100);
    }
    else if(coolValue > funnyValue){
        coolPos = CGPointMake(padding, 100);
        funnyPos = CGPointMake(padding + coolValue + 20, (100 + coolValue)-funnyValue);
    }
    
    else{
        coolPos = CGPointMake(padding, 100);
        funnyPos = CGPointMake(padding + coolValue + 20, 100);
    }
    if (coolValue != 0) {
        [self createCoolCircleWithRadius:coolValue];
    }
    if(funnyValue != 0){
        [self createFunnyCircleWithRadius:funnyValue];
    }
    
    
}

-(void)createCoolCircleWithRadius:(float) radius{
    
    coolView = [[UIView alloc] initWithFrame:CGRectMake(coolPos.x, coolPos.y, radius, radius)];
    
    //[coolView setImage:[UIImage imageNamed:@"eye.png"]];
    coolView.layer.cornerRadius = radius/2;
    coolView.clipsToBounds = YES;
    //[coolView setBackgroundColor:[UIColor whiteColor]];
    coolView.layer.borderWidth = 1;
    coolView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    [self addSubview:coolView];
    
    
    float imageSize = radius/2;
    NSLog(@"the sise is %f", radius - (imageSize/2));
    UILabel *emojiView = [[UILabel alloc] initWithFrame:CGRectMake(imageSize/2,imageSize/2,imageSize,imageSize)];
    [emojiView setTextAlignment:NSTextAlignmentCenter];
    [emojiView setText:@"\xF0\x9F\x91\x8D"];
    [emojiView setFont:[UIFont fontWithName:@"HelveticaNeue" size:50]];
    //[emojiView sizeToFit];
   // [emojiView setBackgroundColor:[UIColor redColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageSize/2,imageSize/2,imageSize,imageSize)];
    [imageView setImage:[UIImage imageNamed:@"eye.png"]];
    [coolView addSubview:emojiView];
    
    for (int i = 0; i<10; i++) {
        [self addSmallCircles:CGPointMake(coolView.frame.origin.x + (coolView.frame.size.width/2) - 3, (coolView.frame.origin.y + coolView.frame.size.height + 6) + (12*i))];
    }
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(coolView.frame.origin.x,
                                                                    coolView.frame.origin.y + coolView.frame.size.height + 6 + (120),
                                                                    radius, 30)];
    //[countLabel setBackgroundColor:[UIColor redColor]];
    [countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.drop.coolVotes count]]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [UIHelper applyThinLayoutOnLabel:countLabel withSize:20.0f];
    [self addSubview:countLabel];
    
}


-(void)createFunnyCircleWithRadius:(float) radius{
    
    funnyView = [[UIView alloc] initWithFrame:CGRectMake(funnyPos.x, funnyPos.y, radius, radius)];
    
    //[funnyView setImage:[UIImage imageNamed:@"profile-icon.png"]];
    funnyView.layer.cornerRadius = radius/2;
    funnyView.clipsToBounds = YES;
    // [funnyView setBackgroundColor:[UIColor whiteColor]];
    funnyView.layer.borderWidth = 1;
    funnyView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    [self addSubview:funnyView];
    
   
    float imageSize = radius/2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageSize/2,imageSize/2,imageSize,imageSize)];
    [imageView setImage:[UIImage imageNamed:@"profile-icon.png"]];
   // [funnyView addSubview:imageView];
    UILabel *emojiView = [[UILabel alloc] initWithFrame:CGRectMake(imageSize/2,imageSize/2,imageSize,imageSize)];
    [emojiView setTextAlignment:NSTextAlignmentCenter];
    [emojiView setFont:[UIFont fontWithName:@"HelveticaNeue" size:50]];
    [emojiView setText:@"\xF0\x9F\x98\x82"];
    
    [funnyView addSubview:emojiView];
    
    for (int i = 0; i<10; i++) {
        [self addSmallCircles:CGPointMake(funnyView.frame.origin.x + (funnyView.frame.size.width/2) - 3, (funnyView.frame.origin.y + funnyView.frame.size.height + 6) + (12*i))];
    }
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(funnyView.frame.origin.x,
                                                                    funnyView.frame.origin.y + funnyView.frame.size.height + 6 + 120,
                                                                    radius, 30)];
    //[countLabel setBackgroundColor:[UIColor redColor]];
    [countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.drop.funnyVotes count]]];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [UIHelper applyThinLayoutOnLabel:countLabel withSize:20.0f];
    [self addSubview:countLabel];
}



-(void)addSmallCircles:(CGPoint) point{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x,point.y,6,6)];
    imageView.layer.cornerRadius = 6/2;
    imageView.clipsToBounds = YES;
    // [funnyView setBackgroundColor:[UIColor whiteColor]];
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
    [self addSubview:imageView];
}

-(void)dismissView{
    //[self setHidden:YES];
    [self animateInfoOut];
}

-(void)addBlur{
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    // blurEffectView.alpha = 0.9;
    blurEffectView.alpha = 1.0;
    [self addSubview:blurEffectView];
    //add auto layout constraints so that the blur fills the screen upon rotating device
    [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)animateInfoIn{
    self.hidden = NO;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

-(void)animateInfoOut{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.hidden = YES;
                     }];
}


@end
