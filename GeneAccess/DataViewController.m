//
//  DataViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/6/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//
#import "DataViewController.h"
#import "DatabaseViewController.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface DataViewController ()
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *gestureRecognizer;
// I honestly do not remember what missingButton does. I spent
// 20 minutes trying to figure it out and all I've figured out
// is that if you delete this line the app crashes. So it's of
// vital importance, I just don't remember what.
@property (strong, nonatomic) IBOutlet UIButton *missingButton;
// html that was shown before navigating to current page
@property NSString *backHTML;
// html that was shown before pressing the back button
@property NSString *forwardHTML;
// html that is currently being displayed
@property NSString *currentHTML;
// array of pages visited prior to current page
@property NSMutableArray *backHistory;
// counter to keep track of which page in backHistory to go to
@property int backLocation;
// history of pages gone to before pressing back multiple times.
@property NSMutableArray *forwardHistory;
@property BOOL warningMessageShown;
@end

@implementation DataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
// Go back to main page by closing current view
- (IBAction)newSearch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Capture the contents of the webview so that the heatmap or whatever
// is in the webview can be saved for future viewing
- (IBAction)screenCapture:(id)sender {
    // The methods used to capture the screen here perform best with retina devices. If they are not
    // retina (i.e. scale == 1.0) we want to let the user know that they are operating suboptimally.
    // We only want to show it once though, so we check to see if it's been shown before as well.
    if (([UIScreen mainScreen].scale == 1.0) && !_warningMessageShown) {
        NSString *message = @"This functionality works best on retina devices. In order to obtain a clear screenshot, switch to a retina device.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        _warningMessageShown = true;
    }
    //get the current view
    CGRect originalFrame = _webView.frame;
    // create variable to manipulate the frame with
    CGRect frame = _webView.frame;
    frame.size.height = 1;
    // set the frame to our manipulated size
    _webView.frame = frame;
    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _webView.frame = frame;
    // create image from current frame
    UIGraphicsBeginImageContextWithOptions(_webView.bounds.size, NO, [UIScreen mainScreen].scale);
    [_webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // put the picture in Photos
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    // return to original view
    _webView.frame = originalFrame;
}
// go back to a previously loaded page
- (IBAction)back:(id)sender {
    if(_backLocation >= 0) {
        // add current page to forward history, because we're going back
        [_forwardHistory addObject:_currentHTML];
        // load the previously loaded html
        [_webView loadHTMLString:[_backHistory[_backLocation] description] baseURL:nil];
        // set the current html to the previous one
        _currentHTML = _backHistory[_backLocation];
        // we're going back so go back in the history
        _backLocation--;
        // we are already here so we don't need this html anymore
        [_backHistory removeObjectAtIndex:[_backHistory count] -1];
    }
}
// go forward to page we backed from
- (IBAction)forward:(id)sender {
    if([_forwardHistory count] != 0) {
        // add current page to back history again
        [_backHistory addObject:_currentHTML];
        // going forward, so go forward in history
        _backLocation++;
        // load forward html
        [_webView loadHTMLString:[[_forwardHistory lastObject] description] baseURL:nil];
        _currentHTML = [_forwardHistory lastObject];
        [_forwardHistory removeObjectAtIndex:[_forwardHistory count] -1];
    }
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat ratioAspect = _webView.bounds.size.width/_webView.bounds.size.height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            // Going to Portrait mode
            for (UIScrollView *scroll in [_webView subviews]) { //we get the scrollview
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
                }
            }
            break;
        default:
            // Going to Landscape mode
            for (UIScrollView *scroll in [_webView subviews]) { //we get the scrollview
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
                }
            }
            break;
    }
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    // when the screen flips we want to make sure that the webview fits the screen nicely.
    // here we just say that we want to leave a 45 pixel boarder on the top to put our buttons,
    // otherwise the dimensions are the same as the screen.
    if(UIDeviceOrientationIsLandscape(orientation)) {
        _webView.layer.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-45);
    }
    if(UIDeviceOrientationIsPortrait(orientation)) {
        _webView.layer.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 45);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // make it so the view can resize with a change in orientation
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    // start producing information on the orientation of the device
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    //instantiate the web view
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 45)];
    [_webView setDelegate:self];
    [_webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    _webView.scalesPageToFit=YES;
    //make the background transparent
    [_webView setBackgroundColor:[UIColor clearColor]];
    //Get just the data we want from the table
    NSArray* splittedArray= [_html componentsSeparatedByString:@"<div class=heatmap>"];
    // check to make sure the data we're looking for is there so the app doesn't crash
    NSMutableString *secondhtml = [[NSMutableString alloc]init];
    secondhtml = [@"<head><link href=\"http://nci-oncomics-1.nci.nih.gov/main.css\" rel=\"stylesheet\" type=\"text/css\"><table class=\"heatmapouter\"><link href=\"http://nci-oncomics-1.nci.nih.gov/JK/JK-db.css\" rel=\"stylesheet\" type=\"text/css\"><table class=\"heatmapouter\"></head>" mutableCopy];
    if(splittedArray[1]){
        [secondhtml appendString:splittedArray[1]];
    } else {
        return;
    }
    // Earlier, we cut at the begging of <div class=heatmap>, now we're cutting off the bottom
    // so everything in the heatmap div should end up in secondhtml
    splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
    secondhtml = splittedArray[0];
    // the html defines paths by the directory that it is currently it, but since we are spoofing
    // a browser and not actually one, this causes an error for us. We must insert the full
    // file path into the html
    if([secondhtml rangeOfString:@"/images/"].location != NSNotFound) {
        secondhtml = [[secondhtml stringByReplacingOccurrencesOfString:@"/images/" withString:@"http://nci-oncomics-1.nci.nih.gov/images/"] mutableCopy];
    }
    if ([secondhtml rangeOfString:@"title="].location != NSNotFound) {
        NSArray *titles = [secondhtml componentsSeparatedByString:@"title="];
        int c = 0;
        NSMutableString *thirdhtml = [[NSMutableString alloc]init];
        for (NSString *str in titles) {
            if ([str isEqualToString:titles[0]]) {
                [thirdhtml appendString:str];
            } else {
                [thirdhtml appendString:[NSString stringWithFormat:@"id='%d' onclick='click(\"%d\")' title=", c, c]];
                [thirdhtml appendString:str];
                c++;
            }
        }
        [thirdhtml appendString:@"<script>function click(id) {var i = document.getElementById(id);document.getElementById(\"iphoneDiv\").innerHTML = i.title;}</script><div id=\"iphoneDiv\"></div>"];
        secondhtml = thirdhtml;
    }
    _currentHTML = secondhtml;
    _backHistory = [[NSMutableArray alloc]init];
    _forwardHistory = [[NSMutableArray alloc]init];
    _backLocation = -1;
    // we are done manipulating the html, now we load it into
    [_webView loadHTMLString:[secondhtml description] baseURL:nil];
    
    //add it to the subview
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView Navigation
// When users navigate within the webview we need to check if any manipulation needs to be done.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = request.URL;
    NSString *urlPath = [url absoluteString];
    // if the url isn't blank we will do what we can to make it better formatted for mobile
    if(![urlPath  isEqual: @"about:blank"] && [urlPath rangeOfString:@"applewebdata"].location == NSNotFound) {
        NSString *transcriptHTML = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if ([transcriptHTML rangeOfString:@"500 Internal Server Error"].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"500 Internal Server Error" message:@"The server encountered an internal error or                              misconfiguration and was unable to complete your request."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        if ([transcriptHTML rangeOfString:@"login_submitted"].location != NSNotFound) {
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
            return NO;
        }
        // If they leave the nci-oncomics site they could be going anywhere, so there's no point in trying to manipulate things so the following
        // is onle done if they aren't
        if (navigationType == UIWebViewNavigationTypeLinkClicked && [urlPath rangeOfString:(@"http://nci-oncomics-1.nci.nih.gov/")].location != NSNotFound && [transcriptHTML rangeOfString:(@"<div class=heatmap>")].location != NSNotFound){
            // This part is exactly what we did when we first loaded this view and we're just doing it again because the user loaded another page on the website that requires the same manipulation. Check the viewDidLoad documentation for more information.
            NSArray* splittedArray= [transcriptHTML componentsSeparatedByString:@"<div class=heatmap>"];
            NSMutableString *secondhtml = [[NSMutableString alloc]init];
            if(splittedArray[1]){
                secondhtml = splittedArray[1];
            } else {
                return NO;
            }
            splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
            secondhtml = splittedArray[0];
            if([secondhtml rangeOfString:@"/images/"].location != NSNotFound) {
                secondhtml = [[secondhtml stringByReplacingOccurrencesOfString:@"/images/" withString:@"http://nci-oncomics-1.nci.nih.gov/images/"] mutableCopy];
            }
            if([transcriptHTML rangeOfString:(@"/help/")].location != NSNotFound){
                NSMutableString *fourthhtml = [[NSMutableString alloc]init];
                splittedArray = [secondhtml componentsSeparatedByString:@"/help/"];
                NSMutableArray *mutArray= [splittedArray mutableCopy];
                fourthhtml = [splittedArray[0] mutableCopy];
                [mutArray removeObjectAtIndex:0];
                for (NSString *key in mutArray) {
                    [fourthhtml appendString:(@"http://nci-oncomics-1.nci.nih.gov/help/")];
                    [fourthhtml appendString:(key)];
                }
                _backHTML = _currentHTML;
                _backLocation++;
                [_backHistory addObject:_currentHTML];
                _currentHTML = fourthhtml;
                [webView loadHTMLString:[fourthhtml description] baseURL:nil];
                return YES;
            }
            _backHTML = _currentHTML;
            _backLocation++;
            [_backHistory addObject:_currentHTML];
            _currentHTML = secondhtml;
            [webView loadHTMLString:[secondhtml description] baseURL:nil];
            return YES;
        }
        else if (navigationType == UIWebViewNavigationTypeLinkClicked && [urlPath rangeOfString:(@"http://nci-oncomics-1.nci.nih.gov/")].location != NSNotFound && [transcriptHTML rangeOfString:(@"<table class=\"detailpage\">")].location != NSNotFound) {
            NSArray* splittedArray= [transcriptHTML componentsSeparatedByString:@"<table class=\"detailpage\">"];
            NSMutableString *secondhtml = [[NSMutableString alloc]init];
            if(splittedArray[1]){
                secondhtml = splittedArray[1];
            } else {
                return NO;
            }
            splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
            secondhtml = splittedArray[0];
            NSMutableString *tableClass = [@"<div><table class=detailpage>" mutableCopy];
            [tableClass appendString:secondhtml];
            secondhtml = tableClass;
            NSMutableString *thirdhtml = [[NSMutableString alloc]init];
            thirdhtml = secondhtml;
            if([secondhtml rangeOfString:@"<img src=\""].location != NSNotFound) {
                splittedArray= [secondhtml componentsSeparatedByString:@"<img src=\""];
                thirdhtml = [splittedArray[0] mutableCopy];
                [thirdhtml appendString:@"<img src=\"http://nci-oncomics-1.nci.nih.gov/cgi-bin/"];
                [thirdhtml appendString:splittedArray[1]];
            }
            _backHTML = _currentHTML;
            _backLocation++;
            [_backHistory addObject:_currentHTML];
            _currentHTML = thirdhtml;
            [webView loadHTMLString:[thirdhtml description] baseURL:nil];
            return YES;
        }
        [[UIApplication sharedApplication] openURL: url];
        return NO;
//        _backHTML = _currentHTML;
//        _backLocation++;
//        [_backHistory addObject:_currentHTML];
//        _currentHTML = transcriptHTML;
//        return YES;
    }
    return YES;
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
