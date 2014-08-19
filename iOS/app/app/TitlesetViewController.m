//
//  TitlesetViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TitlesetViewController.h"
#import "PutRequester.h"

@interface TitlesetViewController ()

@end

@implementation TitlesetViewController

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
    _textField.text = [_data objectAtIndex:1];
    
    
    
}
- (IBAction)send:(id)sender {
    PutRequester *pr = [[PutRequester alloc] init];
    NSString *message = [[NSString alloc] init];
    NSInteger res = [pr putJSON:_textField.text puttingType:2 talkID:[_data objectAtIndex:0]];
    if(res == 0){
        message = @"選択したタイトルに設定しました．";
    } else {
        message = @"タイトルを変更できませんでした．";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
