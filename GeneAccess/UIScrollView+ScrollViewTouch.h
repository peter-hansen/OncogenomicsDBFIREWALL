//
//  UIScrollView+ScrollViewTouch.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/7/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ScrollViewTouch)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end
