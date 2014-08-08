//
//  DatabaseViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
@interface DatabaseViewController : UIViewController<NSURLConnectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>
{
    NSMutableData *_responseData;
}
// button that searches based primarily on text in the full-text area
@property (strong, nonatomic) IBOutlet UIButton *submitTextQuery;
// full-text area
@property (strong, nonatomic) IBOutlet UITextView *textArea;
// textfield that holds information on the database selected
@property (strong, nonatomic) IBOutlet UITextField *databaseSelect;
// logout button
@property (strong, nonatomic) IBOutlet UIButton *logout;
// textfield that holds information on where to search
@property (strong, nonatomic) IBOutlet UITextField *valueSelect;
// textfield that hold information on the chromosome to be searched
@property (strong, nonatomic) IBOutlet UITextField *chromSelect;
// holds information about limit to results per page
@property (strong, nonatomic) IBOutlet UITextField *limitSelect;
// holds information about the value for the heatmaps
@property (strong, nonatomic) IBOutlet UITextField *heatmapValueSelect;
// holds information on what things are ordered by
@property (strong, nonatomic) IBOutlet UITextField *orderBySelect;
// all of these are just the pickerview for each _____Select
@property(strong, nonatomic) UIPickerView *databasePicker;
@property(strong, nonatomic) UIPickerView *valuePicker;
@property(strong, nonatomic) UIPickerView *chromPicker;
@property(strong, nonatomic) UIPickerView *limitPicker;
@property(strong, nonatomic) UIPickerView *heatmapValuePicker;
@property(strong, nonatomic) UIPickerView *orderByPicker;
// arrays that hold the options that will go in the picker views
@property(strong, nonatomic) NSArray *values;
@property(strong, nonatomic) NSArray *chroms;
@property(strong, nonatomic) NSArray *limits;
@property(strong, nonatomic) NSMutableArray *heatmapValues;
@property(strong, nonatomic) NSMutableArray *orderBy;
@property(strong, nonatomic) NSString *response;
// html response. It's called database because it's used
// to determine which databases to provide access to.
@property(strong, nonatomic) NSMutableString *databaseHtml;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@end
