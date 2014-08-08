//
//  AdvancedSearchController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/20/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//  NOTE: IMPORTANT!!! AT THE TIME OF MY DEPARTURE THIS FUNCTION WAS INOPERABLE ON THE
//  SERVER SIDE. UNTIL THAT IS FIXED THIS PAGE IS USELESS, WHEN IT IS FIXED IT SHOULD
//  WORK JUST FINE. IF IT DOESN'T JUST CONTACT ME AT phansen@terpmail.umd.edu

#import "AdvancedSearchController.h"
#import "DataViewController.h"
#import "ViewController.h"
@interface AdvancedSearchController ()
// Unfortunately I couldn't think of a better way to do this, so each row has a variable
// for the tissue select box, tissue select picker, gtlt, gtlt picker, and fold.
// NOTICE! This time I used a different naming scheme for the textfields and their
// pickerviews. This time instead of _____Select and _____Picker, it's just _____
// and _____Picker. For the record, I don't like this way but I decided to try it this time.
@property (strong, nonatomic) IBOutlet UITextField *andor;
@property (strong, nonatomic) UIPickerView *andorPicker;
@property (strong, nonatomic) NSArray *andorArray;
@property (strong, nonatomic) NSArray *gtlts;
@property (strong, nonatomic) NSArray *optionsTissue;
@property (strong, nonatomic) IBOutlet UITextField *tissue0;
@property (strong, nonatomic) UIPickerView *tissue0Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt0;
@property (strong, nonatomic) UIPickerView *gtlt0Picker;
@property (strong, nonatomic) IBOutlet UITextField *fold0;
@property (strong, nonatomic) IBOutlet UITextField *tissue1;
@property (strong, nonatomic) UIPickerView *tissue1Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt1;
@property (strong, nonatomic) UIPickerView *g1tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold1;
@property (strong, nonatomic) IBOutlet UITextField *tissue2;
@property (strong, nonatomic) UIPickerView *tissue2Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt2;
@property (strong, nonatomic) UIPickerView *g2tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold2;
@property (strong, nonatomic) IBOutlet UITextField *tissue3;
@property (strong, nonatomic) UIPickerView *tissue3Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt3;
@property (strong, nonatomic) UIPickerView *g3tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold3;
@property (strong, nonatomic) IBOutlet UITextField *tissue4;
@property (strong, nonatomic) UIPickerView *tissue4Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt4;
@property (strong, nonatomic) UIPickerView *g4tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold4;
@property (strong, nonatomic) IBOutlet UITextField *tissue5;
@property (strong, nonatomic) UIPickerView *tissue5Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt5;
@property (strong, nonatomic) UIPickerView *g5tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold5;
@property (strong, nonatomic) IBOutlet UITextField *tissue6;
@property (strong, nonatomic) UIPickerView *tissue6Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt6;
@property (strong, nonatomic) UIPickerView *g6tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold6;
@property (strong, nonatomic) IBOutlet UITextField *tissue7;
@property (strong, nonatomic) UIPickerView *tissue7Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt7;
@property (strong, nonatomic) UIPickerView *g7tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold7;
@property (strong, nonatomic) IBOutlet UITextField *tissue8;
@property (strong, nonatomic) UIPickerView *tissue8Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt8;
@property (strong, nonatomic) IBOutlet UITextField *fold8;
@property (strong, nonatomic) UIPickerView *g8tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *tissue9;
@property (strong, nonatomic) UIPickerView *tissue9Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt9;
@property (strong, nonatomic) UIPickerView *g9tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold9;
@property (strong, nonatomic) IBOutlet UITextField *tissue10;
@property (strong, nonatomic) UIPickerView *tissue10Picker;
@property (strong, nonatomic) IBOutlet UITextField *gtlt10;
@property (strong, nonatomic) UIPickerView *g10tltPicker;
@property (strong, nonatomic) IBOutlet UITextField *fold10;
// Spinning wheel that goes when work is being done
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// Data of HTTP response
@property (strong, nonatomic) NSMutableData *responseData;
// Data in readable string format
@property (strong, nonatomic) NSString *response;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
// This is the array of textfields that we will limit the length of
// It is defined in viewDidLoad
@property (strong, nonatomic) NSArray *folds;
@end

@implementation AdvancedSearchController
// Turn off rotation of the device
- (BOOL)shouldAutorotate
{
    return NO;
}
// A method that brings us back to our main page by closing the current view
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField.frame.origin.y > 300) {
        _scrollView.contentOffset = CGPointMake( 0, textField.frame.origin.y - 300); //required offset
        //provide contentOffSet those who needed
    } else {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    return YES;
}
// A method that catches all touches made. I am currently using it to close the keyboard
// if you touch on something that doesn't need it.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    // If the touch isn't on a UITextField, close the keyboard,
    // we don't need it anymore
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
        _scrollView.contentOffset = CGPointMake(0,0); //make UIScrollView as it was before
    }
    [super touchesBegan:touches withEvent:event];
}
// This is the main search function. It will take whatever search parameters are in the
// fields given, and shoot them off to the server. NOTE: Because this isn't working at the
// time of my departure, I had to make my best guess about what the response is going to
// look like, and I wrote the script around that. It is, however, very likely that a few
// characters will need to be changed in order to get it working well.
- (IBAction)Search:(id)sender {
    [self.activityWheel startAnimating];
    NSMutableArray *inputs = [[NSMutableArray alloc]initWithArray:@[_tissue0.text, _gtlt0.text, _fold0.text, _tissue1.text, _gtlt1.text, _fold1.text, _tissue2.text, _gtlt2.text, _fold2.text, _tissue3.text, _gtlt3.text, _fold3.text, _tissue4.text, _gtlt4.text, _fold4.text, _tissue5.text, _gtlt5.text, _fold5.text, _tissue6.text, _gtlt6.text, _fold6.text, _tissue7.text, _gtlt7.text, _fold7.text,_tissue8.text, _gtlt8.text, _fold8.text, _tissue9.text, _gtlt9.text, _fold9.text, _tissue10.text, _gtlt10.text, _fold10.text]];
    int c = 0;
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSString *str in inputs) {
        if ([str isEqualToString:@""]) {
            [tempArray addObject:@"NULL"];
        } else {
            [tempArray addObject:str];
        }
        c++;
    }
    // set URL to send request to
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://pob.abcc.ncifcrf.gov/cgi-bin/JK"]];
    // set method to send HTTP request by
    request.HTTPMethod = @"POST";
    // set encoding
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Variadic function to instert all our user information into the POST message
    _annotations = [_annotations stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    _heatmapThreshold = [_heatmapThreshold stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    _heatmapValue = [_heatmapValue stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    _orderBy = [_orderBy stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *stringData = [NSString stringWithFormat:@"rm=multi_expression_query&frm=multi_expression_query&submitted_multi_expression_query=SEARCH&db=nb&tissue0=%@&gtlt0=%@&fold0=%@&tissue1=%@&gtlt1=%@&fold1=%@&tissue2=%@&gtlt2=%@&fold2=%@&tissue3=%@&gtlt3=%@&fold3=%@&tissue4=%@&gtlt4=%@&fold4=%@&tissue5=%@&gtlt5=%@&fold5=%@&tissue6=%@&gtlt6=%@&fold6=%@&tissue7=%@&gtlt7=%@&fold7=%@&tissue8=%@&gtlt8=%@&fold8=%@&tissue9=%@&gtlt9=%@&fold9=%@&tissue10=%@&gtlt10=%@&fold10=%@%@@&limit=%@%@&threshold=%@&exprs=%@&orderby=%@", tempArray[0], tempArray[1], tempArray[2], tempArray[3], tempArray[4], tempArray[5], tempArray[6], tempArray[7], tempArray[8], tempArray[9], tempArray[10], tempArray[11], tempArray[12], tempArray[13], tempArray[14], tempArray[15], tempArray[16], tempArray[17], tempArray[18], tempArray[19], tempArray[20], tempArray[21], tempArray[22], tempArray[23], tempArray[24], tempArray[25], tempArray[26], tempArray[27], tempArray[28], tempArray[29], tempArray[30], tempArray[31], tempArray[32], _produceHeatmap, _limitTo, _annotations, _heatmapThreshold, _heatmapValue, _orderBy];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([_folds containsObject:textField]) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set all delegates so that we can catch events on these objects. I specifically added these so that
    // the textFieldShouldBeginEditing function can be triggered by textfields and the touchesBegan method
    // can be triggered by the scrollView
    [_tissue0 setDelegate:self];
    [_tissue1 setDelegate:self];
    [_tissue2 setDelegate:self];
    [_tissue3 setDelegate:self];
    [_tissue4 setDelegate:self];
    [_tissue5 setDelegate:self];
    [_tissue6 setDelegate:self];
    [_tissue7 setDelegate:self];
    [_tissue8 setDelegate:self];
    [_tissue9 setDelegate:self];
    [_tissue10 setDelegate:self];
    [_gtlt0 setDelegate:self];
    [_gtlt1 setDelegate:self];
    [_gtlt2 setDelegate:self];
    [_gtlt3 setDelegate:self];
    [_gtlt4 setDelegate:self];
    [_gtlt5 setDelegate:self];
    [_gtlt6 setDelegate:self];
    [_gtlt7 setDelegate:self];
    [_gtlt8 setDelegate:self];
    [_gtlt9 setDelegate:self];
    [_gtlt10 setDelegate:self];
    [_fold0 setDelegate:self];
    [_fold1 setDelegate:self];
    [_fold2 setDelegate:self];
    [_fold3 setDelegate:self];
    [_fold4 setDelegate:self];
    [_fold5 setDelegate:self];
    [_fold6 setDelegate:self];
    [_fold7 setDelegate:self];
    [_fold8 setDelegate:self];
    [_fold9 setDelegate:self];
    [_fold10 setDelegate:self];
    // This array defines which textfields will have restricted lengths
    _folds = @[_fold0, _fold1, _fold2, _fold3, _fold4, _fold5, _fold6, _fold7, _fold8, _fold9,_fold10];
    // These statements initialize all our pickerviews so that when we tap on
    // a textfield they pop up instead of a keyboard. These arrays define what
    // shows up in the picker views
    _gtlts = [[NSArray alloc]initWithObjects:@">", @"<", nil];
    _optionsTissue = [[NSArray alloc]initWithObjects:@"", @"every_Stage", @"ASPS", @"Normal", nil];
    _andorArray = [[NSArray alloc]initWithObjects:@"AND", @"OR", nil];
    // Allocate and itialize the memory to hold the picker
    _andorPicker = [[UIPickerView alloc]init];
    // Tell it where to get data from
    [_andorPicker setDataSource:self];
    // Tell it where to send data
    [_andorPicker setDelegate:self];
    // Tell it to show what is selected
    [_andorPicker setShowsSelectionIndicator:YES];
    // Set the input of the textfield to our pickerview
    _andor.inputView = _andorPicker;
    // Repeat... etc
    _tissue0Picker = [[UIPickerView alloc]init];
    [_tissue0Picker setDataSource:self];
    [_tissue0Picker setDelegate:self];
    [_tissue0Picker setShowsSelectionIndicator:YES];
    _tissue0.inputView = _tissue0Picker;
    _tissue0.text = @"";
    _tissue1Picker = [[UIPickerView alloc]init];
    [_tissue1Picker setDataSource:self];
    [_tissue1Picker setDelegate:self];
    [_tissue1Picker setShowsSelectionIndicator:YES];
    _tissue1.inputView = _tissue1Picker;
    _tissue1.text = @"";
    _tissue2Picker = [[UIPickerView alloc]init];
    [_tissue2Picker setDataSource:self];
    [_tissue2Picker setDelegate:self];
    [_tissue2Picker setShowsSelectionIndicator:YES];
    _tissue2.inputView = _tissue2Picker;
    _tissue2.text = @"";
    _tissue3Picker = [[UIPickerView alloc]init];
    [_tissue3Picker setDataSource:self];
    [_tissue3Picker setDelegate:self];
    [_tissue3Picker setShowsSelectionIndicator:YES];
    _tissue3.inputView = _tissue3Picker;
    _tissue3.text = @"";
    _tissue4Picker = [[UIPickerView alloc]init];
    [_tissue4Picker setDataSource:self];
    [_tissue4Picker setDelegate:self];
    [_tissue4Picker setShowsSelectionIndicator:YES];
    _tissue4.inputView = _tissue4Picker;
    _tissue4.text = @"";
    _tissue5Picker = [[UIPickerView alloc]init];
    [_tissue5Picker setDataSource:self];
    [_tissue5Picker setDelegate:self];
    [_tissue5Picker setShowsSelectionIndicator:YES];
    _tissue5.inputView = _tissue5Picker;
    _tissue5.text = @"";
    _tissue6Picker = [[UIPickerView alloc]init];
    [_tissue6Picker setDataSource:self];
    [_tissue6Picker setDelegate:self];
    [_tissue6Picker setShowsSelectionIndicator:YES];
    _tissue6.inputView = _tissue6Picker;
    _tissue6.text = @"";
    _tissue7Picker = [[UIPickerView alloc]init];
    [_tissue7Picker setDataSource:self];
    [_tissue7Picker setDelegate:self];
    [_tissue7Picker setShowsSelectionIndicator:YES];
    _tissue7.inputView = _tissue7Picker;
    _tissue7.text = @"";
    _tissue8Picker = [[UIPickerView alloc]init];
    [_tissue8Picker setDataSource:self];
    [_tissue8Picker setDelegate:self];
    [_tissue8Picker setShowsSelectionIndicator:YES];
    _tissue8.inputView = _tissue8Picker;
    _tissue8.text = @"";
    _tissue9Picker = [[UIPickerView alloc]init];
    [_tissue9Picker setDataSource:self];
    [_tissue9Picker setDelegate:self];
    [_tissue9Picker setShowsSelectionIndicator:YES];
    _tissue9.inputView = _tissue9Picker;
    _tissue9.text = @"";
    _tissue10Picker = [[UIPickerView alloc]init];
    [_tissue10Picker setDataSource:self];
    [_tissue10Picker setDelegate:self];
    [_tissue10Picker setShowsSelectionIndicator:YES];
    _tissue10.inputView = _tissue10Picker;
    _tissue10.text = @"";
    _gtlt0Picker = [[UIPickerView alloc]init];
    [_gtlt0Picker setDataSource:self];
    [_gtlt0Picker setDelegate:self];
    [_gtlt0Picker setShowsSelectionIndicator:YES];
    _gtlt0.inputView = _gtlt0Picker;
    // While the tissue select starts off blank, the gtlt is only ever
    // > or < so we're going to start it out with >.
    _gtlt0.text = @">";
    _g1tltPicker = [[UIPickerView alloc]init];
    [_g1tltPicker setDataSource:self];
    [_g1tltPicker setDelegate:self];
    [_g1tltPicker setShowsSelectionIndicator:YES];
    _gtlt1.inputView = _g1tltPicker;
    _gtlt1.text = @">";
    _g2tltPicker = [[UIPickerView alloc]init];
    [_g2tltPicker setDataSource:self];
    [_g2tltPicker setDelegate:self];
    [_g2tltPicker setShowsSelectionIndicator:YES];
    _gtlt2.inputView = _g2tltPicker;
    _gtlt2.text = @">";
    _g3tltPicker = [[UIPickerView alloc]init];
    [_g3tltPicker setDataSource:self];
    [_g3tltPicker setDelegate:self];
    [_g3tltPicker setShowsSelectionIndicator:YES];
    _gtlt3.inputView = _g3tltPicker;
    _gtlt3.text = @">";
    _g4tltPicker = [[UIPickerView alloc]init];
    [_g4tltPicker setDataSource:self];
    [_g4tltPicker setDelegate:self];
    [_g4tltPicker setShowsSelectionIndicator:YES];
    _gtlt4.inputView = _g4tltPicker;
    _gtlt4.text = @">";
    _g5tltPicker = [[UIPickerView alloc]init];
    [_g5tltPicker setDataSource:self];
    [_g5tltPicker setDelegate:self];
    [_g5tltPicker setShowsSelectionIndicator:YES];
    _gtlt5.inputView = _g5tltPicker;
    _gtlt5.text = @">";
    _g6tltPicker = [[UIPickerView alloc]init];
    [_g6tltPicker setDataSource:self];
    [_g6tltPicker setDelegate:self];
    [_g6tltPicker setShowsSelectionIndicator:YES];
    _gtlt6.inputView = _g6tltPicker;
    _gtlt6.text = @">";
    _g7tltPicker = [[UIPickerView alloc]init];
    [_g7tltPicker setDataSource:self];
    [_g7tltPicker setDelegate:self];
    [_g7tltPicker setShowsSelectionIndicator:YES];
    _gtlt7.inputView = _g7tltPicker;
    _gtlt7.text = @">";
    _g8tltPicker = [[UIPickerView alloc]init];
    [_g8tltPicker setDataSource:self];
    [_g8tltPicker setDelegate:self];
    [_g8tltPicker setShowsSelectionIndicator:YES];
    _gtlt8.inputView = _g8tltPicker;
    _gtlt8.text = @">";
    _g9tltPicker = [[UIPickerView alloc]init];
    [_g9tltPicker setDataSource:self];
    [_g9tltPicker setDelegate:self];
    [_g9tltPicker setShowsSelectionIndicator:YES];
    _gtlt9.inputView = _g9tltPicker;
    _gtlt9.text = @">";
    _g10tltPicker = [[UIPickerView alloc]init];
    [_g10tltPicker setDataSource:self];
    [_g10tltPicker setDelegate:self];
    [_g10tltPicker setShowsSelectionIndicator:YES];
    _gtlt10.inputView = _g10tltPicker;
    _gtlt10.text = @">";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark PickerView DataSource
// This method sets the text of each textfield to the value selected on the pickerview
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if (pickerView == self.tissue0Picker) {
        // Note that it is the title that is being used to set the textfield here, not the label
        [_tissue0 setText:[self pickerView:_tissue0Picker titleForRow:[_tissue0Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue1Picker) {
        [_tissue1 setText:[self pickerView:_tissue1Picker titleForRow:[_tissue1Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue2Picker) {
        [_tissue2 setText:[self pickerView:_tissue2Picker titleForRow:[_tissue2Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue3Picker) {
        [_tissue3 setText:[self pickerView:_tissue3Picker titleForRow:[_tissue3Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue4Picker) {
        [_tissue4 setText:[self pickerView:_tissue4Picker titleForRow:[_tissue4Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue5Picker) {
        [_tissue5 setText:[self pickerView:_tissue5Picker titleForRow:[_tissue5Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue6Picker) {
        [_tissue6 setText:[self pickerView:_tissue6Picker titleForRow:[_tissue6Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue6Picker) {
        [_tissue6 setText:[self pickerView:_tissue6Picker titleForRow:[_tissue6Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue7Picker) {
        [_tissue7 setText:[self pickerView:_tissue7Picker titleForRow:[_tissue7Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue8Picker) {
        [_tissue8 setText:[self pickerView:_tissue8Picker titleForRow:[_tissue8Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue9Picker) {
        [_tissue9 setText:[self pickerView:_tissue9Picker titleForRow:[_tissue9Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.tissue10Picker) {
        [_tissue10 setText:[self pickerView:_tissue10Picker titleForRow:[_tissue10Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.gtlt0Picker) {
        [_gtlt0 setText:[self pickerView:_gtlt0Picker titleForRow:[_gtlt0Picker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g1tltPicker) {
        [_gtlt1 setText:[self pickerView:_g1tltPicker titleForRow:[_g1tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g2tltPicker) {
        [_gtlt2 setText:[self pickerView:_g2tltPicker titleForRow:[_g2tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g3tltPicker) {
        [_gtlt3 setText:[self pickerView:_g3tltPicker titleForRow:[_g3tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g4tltPicker) {
        [_gtlt4 setText:[self pickerView:_g4tltPicker titleForRow:[_g4tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g5tltPicker) {
        [_gtlt5 setText:[self pickerView:_g5tltPicker titleForRow:[_g5tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g6tltPicker) {
        [_gtlt6 setText:[self pickerView:_g6tltPicker titleForRow:[_g6tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g7tltPicker) {
        [_gtlt7 setText:[self pickerView:_g7tltPicker titleForRow:[_g7tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g8tltPicker) {
        [_gtlt8 setText:[self pickerView:_g8tltPicker titleForRow:[_g8tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g9tltPicker) {
        [_gtlt9 setText:[self pickerView:_g9tltPicker titleForRow:[_g9tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.g10tltPicker) {
        [_gtlt10 setText:[self pickerView:_g10tltPicker titleForRow:[_g10tltPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.andorPicker) {
        [_andor setText:[self pickerView:_andorPicker titleForRow:[_andorPicker selectedRowInComponent:0] forComponent:0]];
    }
}
// If you wanted more than on column for the pickerview you would define that here
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
// This defines the number of selectable items in the pickerview. Right now
// it is set to however many items we have to choose from
// Usually it would be better to do for each picker view if(pickerView == self.____) return [____array count];
// to make it dynamic, but in this case these values are always the same, so we don't need to go through
// all of that.
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.gtlt0Picker || pickerView == self.g1tltPicker|| pickerView == self.g2tltPicker|| pickerView == self.g3tltPicker|| pickerView == self.g4tltPicker|| pickerView == self.g5tltPicker|| pickerView == self.g6tltPicker|| pickerView == self.g7tltPicker|| pickerView == self.g8tltPicker|| pickerView == self.g9tltPicker|| pickerView == self.g10tltPicker || pickerView == self.andorPicker) {
        return 2;
    }
    else{
        return 4;
    }
}
// This method defines the title of the row. This is what is behind the scenes. It is what the pickerview is
// actually selecting, the viewForRow method defines what the user sees. Think about it like you have
// <option value="foo">bar</option> foo is the title, bar is the view.
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView == self.tissue0Picker || pickerView == self.tissue1Picker || pickerView == self.tissue2Picker || pickerView == self.tissue3Picker || pickerView == self.tissue4Picker || pickerView == self.tissue5Picker || pickerView == self.tissue6Picker || pickerView == self.tissue7Picker || pickerView == self.tissue8Picker || pickerView == self.tissue9Picker || pickerView == self.tissue10Picker) {
        return _optionsTissue[row];
    }
    else if (pickerView == self.gtlt0Picker || pickerView == self.g1tltPicker|| pickerView == self.g2tltPicker|| pickerView == self.g3tltPicker|| pickerView == self.g4tltPicker|| pickerView == self.g5tltPicker|| pickerView == self.g6tltPicker|| pickerView == self.g7tltPicker|| pickerView == self.g8tltPicker|| pickerView == self.g9tltPicker|| pickerView == self.g10tltPicker) {
        return _gtlts[row];
    }
    else if (pickerView == self.andorPicker) {
        return _andorArray[row];
    }
    else{
        return @"";
    }
}
// For a given row this defines what the row should display as text.
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.tissue0Picker || pickerView == self.tissue1Picker || pickerView == self.tissue2Picker || pickerView == self.tissue3Picker || pickerView == self.tissue4Picker || pickerView == self.tissue5Picker || pickerView == self.tissue6Picker || pickerView == self.tissue7Picker || pickerView == self.tissue8Picker || pickerView == self.tissue9Picker || pickerView == self.tissue10Picker) {
        tView.text = _optionsTissue[row];
    }
    else if (pickerView == self.gtlt0Picker || pickerView == self.g1tltPicker|| pickerView == self.g2tltPicker|| pickerView == self.g3tltPicker|| pickerView == self.g4tltPicker|| pickerView == self.g5tltPicker|| pickerView == self.g6tltPicker|| pickerView == self.g7tltPicker|| pickerView == self.g8tltPicker|| pickerView == self.g9tltPicker|| pickerView == self.g10tltPicker) {
        tView.text = _gtlts[row];
    } else {
        tView.text = _andorArray[row];
    }
    return tView;
}
// These methods handle HTTP requests. The name of each one is pretty self explanitory.
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}
// Use to handle the response you get from the server. Right now it's just an exact
// copy of the method used to handle a normal text search.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    if ([_response rangeOfString:@"500 Internal Server Error"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"500 Internal Server Error" message:@"The server encountered an internal error or                              misconfiguration and was unable to complete                              your request."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // find the appropriate storyboard for the given device
    UIStoryboard *storyboard = [[UIStoryboard alloc]init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    if ([_response rangeOfString:@"login_submitted"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forced Logout" message:@"You have been inactive for too long and have been logged out. Please log in again."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        ViewController *ViewController2 = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:ViewController2 animated:YES completion:nil];
        return;
    }
    if([_response rangeOfString:@"<table  class=\"heatmapouter\">"].location != NSNotFound) {
        // All successful searches provide transcripts, so if this string is not there
        // we know that it was unsuccessful and stop the program here.
        if([_response rangeOfString:@"Transcripts(+)"].location == NSNotFound) {
            NSString *message = @"There were no results for the given search parameters. (Tip:If you don't find your gene of interest in the Full-Text query add two wildcards (%), e.g. \"%CD45%\") ";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Emtpy Response" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self.activityWheel stopAnimating];
            return;
        }
        // if there's a heatmapouter, we know that the data is ready to be viewed, so we switch to the view that will hold the data
        DataViewController *ViewController = (DataViewController *)[storyboard instantiateViewControllerWithIdentifier:@"data"];
        ViewController.html = [_response mutableCopy];
        [self presentViewController:ViewController animated:YES completion:nil];
        [self.activityWheel stopAnimating];
    }
    else {
        // if we didn't find any heatmapouter then the search was unsuccessful, so therefore we ask the user to provide different parameters
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid search parameters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.activityWheel stopAnimating];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *message = @"Could not connect to server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.activityWheel stopAnimating];
}

@end
