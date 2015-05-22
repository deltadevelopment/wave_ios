//
//  EditImageViewController.m
//  wave
//
//  Created by Simen Lie on 03.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "EditImageViewController.h"
#import "UIHelper.h"
@interface EditImageViewController ()

@end

@implementation EditImageViewController{
    UITextField *textField;
    float lastRotation;
    float lastScale;
    CGFloat pointSize;
    CGFloat temp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorPicker.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.colorPicker addGestureRecognizer:gesture];
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    // And add it to your text view.
   // [self.textField addGestureRecognizer:pinchGestureRecognizer];
    // Do any additional setup after loading the view.
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 400, [UIHelper getScreenWidth], 40)];
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [textField addGestureRecognizer:pinchGestureRecognizer];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
   [rotationRecognizer setDelegate:self];
   // [textField addGestureRecognizer:rotationRecognizer];
    textField.text = @"Simen";
    textField.adjustsFontSizeToFitWidth = YES;

    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touched = [[event allTouches] anyObject];
    //CGPoint location = [touched locationInView:touched.view];
    //NSLog(@"x=%.2f y=%.2f", location.x, location.y);
    //[self isWallPixel:self.colorPicker.image xCoordinate:location.x yCoordinate:location.y];
    //[self GetCurrentPixelColorAtPoint:CGPointMake(location.x, location.y)];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    [self GetCurrentPixelColorAtPoint:[gesture locationInView:self.colorPicker]];
}

- (BOOL)isWallPixel:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    //UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
   // UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    
   // UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info

    if (alpha) return YES;
    else return NO;
    
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
        self.colorTracker.backgroundColor = color;
    return color;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
    /*
    NSLog(@"*** Pinch: Scale: %f Velocity: %f", gestureRecognizer.scale, gestureRecognizer.velocity);
    NSLog(@"OINCHING");
    UIFont *font = textField.font;
    CGFloat pointSize = font.pointSize;
    NSString *fontName = font.fontName;
    
   // pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;

   // pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;
    if(gestureRecognizer.velocity > 0){
        //ZOOM
        pointSize = (1) * 1 + pointSize;
        pointSize +=gestureRecognizer.scale;
       // pointSize += scale;
           // textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width + scale, textField.frame.size.height + scale);
    }else{
         // pointSize -= scale;
            //textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width - scale, textField.frame.size.height - scale);
        pointSize = (-1) * 1 + pointSize;
       pointSize -=gestureRecognizer.scale;
        
    }
    NSLog(@"POINTSIZE: %f :::: %f", pointSize, pointSize * gestureRecognizer.scale);
    
    
    textField.font = [UIFont fontWithName:fontName size:pointSize];

    */
    UIFont *font = textField.font;
    NSString *fontName = font.fontName;
    
    if([(UIPinchGestureRecognizer*)gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        
        pointSize = font.pointSize;
        
    }
    //pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;

    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)gestureRecognizer scale]);

    if(gestureRecognizer.velocity > 0){
          pointSize = 1.0 - (pointSize - [(UIPinchGestureRecognizer*)gestureRecognizer scale]);
    }else{
          pointSize = 1.0 - (pointSize + [(UIPinchGestureRecognizer*)gestureRecognizer scale]);
    }
    
    CGFloat pinchScale = gestureRecognizer.scale;
    pinchScale = round(pinchScale * 1000) / 1000.0;
    
    if (pinchScale < 1) {
          textField.font = [UIFont fontWithName:fontName size:(textField.font.pointSize - pinchScale)];
    }
    else{
        textField.font = [UIFont fontWithName:fontName size:(textField.font.pointSize + pinchScale)];
        
    }
    
    CGAffineTransform currentTransform = textField.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [textField setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)gestureRecognizer scale];
    //pointSize = [(UIPinchGestureRecognizer*)gestureRecognizer scale];
    
    // Save the new font size in the user defaults.
    // (UserDefaults is my own wrapper around NSUserDefaults.)
    //  [[NSUserDefaults sharedUserDefaults] setFontSize:pointSize];
    // Userde

    // [self showOverlayWithFrame:photoImage.frame];
    

    
}

- (void)textViewDidChange:(UITextField *)textView{
    
    CGSize textSize = textView.frame.size;
    
    textView.frame = CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMinY(textView.frame), textSize.width, textSize.height); //update the size of the textView
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = textField.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [textField setTransform:newTransform];
    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //[self showOverlayWithFrame:photoImage.frame];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
