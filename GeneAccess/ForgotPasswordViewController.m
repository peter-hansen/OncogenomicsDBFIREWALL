//
//  ForgotPasswordViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/5/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ViewController.h"
@interface ForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;

@end

@implementation ForgotPasswordViewController
@synthesize email;
- (BOOL)shouldAutorotate
{
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Send the request to the server and let it handle things
- (IBAction)submit:(id)sender {
    [_activityWheel startAnimating];
    email = [_emailView text];
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"rm=forgot_passwd&forgot_passwd_submitted=TRUE&frm=forgot_passwd&email=%@" , email];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_activityWheel stopAnimating];
    NSString *message = @"Email has been sent. It will arrive shortly.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    NSString *message = @"There was an error connecting to the server. Please make sure you are logged into the VPN";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
@end
