//
//  GSEAController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/23/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSEAController : UIViewController <NSURLConnectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *iPadView;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (nonatomic) NSMutableString *html;
@property (nonatomic) NSString *db;
@end
