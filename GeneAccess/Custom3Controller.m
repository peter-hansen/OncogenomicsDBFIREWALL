//
//  Custom3Controller.m
//  Oncogenomics DB
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 8/4/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "Custom3Controller.h"
#import "Custom4Controller.h"
#import "ViewController.h"
@interface Custom3Controller ()
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property int count;
@property (strong, nonatomic) NSMutableArray *activeObjects;
@property (strong, nonatomic) NSMutableArray *textFields;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
@end

@implementation Custom3Controller
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)updateOrder:(id)sender {
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableString *orders =[@"" mutableCopy];
    for (UITextField *text in _textFields) {
        [orders appendString:[NSString stringWithFormat:@"&%@=%@", text.accessibilityLabel, text.text]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"submit_sample_cart=Update+order&rm=sample_cart&frm=sample_cart%@", orders];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (IBAction)createDB:(id)sender {
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"submit_create_db=Create+DB&rm=sample_cart&frm=sample_cart"];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)removeButtonSet:(UIView*)sender{
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"submit_remove_group=%@&rm=sample_cart&frm=sample_cart", sender.accessibilityLabel];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)removeButtonSample:(UIView*)sender{
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"submit_remove_sample=%@&rm=sample_cart&frm=sample_cart", sender.accessibilityLabel];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _activeObjects = [[NSMutableArray alloc]init];
    _textFields = [[NSMutableArray alloc]init];
    [self reload];
}
-(void)reload {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    int c = 0;
    NSMutableArray *dummyArray = [[NSMutableArray alloc]init];
    NSMutableArray *dummyArray2 = [[NSMutableArray alloc]init];
    NSMutableArray *msampleFinder = [[_html componentsSeparatedByString:@"id=order"] mutableCopy];
    [msampleFinder removeObjectAtIndex:0];
    // count is our overall number of switches + 1. The +1 is so that when necessary the next element in the array can be accessed
    // before it is iterated on
    for (NSString *str in msampleFinder) {
        dummyArray =[[str componentsSeparatedByString:@"name=\""]mutableCopy];
        dummyArray =[[dummyArray[1] componentsSeparatedByString:@"|"]mutableCopy];
        _count = [dummyArray[0] integerValue];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 60 +c*34, 40, 21)];
        [_textFields addObject:text];
        [text setBackgroundColor:[UIColor whiteColor]];
        [text setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        text.text = [NSString stringWithFormat:@"%i", _count];
        dummyArray = [[dummyArray[1] componentsSeparatedByString:@"\""]mutableCopy];
        text.accessibilityLabel = [NSString stringWithFormat: @"%i|%@", _count, dummyArray[0]];
        dummyArray =[[str componentsSeparatedByString:@"<span name=\""] mutableCopy];
        [dummyArray removeObjectAtIndex:0];
        dummyArray2 = [[dummyArray[0] componentsSeparatedByString:@"\""] mutableCopy];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 60 +c*34, 260, 21)];
        label.text = dummyArray2[0];
        label.font = [UIFont systemFontOfSize:14];
        [[dummyArray2[0] componentsSeparatedByString:@" "] mutableCopy];
        [dummyArray2 removeObject:@" "];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(300, 60+c*34, 20, 20)];
        button.accessibilityLabel=[NSString stringWithFormat:@"%i", _count];
        [button setTitle:@"X" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeButtonSet:) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:text];
        [self.container addSubview:button];
        [self.container addSubview:label];
        [_activeObjects addObject:text];
        [_activeObjects addObject:button];
        [_activeObjects addObject:label];
        c++;
        dummyArray =[[dummyArray[0] componentsSeparatedByString:@"<div>"]mutableCopy];
        dummyArray =[[dummyArray[1] componentsSeparatedByString:@"<br>"] mutableCopy];
        [dummyArray removeObjectAtIndex:[dummyArray count]-1];
        if ([[dummyArray lastObject] rangeOfString:@"</div>"].location != NSNotFound) {
            [dummyArray removeObjectAtIndex:[dummyArray count] -1];
        }
        for (NSString *str2 in dummyArray) {
            dummyArray2 = [[str2 componentsSeparatedByString:@" "] mutableCopy];
            [dummyArray2 removeObject:@""];
            [dummyArray2 removeObject:@"\n"];
            UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 +c*34, 280, 21)];
            myLabel.text = [NSString stringWithFormat:@"%@ %@", dummyArray2[0], dummyArray2[1]];
            myLabel.font = [UIFont systemFontOfSize:14];
            [self.container addSubview:myLabel];
            UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(285, 60 + c*34, 20, 21)];
            myButton.accessibilityLabel = [NSString stringWithFormat: @"%i|%@", _count, dummyArray2[0]];
            [myButton addTarget:self action:@selector(removeButtonSample:) forControlEvents:UIControlEventTouchUpInside];
            [myButton setTitle:@"X" forState:UIControlStateNormal];
            [self.container addSubview:myButton];
            [self.container addSubview:myLabel];
            [_activeObjects addObject:myButton];
            [_activeObjects addObject:myLabel];
            c++;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
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
        [self.activityWheel stopAnimating];
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
    if([_response rangeOfString:@"id='submit_remove'"].location != NSNotFound) {
        _html = _response;
        [self reload];
    } else if([_response rangeOfString:@"Selected Samples :"].location != NSNotFound) {
        // find the appropriate storyboard for the given device
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        Custom4Controller *viewController = (Custom4Controller *)[storyboard instantiateViewControllerWithIdentifier:@"custom4"];
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
