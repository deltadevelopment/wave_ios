//
//  Carousel.h
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Carousel : NSObject
-(id)initWithPages:(int) count;
-(UIView *)getNavBar;
-(void)updateCarousel:(int) pageCount withCurrentPage:(NSInteger) currentPage;
-(void)addNavigationTitle:(NSString *) title withPageCount:(int)pageCount;
-(void)animateTitles:(float)scrollOffset;
-(void)forward:(NSInteger) index;
-(void)backward:(NSInteger) index;
@end
