//
//  ViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>{
    NSInteger *statusCode;
}
@property (weak, nonatomic) IBOutlet UITextField *identification;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (copy, nonatomic) NSString *mailAddress;
@property (copy, nonatomic) NSString *passWord;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end
