//
//  dbInfoController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/7/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dbInfoController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) NSMutableString *html;
@end
