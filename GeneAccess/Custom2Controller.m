//
//  Custom2Controller.m
//  Oncogenomics DB
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/30/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "Custom2Controller.h"
#import "ViewController.h"
#import "Custom3Controller.h"
@interface Custom2Controller ()
@property (strong, nonatomic) IBOutlet UITextField *groupName;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *switches;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
@end

@implementation Custom2Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)addToCart:(id)sender {
    if ([_groupName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Group name of samples is empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSMutableString *samples = [@"" mutableCopy];
    for (UISwitch *aswitch in _switches) {
        if ([aswitch isOn]) {
            [samples appendString:[NSString stringWithFormat:@"&samples=%@", aswitch.accessibilityLabel]];
        }
    }
    NSString *stringData = [NSString stringWithFormat:@"submit_sample_confirm=TRUE&submit_sample_add=Add+these+samples+to+cart&rm=sample_confirm&frm=sample_confirm&groupname=%@%@%@&operation=+A+", _groupName.text, samples, _sampleFeature];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // start tracking switch
        if(![_switches containsObject:sender]) {
            [_switches addObject:sender];
        }
    } else{
        // do nothing
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int c = 0;
    NSMutableArray *dummyArray = [[NSMutableArray alloc]init];
    NSArray *dummyArray2 = [[NSArray alloc]init];
    NSMutableArray *msampleFinder = [[_html componentsSeparatedByString:@"<h3>SQL Results:"] mutableCopy];
    NSArray *msampleFinder2 = [[msampleFinder[1] componentsSeparatedByString:@"<span"] mutableCopy];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 280, 21)];
    label.text = [NSString stringWithFormat:@"SQL Results: %@", msampleFinder2[0]];
    label.font = [UIFont systemFontOfSize:20];
    [self.container addSubview:label];
    // count is our overall number of switches + 1. The +1 is so that when necessary the next element in the array can be accessed
    // before it is iterated on
    int count = 1;
    // row should really be column, this will only ever be 0 (left) or 1 (right)
    int row = 0;
    // We start with the 0.___ samples that we earlier put in msampleFinder2
    dummyArray = [[msampleFinder[1] componentsSeparatedByString:@"name='samples' value='"] mutableCopy];
    [dummyArray removeObjectAtIndex:0];
    int switchesNeeded = [dummyArray count];
    _switches = [[NSMutableArray alloc]init];
    for (NSString *str2 in dummyArray) {
        // We don't need the beginning of our array anymore because we already captured it, so we're going to throw it away
        // and focus on the third element which is where our label information is going to be
        dummyArray2 = [str2 componentsSeparatedByString:@"'"];
        // Since the iPad is so much bigger, we're obviously going to put the switches in different positions, so right here
        // before we do that we check to see if the device is an iPad or not
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // Since the iPad is big enough to fit two columns, we are going to use two columns! To figure out when we need to start
            // our new column we check to see if the number of rows in that column (c) exceeds half the number of switches in total.
            if (c > (float)switchesNeeded/2.0 - 0.5) {
                row = 1;
                c= 0;
            }
            // Making the label that goes next to the switch. The parameters are (xpos, ypos, width, height)
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54+50 +355*row, 153 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            // Place the label in the view that is on top. Otherwise it will be invisible
            [self.container addSubview:myLabel];
            // map the id of our switch to the url for tha data we want that switch to turn on
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 148 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            // give the switch a label corresponding to it's id
            mySwitch.accessibilityLabel = dummyArray2[0];
            mySwitch.on = true;
            [_switches addObject:mySwitch];
            [self.container addSubview:mySwitch];
            [self.container addSubview:myLabel];
        } else {
            // exact same thing, just different positioning to accomodate the iPhone's screen
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 153 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            [self.container addSubview:myLabel];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 148 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            mySwitch.accessibilityLabel = dummyArray2[0];
            mySwitch.on = true;
            [_switches addObject:mySwitch];
            [self.container addSubview:mySwitch];
            [self.container addSubview:myLabel];
        }
        c++;
        count++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NSURLConnection Delegate Methods
// These methods handle HTTP requests. The name of each one is pretty self explanitory.
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    if ([_response rangeOfString:@"500 Internal Server Error"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"500 Internal Server Error" message:@"The server encountered an internal error or                              misconfiguration and was unable to complete your request."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_response rangeOfString:@"login_submitted"].location != NSNotFound) {
        // find the appropriate storyboard for the given device
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forced Logout" message:@"You have been inactive for too long and have been logged out. Please log in again."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        ViewController *ViewController2 = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:ViewController2 animated:YES completion:nil];
        [self.activityWheel stopAnimating];
        return;
    }
    // This method handles the response of the server. Here we check to see if the server
    // told us that it's running the program or not. We can change what we are looking for
    // by just changing what is in the rangeOfString: parameter
    if([_response rangeOfString:@"submit_remove"].location != NSNotFound) {
        // find the appropriate storyboard for the given device
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        Custom3Controller *viewController = (Custom3Controller *)[storyboard instantiateViewControllerWithIdentifier:@"custom3"];
        viewController.html = _response;
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        NSString *message = @"Please select a sample feature.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.activityWheel stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *message = @"Could not connect to server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.activityWheel stopAnimating];
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

@end
