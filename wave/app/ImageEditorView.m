//
//  ImageEditorView.m
//  wave
//
//  Created by Simen Lie on 26.05.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ImageEditorView.h"
@implementation ImageEditorView
{
   
}

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    self.captionLabel = [[CaptionTextField alloc] init];
    [self addSubview:self.captionLabel];
    return self;
}

@end
