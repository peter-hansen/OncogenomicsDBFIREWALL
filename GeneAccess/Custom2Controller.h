//
//  Custom2Controller.h
//  Oncogenomics DB
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 7/30/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Custom2Controller : UIViewController <NSURLConnectionDelegate>
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSString *sampleFeature;
@end
