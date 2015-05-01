//
//  Carousel.m
//  wave
//
//  Created by Simen Lie on 20.04.15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "Carousel.h"
#import "ColorHelper.h"
#import "UIHelper.h"
@implementation Carousel{
    UIView *navBar;
    UIView *pageindicator;
    NSMutableArray *carousel;
    NSMutableArray *carouselTitles;
    int space;
    int pages;
    
}

-(id)initWithPages:(int) count{
    pages = count;
    carousel = [[NSMutableArray alloc]init];
    carouselTitles = [[NSMutableArray alloc]init];
    
    navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    navBar.backgroundColor = [ColorHelper purpleColor];
    navBar.clipsToBounds = YES;
    
    pageindicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 10)];
    [pageindicator setCenter:CGPointMake(navBar.frame.size.width / 2, navBar.frame.size.height - 10)];
    
    [navBar addSubview:pageindicator];
    for(int i = 0; i< count; i++){
        [self createCircle:space];
        space += 9;
    }
    
    return self;
}

-(UIView *)getNavBar{
    return navBar;
}

-(NSMutableArray *)getCarouselO{
    return carousel;
}

-(void)animateTitles:(float)scrollOffset{
    for(int i = 0; i <[carouselTitles count];i++){
        [self slideNavTitle:scrollOffset withTitleLabel:[carouselTitles objectAtIndex:i] withDefaultFloat:[UIHelper getScreenWidth] * i];
    }
}

-(void)slideNavTitle:(float)value withTitleLabel:(UILabel *) label withDefaultFloat:(float)fval
{
    CGRect frame = label.frame;
    frame.origin.x = fval - value;
    label.frame = frame;
}



-(void)updateCarousel:(int) pageCount withCurrentPage:(NSInteger) currentPage{
    for(int index = 0;index < pageCount; index++){
        UILabel *label =[carousel objectAtIndex:index];
        if(currentPage == index){
            label.backgroundColor =[UIColor colorWithRed:0.753 green:0.455 blue:0.808 alpha:1];
        }else{
            label.backgroundColor =[UIColor colorWithRed:0.357 green:0.125 blue:0.459 alpha:1];
        }
        
    }
}

-(void)addNavigationTitle:(NSString *) title withPageCount:(int)pageCount{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake([UIHelper getScreenWidth] * pageCount, 0, 250, 34)];
    [navTitle  setTextAlignment:NSTextAlignmentCenter];
    [UIHelper applyLayoutOnLabel:navTitle];
    navTitle.text = title;
    
    [carouselTitles addObject:navTitle];
    [navBar addSubview:navTitle];
    if([carouselTitles count] == pages){
        [self addFeatheredEdgesToNavBar];
    }
}


-(void)createCircle:(float) xPos{
    UILabel *circle = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, 6, 6)];
    circle.backgroundColor = [UIColor colorWithRed:0.357 green:0.125 blue:0.459 alpha:1];
    circle.layer.cornerRadius = 3;
    circle.clipsToBounds = YES;
    [carousel addObject:circle];
    [pageindicator addSubview:circle];
}

-(void)addFeatheredEdgesToNavBar{
    UIView *leftEdge = [self createEdge:-1 shadowDirection:5.0f];
    UIView *rightEdge = [self createEdge:226 shadowDirection:-5.0f];
    [navBar addSubview:leftEdge];
    [navBar addSubview:rightEdge];
    
}

-(UIView *)createEdge:(float) xPos shadowDirection:(float) direction{
    UIView *edge = [[UIView alloc] initWithFrame:CGRectMake(xPos, 0, 25, 44)];
    edge.backgroundColor = [ColorHelper purpleColor];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:edge.bounds];
    edge.layer.masksToBounds = NO;
    edge.layer.shadowColor = [ColorHelper purpleColor].CGColor;
    edge.layer.shadowOffset = CGSizeMake(direction, 0.0f);
    edge.layer.shadowOpacity = 3.0f;
    edge.layer.shadowPath = shadowPath.CGPath;
    edge.layer.shouldRasterize = YES;
    return edge;
}




@end