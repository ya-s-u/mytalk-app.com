//
//  ViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "ViewController.h"
#import "TabViewController.h"
#import "TalkTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mailAddress = _mailAddress;
@synthesize passWord = _passWord;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self setTextField:nil;
    NSLog(@"test");
    self.identification.delegate = self;
    self.password.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)login:(id)sender {
    NSLog(@"loginbutton");
    self.mailAddress = self.identification.text;
    NSString *mailString = self.mailAddress;
    self.passWord = self.password.text;
    NSString *passString = self.passWord;
    
    /*
     *  ここにJSONを生成してログインする処理を投げる。
     *  戻ってくる固有IDはTalkTableViewControllerにある
     *  (int)sessionIDに入れる。
    */
    
    
    // どちらかが何も入力されてない時
    // この辺の条件文はあとからメアドかどうかの判定、ログインが成功したかなど
    // を追加の上で書き換える
    if ([mailString length] == 0 || [passString length] == 0) {
        //nameString = @"World";
    } else {
        //ログインできた場合のみこっちを実行する
        [self performSegueWithIdentifier:@"loginOpen" sender:self];
    }
}
- (IBAction)identification:(id)sender {
}
- (IBAction)password:(id)sender {
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self.identification resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginOpen"]) {
        TabViewController *tvc = segue.destinationViewController;
        tvc.successFlag = YES;
    }
}



/*
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    self.mailAddress = self.identification.text;
    NSString *mailString = self.mailAddress;
    self.passWord = self.password.text;
    NSString *passString = self.passWord;
    if ([sender isEqualToString:@"loginOpen"]) {
        if (mailString length] == 0 || [passString length] == 0) {
            // 遷移する代わりの処理を書くこともできる。
            return NO;
        }
        NSLog(@"opensegue");
    }
    return YES;
}
 */

@end
