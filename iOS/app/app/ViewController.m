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
#import "SVProgressHUD.h"
#import "LUKeychainAccess.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mailAddress = _mailAddress;
@synthesize passWord = _passWord;
//@synthesize statusCode = _statusCode;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    //ボタンの角丸
    [[_login layer] setCornerRadius:5.0];
    [_login setClipsToBounds:YES];
    //バーの色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.000 green:0.682 blue:0.937 alpha:1.000];
    //バーの文字色
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	//戻るボタンの色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];

    
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
        //[SVProgressHUD show];

        //Validation通過
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
        
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
            self.message.text = @"通信エラー";
            //[SVProgressHUD dismiss];
            return;
        }
        //取得したレスポンスをJSONパース
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSString *token = [dict objectForKey:@"response"];
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        //NSLog(@"response is %@", token);
        NSLog(@"statuscode:%ld",status);
        if (status == 400) {
            self.message.text = @"通信エラー";
            //[SVProgressHUD dismiss];
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
        //クッキーをKeyChainに保存する
        [[LUKeychainAccess standardKeychainAccess] setObject:cookies forKey:@"cookie"];
        //[SVProgressHUD dismiss];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backLogin"]) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        appDel.successFlag = YES;
        
    }
}

- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // ナビゲーションバー非表示
}
@end
