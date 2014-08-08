//
//  AdvancedSearchController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/20/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSearchController : UIViewController <NSURLConnectionDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
// All these values are taken from the user defined parameters in DatabaseViewController
@property (strong, nonatomic) NSString *db;
@property (strong, nonatomic) NSString *produceHeatmap;
@property (strong, nonatomic) NSString *annotations;
@property (strong, nonatomic) NSString *limitTo;
@property (strong,nonatomic) NSString *heatmapValue;
@property (strong, nonatomic) NSString *orderBy;
@property (strong, nonatomic) NSString *heatmapThreshold;
@end
