//
//  ViewController.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/3/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface ViewController : UIViewController <UITextFieldDelegate> {
    NSMutableData *_responseData;
}
//Login page
// Textfield for user to input their username
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
// textfield for user to input their password
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
// button to attempt a login with given information
@property (strong, nonatomic) IBOutlet UIButton *login;
// Label saying: Enter username and password
@property (strong, nonatomic) IBOutlet UILabel *usernamePrompt;
// Label saying: Username
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
// label saying: Password
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
// button that brings us to forgot password view
@property (strong, nonatomic) IBOutlet UIButton *forgotPassword;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// button that brings us to request account view
@property (strong, nonatomic) IBOutlet UIButton *requestAccount;
// string that holds value of usernameText
@property(strong, nonatomic) NSString *username;
// string that holds value of passwordText
@property(strong, nonatomic) NSString *password;
// string that holds value of server response
@property(strong, nonatomic) NSString *response;
extern NSString *globalURL;
@end
