//
//  RipplesTableViewCell.m
//  wave
//
//  Created by Simen Lie on 16/06/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "RipplesTableViewCell.h"
#import "UIHelper.h"
#import "ColorHelper.h"
#import "RippleModel.h"
@implementation RipplesTableViewCell{
    NSMutableAttributedString *displayContent;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initalize{
    
    
    self.profilePictureImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height /2) -15, 30, 30)];
    self.profilePictureImage.layer.cornerRadius = 15;
    self.profilePictureImage.clipsToBounds = YES;
    
    
    self.userButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.userButton.frame = CGRectMake(45, 10, 100, 30);
    [self.userButton setTitle:@"simenle" forState:UIControlStateNormal];
   
    
    float widthIs =
    [self.userButton.titleLabel.text
     boundingRectWithSize:self.userButton.titleLabel.frame.size
     options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{ NSFontAttributeName:self.userButton.titleLabel.font }
     context:nil]
    .size.width;
    self.userButton.frame =CGRectMake(self.userButton.frame.origin.x, self.userButton.frame.origin.y, widthIs + 10, self.userButton.frame.size.height);

    
    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthIs + 55),10 , (self.frame.size.width) - 180, 30)];
    self.notificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.notificationLabel.numberOfLines = 0;
   // self.notificationLabel.backgroundColor = [UIColor redColor];

    self.actionButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.frame = CGRectMake((self.frame.size.width) -50, (self.frame.size.height /2) -20, 40, 40);
    
    self.subscribeButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.subscribeButton.frame = CGRectMake((self.frame.size.width) -50, (self.frame.size.height /2) -12.5, 40, 25);
    
    [self.subscribeButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [[self.subscribeButton layer] setBorderWidth:1.0f];
    
    [[self.subscribeButton layer] setBorderColor:[ColorHelper purpleColor].CGColor];
    self.subscribeButton.layer.cornerRadius = 2;
    self.subscribeButton.imageView.frame = CGRectMake(0, 0, 40, 40);
    [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
   // [[self.subscribeButton imageView] setTintColor:[ColorHelper purpleColor]];
    
    [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
    //[self.subscribeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    //[self.subscribeButton sizeToFit];
    
    //top left bottom right
    self.actionButton.clipsToBounds = YES;
    [self.actionButton addTarget:self action:@selector(dropAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.temperatureButton =[UIButton buttonWithType:UIButtonTypeSystem];
    self.temperatureButton.frame = CGRectMake((self.frame.size.width) -50, (self.frame.size.height /2) -20, 40, 40);
     [self.temperatureButton setTintColor:[ColorHelper purpleColor]];
    //self.actionButton.backgroundColor =[UIColor redColor];
    [self.userButton setTitle:@"simenle" forState:UIControlStateNormal];
    
    
    self.isInitialized = YES;
    [UIHelper applyThinLayoutOnLabel:self.notificationLabel withSize:15.0f];
    [self.notificationLabel setTextColor:[UIColor blackColor]];
    [UIHelper applyThinLayoutOnLabel:self.NotificationTimeLabel withSize:15.0f];
    [self.NotificationTimeLabel setTextColor:[UIColor blackColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
    self.NotificationTimeLabel.hidden = YES;
    // self.layer.shouldRasterize = YES;
    //self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    /*
    self.transform = CGAffineTransformMakeRotation(M_PI);
    self.messageImage.layer.cornerRadius = 15;
    self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.messageImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.message.layer.cornerRadius = 2;
    self.message.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    self.message.clipsToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
     */
    [self addSubview:self.actionButton];
    [self addSubview:self.profilePictureImage];
    //[self addSubview:self.userButton];
    [self addSubview:self.notificationLabel];
    [self addSubview:self.subscribeButton];
    [self addSubview:self.temperatureButton];
    
    float xPos = self.profilePictureImage.frame.origin.x + self.profilePictureImage.frame.size.width;
    float yWidth = [UIHelper getScreenWidth] - xPos - 70;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(xPos + 10, 10, yWidth, self.frame.size.height - 20)];
    self.textView.delegate = self;
    [self.textView setSelectable:NO];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    self.textView.textAlignment = NSTextAlignmentCenter;
    
    //textView.text = @"Dette er en tekst, Dette skal vare en LINK";
    [self addSubview:self.textView];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.actionButton.hidden = YES;
    self.subscribeButton.hidden = YES;
    self.temperatureButton.hidden = YES;
    
}

-(void)updateUiWithHeight:(float) height{
    [self updateUiWithHeight:height withButton:self.temperatureButton];
    [self updateUiWithHeight:height withButton:self.actionButton];
    [self updateUiWithHeight:height withButton:self.subscribeButton];
    CGRect frame = self.profilePictureImage.frame;
    frame.origin.y = (height /2) -15;
     self.profilePictureImage.frame = frame;
}

-(void)updateUiWithHeight:(float)height withButton:(UIButton*) button{
    CGRect frame2 = button.frame;
    frame2.origin.y = (height /2) -(frame2.size.height/2);
    button.frame = frame2;
}
-(CGRect)makeTextClickableAndLayout:(NSString *) username withRestOfText:(NSString *) restofText withRippleId:(int)rippleId{

    displayContent = [[NSMutableAttributedString alloc] init];
    NSString *tag = [NSString stringWithFormat:@"myCustomTag%d", rippleId];
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:username attributes:@{ tag : @(YES) }];
    [displayContent appendAttributedString:attributedString];
    [displayContent appendAttributedString:[[NSAttributedString alloc] initWithString:restofText attributes:@{ @"myCustomTag1" : @(YES) }]];
    
    
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [self.textView addGestureRecognizer:rec];
    
    
    [displayContent addAttribute:NSForegroundColorAttributeName value:[ColorHelper purpleColor] range:NSMakeRange(0,attributedString.length)];
    
    
    UIFont *font_regular=[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    UIFont *font_bold=[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
    
    // [displayContent addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(0, 4)];
    
    [displayContent addAttribute:NSFontAttributeName value:font_bold range:NSMakeRange(0, attributedString.length)];
    
    [displayContent addAttribute:NSFontAttributeName value:font_regular range:NSMakeRange(attributedString.length, displayContent.length - attributedString.length)];
    
    [self.textView setAttributedText:displayContent];
    
    CGFloat fixedWidth = self.textView.frame.size.width;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.textView.frame = newFrame;
    self.textView.scrollEnabled = NO;
    return newFrame;
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    NSLog(@"the location is %f %f", location.x, location.y);
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    
    
    if (characterIndex < textView.textStorage.length) {
        if(location.y > 0 && location.x > 0){
            NSRange range;
            
            NSString *tag = [NSString stringWithFormat:@"myCustomTag%d", self.ripple.Id];
            id value = [textView.attributedText attribute:tag atIndex:characterIndex effectiveRange:&range];
            if(value){
                //Navigate to the user
                NSLog(@"%@, %lu, %lu", value, (unsigned long)range.location, (unsigned long)range.length);
                self.onUserTap(self.ripple);
            }else{
                if ([[self.ripple trigger_type] isEqualToString:@"Bucket"]) {
                    self.onBucketTap(self.ripple, self);
                }else{
                    self.onDropTap(self.ripple, self);
                }
                //If the user did not click any links in the text, navigate to ripple action
                
            }
        }
        
       

    }
}


-(void)initActionButton:(RippleModel *) ripple withCellHeight:(float) height{
    self.ripple = ripple;
    if([[ripple trigger_type]  isEqualToString:@"Drop"]){
        [self showButton:self.actionButton];
        [self.actionButton removeTarget:self action:@selector(dropAction) forControlEvents:UIControlEventTouchUpInside];
        [self.actionButton addTarget:self action:@selector(dropAction) forControlEvents:UIControlEventTouchUpInside];
        [self.actionButton setBackgroundImage:[UIHelper iconImage:[UIImage imageNamed:@"manatee-gray.png"] withSize:80.0f] forState:UIControlStateNormal];
        if([ripple.drop media_type] == 0){
            [ripple.drop requestPhoto:^(NSData *data){
                [self.actionButton setBackgroundImage:[UIHelper iconImage:[UIImage imageWithData:data]  withSize:80.0f]forState:UIControlStateNormal];
                
            } ];
        }else{
            [ripple.drop requestThumbnail:^(NSData *data){
                [self.actionButton setBackgroundImage:[UIHelper iconImage:[UIImage imageWithData:data]  withSize:80.0f]forState:UIControlStateNormal];
                
            }];
        }
        
        
    }
    else if([[ripple trigger_type]   isEqualToString:@"Bucket"]){
        [self showButton:self.actionButton];
         [self.actionButton removeTarget:self action:@selector(bucketAction) forControlEvents:UIControlEventTouchUpInside];
         [self.actionButton addTarget:self action:@selector(bucketAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setBackgroundImage:[UIHelper iconImage:[UIImage imageNamed:@"manatee-gray.png"] withSize:80.0f] forState:UIControlStateNormal];
        DropModel *drop = [[ripple.bucket drops] objectAtIndex:0];
        if([drop media_type] == 0){
            [drop requestPhoto:^(NSData *data){
                [self.actionButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            } ];
        }else{
            [drop requestThumbnail:^(NSData *data){
                [self.actionButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            }];
        }
    }
    else if([[ripple trigger_type] isEqualToString:@"Subscription"]){
        if ([ripple subscription] != nil) {
            if([ripple.subscription reverse]){
                [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
                [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
                [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
            }
            else{
                [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"] withSize:40] forState:UIControlStateNormal];
                [self.subscribeButton setBackgroundColor:[ColorHelper whiteColor]];
                  [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
                [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
            }
        }
      
        
        [self showButton:self.subscribeButton];
    }
    else if([[ripple trigger_type] isEqualToString:@"Vote"]){
        [self showButton:self.temperatureButton];
        [self.temperatureButton setTitle:[NSString stringWithFormat:@"%d °", [ripple.temperature temperature]] forState:UIControlStateNormal];
    }
    else if([[ripple trigger_type] isEqualToString:@"Tag"]){
         [self.actionButton removeTarget:self action:@selector(tagAction) forControlEvents:UIControlEventTouchUpInside];
         [self.actionButton addTarget:self action:@selector(tagAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)showButton:(UIButton *) button{
    self.actionButton.hidden = YES;
    self.subscribeButton.hidden = YES;
    self.temperatureButton.hidden = YES;
    button.hidden = NO;
}

-(void)subscribeAction{
    //Subscribe to user here
 
    
  NSLog(@"button pressed subscribe");
    if([self.ripple.subscription reverse]){
        [self.ripple.subscription delete:^(ResponseModel *response){
            [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"plus-icon-simple.png"] withSize:40] forState:UIControlStateNormal];
            [self.subscribeButton setBackgroundColor:[ColorHelper whiteColor]];
            [self.subscribeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 12.5, 5, 12.5)];
            [self.subscribeButton setTintColor:[ColorHelper purpleColor]];
        } onError:^(NSError *error){}];
        [self.ripple.subscription setReverse:NO];
    
        
        
    }
    else{
        
         [self.ripple.subscription setReverse:YES];
        [self.ripple.subscription saveChanges:^(ResponseModel *response){
           
            [self.subscribeButton setImage: [UIHelper iconImage:[UIImage imageNamed:@"tick.png"] withSize:40] forState:UIControlStateNormal];
            [self.subscribeButton setBackgroundColor:[ColorHelper purpleColor]];
            [self.subscribeButton setTintColor:[ColorHelper whiteColor]];
        } onError:^(NSError *error)
         {
             
             
         }];
     
    }
    
    
   
    
}

-(void)dropAction{
    //Show the bucket, then the drop
    NSLog(@"button pressed drop");
    self.onDropTap(self.ripple, self);
}

-(void)bucketAction{
    //Show the bucket normally
    NSLog(@"button pressed bucket");
     self.onBucketTap(self.ripple, self);
}

-(void)temperaturAction{
    //show the bucket, then the drop
    NSLog(@"button pressed tenperature");
     self.onDropTap(self.ripple, self);
}

-(void)tagAction{
     //show the bucket, then the drop
    NSLog(@"button pressed tag not implemented");
     self.onDropTap(self.ripple, self);
}


-(float)getHeightForLabel{
 
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:15]};
    CGRect rect = [self.notificationLabel.text boundingRectWithSize:CGSizeMake((self.frame.size.width) - 200, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                     context:nil];
    return rect.size.height;
}

-(void)calculateHeight{
    NSLog(@"HEIGHT IS %f", [self getHeightForLabel]);
    CGRect rect = self.notificationLabel.frame;
    rect.size.height =[self getHeightForLabel];
    self.notificationLabel.frame = rect;
}

- (IBAction)actionButtonAction:(id)sender {
}
@end