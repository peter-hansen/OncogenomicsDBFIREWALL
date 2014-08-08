//
//  RequestAccountViewController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/5/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//  NOTE: AT THE TIME OF MY DEPARTURE THIS PAGE WAS NOT FUNCTIONAL, AND AS A RESULT
//  I AM UNABLE TO ACTUALLY MAKE THIS PAGE. WHEN IT DOES WORK, CONTACT ME AT phansen@terpmail.umd.edu
//  AND I'LL TRY TO IMPLEMENT IT.

#import "RequestAccountViewController.h"

@interface RequestAccountViewController ()

@end

@implementation RequestAccountViewController

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
- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
