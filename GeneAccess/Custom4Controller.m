//
//  Custom4Controller.m
//  Oncogenomics DB
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 8/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "Custom4Controller.h"
#import "ViewController.h"
#import "DatabaseViewController.h"
@interface Custom4Controller ()
@property (strong, nonatomic) IBOutlet UITextField *dbName;
@property (strong, nonatomic) IBOutlet UITextView *geneList;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
@end

@implementation Custom4Controller
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)makeDB:(id)sender {
    // create a HTTP request
    [_activityWheel startAnimating];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalURL]];
    // define HTTP method
    request.HTTPMethod = @"POST";
    // Convert data and set request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"submit_create_db=Make+DB=&rm=create_db&frm=create_db&db_name=%@&gene_list=%@", _dbName.text, _geneList.text];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        DatabaseViewController *viewController = (DatabaseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"databases"];
        [self presentViewController:viewController animated:YES completion:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Database created."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
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
