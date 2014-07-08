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
#import "Validation.h"

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
     *  (NSInteger)sessionIDに入れる。
    */
    
    Validation *mv = [[Validation alloc] init];
    NSString *errorMsgMail = [mv mailaddressValid:mailString];
    NSString *errorMsgPass = [mv passwordValid:passString];
    if (mailString.length == 0 || passString.length == 0) {
        self.message.text = @"全ての項目を入力してください。";
    } else if([errorMsgMail length] > 1){
        self.message.text = errorMsgMail;
    } else if([errorMsgPass length] > 1){
        self.message.text = errorMsgPass;
    } else {
        //Validation通過
        
        NSString *orign = @"http://www.filltext.com";
        NSString *url = [NSString stringWithFormat:@"%@/?rows=1&fname=%@&lname=%@&pretty=true",orign,mailString,passString];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //NSArray *array = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        //NSMutableArray *data = [NSMutableArray array];
        //NSString *sessionStr = [data objectAtIndex:0];
        //NSLog(@"sessionStr : %@", sessionStr);
        
        /*if([sessionStr length] == 0){
         //ログインに失敗
         } else {
         //sessionIDを保存
         [NSKeyedArchiver archiveRootObject:sessionStr toFile:[self filePath]];
         
         }*/
        [self performSegueWithIdentifier:@"loginOpen" sender:self];
    }
}
- (IBAction)identification:(id)sender {
}
- (IBAction)password:(id)sender {
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
