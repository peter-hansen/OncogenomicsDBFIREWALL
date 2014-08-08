//
//  Custom1Controller.m
//  Oncogenomics DB
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/28/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "Custom1Controller.h"
#import "ViewController.h"
#import "Custom2Controller.h"
#import "Custom3Controller.h"
@interface Custom1Controller ()
@property (strong,nonatomic) NSString *html;
@property (strong, nonatomic) NSMutableArray *tumor;
@property (strong, nonatomic) NSMutableArray *normal;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *switches;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property (strong, nonatomic) NSMutableString *samples;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
@end

@implementation Custom1Controller
- (IBAction)currentSelection:(id)sender {
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"nav_sample_cart=Your+Current+Sample+Selection&rm=sample_select&frm=sample_select"];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)nextStep:(id)sender {
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    _samples = [[NSMutableString alloc]init];
    for (UISwitch *aswitch in _switches) {
        if ([aswitch isOn]) {
            if ([_tumor containsObject:aswitch.accessibilityLabel]) {
                [_samples appendString:[NSString stringWithFormat:@"&Tumor_Diagnosis=%@", aswitch.accessibilityLabel]];
            } else if ([_normal containsObject:aswitch.accessibilityLabel]) {
                [_samples appendString:[NSString stringWithFormat:@"&Normal_Tissue_Type=%@", aswitch.accessibilityLabel]];
            }
        }
    }
    NSString *stringData = [NSString stringWithFormat:@"submit_sample_select=Next+Step+»&rm=sample_select&frm=sample_select%@", _samples];
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
    _switches = [[NSMutableArray alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@?rm=sample_select", globalURL];
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSError *err = nil;
    _html = [NSString stringWithContentsOfURL:urlRequest encoding:NSUTF8StringEncoding error:&err];
    int c = 0;
    NSMutableArray *dummyArray = [[NSMutableArray alloc]init];
    NSArray *dummyArray2 = [[NSArray alloc]init];
    NSMutableArray *msampleFinder = [[_html componentsSeparatedByString:@"<div id=\"basiclist\""] mutableCopy];
    msampleFinder = [[msampleFinder[1] componentsSeparatedByString:@"<div class='fcell'>"] mutableCopy];
    // count is our overall number of switches + 1. The +1 is so that when necessary the next element in the array can be accessed
    // before it is iterated on
    int count = 1;
    // row should really be column, this will only ever be 0 (left) or 1 (right)
    int row = 0;
    // We start with the 0.___ samples that we earlier put in msampleFinder2
    dummyArray = [[msampleFinder[1] componentsSeparatedByString:@"value=\""] mutableCopy];
    [dummyArray removeObjectAtIndex:0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 280, 21)];
    label.text = @"Tumor_Diagnosis";
    label.font = [UIFont systemFontOfSize:20];
    [self.container addSubview:label];
    _tumor = [[NSMutableArray alloc]init];
    int switchesNeeded = [dummyArray count];
    for (NSString *str2 in dummyArray) {
        // We don't need the beginning of our array anymore because we already captured it, so we're going to throw it away
        // and focus on the third element which is where our label information is going to be
        dummyArray2 = [str2 componentsSeparatedByString:@"\""];
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
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54+50 +355*row, 89 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            // Place the label in the view that is on top. Otherwise it will be invisible
            [self.container addSubview:myLabel];
            // map the id of our switch to the url for tha data we want that switch to turn on
            [_tumor addObject:dummyArray2[0]];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 84 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            // give the switch a label corresponding to it's id
            mySwitch.accessibilityLabel = dummyArray2[0];
            [self.container addSubview:mySwitch];
            [self.container addSubview:myLabel];
        } else {
            // exact same thing, just different positioning to accomodate the iPhone's screen
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 89 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            [self.container addSubview:myLabel];
            [_tumor addObject:dummyArray2[0]];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 84 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            mySwitch.accessibilityLabel = dummyArray2[0];
            [self.container addSubview:mySwitch];
            [self.container addSubview:myLabel];
        }
        c++;
        count++;
    }
    row = 0;
    int tumorSamples = c;
    dummyArray = [[msampleFinder[2] componentsSeparatedByString:@"value=\""] mutableCopy];
    [dummyArray removeObjectAtIndex:0];
    UILabel *normallabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 89+ c*34, 280, 21)];
    c++;
    normallabel.text = @"Normal_Tissue_Type";
    normallabel.font = [UIFont systemFontOfSize:20];
    [self.container addSubview:normallabel];
    _normal = [[NSMutableArray alloc]init];
    switchesNeeded = [dummyArray count]+1;
    for (NSString *str2 in dummyArray) {
        // We don't need the beginning of our array anymore because we already captured it, so we're going to throw it away
        // and focus on the third element which is where our label information is going to be
        dummyArray2 = [str2 componentsSeparatedByString:@"\""];
        // Since the iPad is so much bigger, we're obviously going to put the switches in different positions, so right here
        // before we do that we check to see if the device is an iPad or not
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            // Since the iPad is big enough to fit two columns, we are going to use two columns! To figure out when we need to start
            // our new column we check to see if the number of rows in that column (c) exceeds half the number of switches in total.
            if ((c - tumorSamples) > (float)switchesNeeded/2.0 - 0.5) {
                row = 1;
                c= tumorSamples + 1;
            }
            // Making the label that goes next to the switch. The parameters are (xpos, ypos, width, height)
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54+50 +355*row, 89 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            // Place the label in the view that is on top. Otherwise it will be invisible
            [self.container addSubview:myLabel];
            // map the id of our switch to the url for tha data we want that switch to turn on
            [_normal addObject:dummyArray2[0]];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 84 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            // give the switch a label corresponding to it's id
            mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
            [self.container addSubview:mySwitch];
            [self.container addSubview:myLabel];
        } else {
            // exact same thing, just different positioning to accomodate the iPhone's screen
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 89 +c*34, 280, 21)];
            myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
            myLabel.font = [UIFont systemFontOfSize:14];
            [self.container addSubview:myLabel];
            [_normal addObject:dummyArray2[0]];
            UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 84 + c*34, 0, 0)];
            [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            mySwitch.accessibilityLabel = dummyArray2[0];
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
    if([_response rangeOfString:@"name=\"submit_sample_confirm\""].location != NSNotFound) {
        // find the appropriate storyboard for the given device
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        Custom2Controller *viewController = (Custom2Controller *)[storyboard instantiateViewControllerWithIdentifier:@"custom2"];
        viewController.html = _response;
        viewController.sampleFeature = _samples;
        [self presentViewController:viewController animated:YES completion:nil];
    } else if([_response rangeOfString:@"submit_remove"].location != NSNotFound) {
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
    }
    else {
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
