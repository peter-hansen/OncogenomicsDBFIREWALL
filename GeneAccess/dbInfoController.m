//
//  dbInfoController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/7/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "dbInfoController.h"

@interface dbInfoController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation dbInfoController
// Dismiss the view controller and go back to our original database page
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
// This method gets called every time the phone rotates and makes sure that the 
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
    NSArray* splittedArray= [_html componentsSeparatedByString:@"<div id=\"db_info\" style=\"width:700px\">"];
    // check to make sure the data we're looking for is there so the app doesn't crash
    NSMutableString *secondhtml = [[NSMutableString alloc]init];
    if([splittedArray count] > 1){
        secondhtml = splittedArray[1];
    } else {
        return;
    }
    // Earlier, we cut at the begging of <div class=heatmap>, now we're cutting off the bottom
    // so everything in the heatmap div should end up in secondhtml
    splittedArray= [secondhtml componentsSeparatedByString:@"<!-- footer wrapper -->"];
    secondhtml = splittedArray[0];

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
