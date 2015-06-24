//
//  ColorPickerView.m
//  wave
//
//  Created by Simen Lie on 06.06.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ColorPickerView.h"
#import "UIHelper.h"
#import "CaptionTextField.h"
@implementation ColorPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCaptionField:(CaptionTextField *)field{
    self = [super initWithFrame:CGRectMake([UIHelper getScreenWidth]-60, 64, 50, 300)];
    self.captionField = field;
    self.colorPicker = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 30, 200)];
    self.colorPicker.image = [UIImage imageNamed:@"color-picker-icon.png"];
    
    self.colorPicker.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.colorPicker addGestureRecognizer:gesture];
    
    self.colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.colorPickerButton.frame = CGRectMake(10, 10, 30, 30);

    [self.colorPickerButton setImage:[UIHelper iconImage:[UIImage imageNamed:@"pencil-icon.png"] withSize:150] forState:UIControlStateNormal];
    [self.colorPickerButton addTarget:self action:@selector(tapColorPickerButton) forControlEvents:UIControlEventTouchUpInside];
    self.colorPicker.layer.cornerRadius = 5;
    self.colorPicker.clipsToBounds = YES;
    [self addSubview:self.colorPickerButton];
    [self addSubview:self.colorPicker];
    
    
    return self;
}

-(void)tapColorPickerButton{

}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    [self GetCurrentPixelColorAtPoint:[gesture locationInView:self.colorPicker]];
}

-(UIColor *) GetCurrentPixelColorAtPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.colorPicker.layer renderInContext:context];
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    if (pixel[3] == 255) {
        [self.captionField setCurrentColor:color];
        if(self.captionField.hasBox){
            self.captionField.backgroundColor = color;
        }else{
            self.captionField.textColor = color;
        }
        
        self.currentColor = color;
        self.colorPickerButton.backgroundColor = color;
    }
    return color;
}

@end
