//
//  UIScrollView+ScrollViewTouch.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/7/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "UIScrollView+ScrollViewTouch.h"

@implementation UIScrollView (ScrollViewTouch)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // If not dragging, send event to next responder
    if (!self.dragging){
        [self.nextResponder touchesBegan: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent: event];
    }
}
@end
