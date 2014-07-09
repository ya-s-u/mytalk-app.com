//
//  ViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"
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
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSError *e = nil;
        
        NSString *param = [NSString stringWithFormat:@"address=%@&password=%@", mailString, passString];
        NSString *url = @"http://omoide.folder.jp/api/users/login/";
        
        //リクエストを生成
        NSMutableURLRequest *request;
        request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        [request setURL:[NSURL URLWithString:url]];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setTimeoutInterval:20];
        [request setHTTPShouldHandleCookies:FALSE];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        
        //同期通信で送信
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error!");
            return;
        }

        
        //取得したレスポンスをJSONパース
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        NSString *token = [dict objectForKey:@"response"];
        NSLog(@"Token is %@", token);
        
        
        /*if([sessionStr length] == 0){
         //ログインに失敗
         } else {
         //sessionIDを保存
         [NSKeyedArchiver archiveRootObject:sessionStr toFile:[self filePath]];
         
         }*/
        [self performSegueWithIdentifier:@"backLogin" sender:self];
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
    if ([segue.identifier isEqualToString:@"backLogin"]) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        appDel.successFlag = YES;
        
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
