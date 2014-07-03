//
//  SignUpViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/02.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (copy, nonatomic) NSString *mailAd;
@property (copy, nonatomic) NSString *passWd;
@end
