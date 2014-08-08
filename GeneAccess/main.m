    //
//  main.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/3/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
NSString *globalURL = @"http://nci-oncomics-1.nci.nih.gov/cgi-bin/JK_mock";
int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
