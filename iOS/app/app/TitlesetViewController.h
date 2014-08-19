//
//  TitlesetViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlesetViewController : UIViewController{

NSMutableArray * _data;
}
@property NSMutableArray * data;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *setButton;

@end
