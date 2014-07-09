//
//  SignUpViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/02.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "SignUpViewController.h"
#import "TabViewController.h"
#import "TalkTableViewController.h"
#import "Validation.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LUKeychainAccess.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize mailAd;
@synthesize passWd;

- (NSString* )filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"session.dat"];
    return filePath;
}
- (IBAction)mail:(id)sender {
}
- (IBAction)pass:(id)sender {
}
- (IBAction)signup:(id)sender {
    self.mailAd = self.mail.text;
    NSString *mailString = self.mailAd;
    self.passWd = self.pass.text;
    NSString *passString = self.passWd;
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
        NSHTTPURLResponse *response = nil;
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
            self.message.text = @"通信エラー";
            [SVProgressHUD dismiss];
            return;
        }
        
        
        //取得したレスポンスをJSONパース
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        NSString *token = [dict objectForKey:@"response"];
        NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        NSLog(@"response is %@", token);
        NSLog(@"statuscode:%ld",status);
        if (status == 400) {
            self.message.text = @"通信エラー";
            [SVProgressHUD dismiss];
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
        NSHTTPCookie *cookie = [cookies objectAtIndex:0];
        //SessionIDをKeyChainに保存する
        [[LUKeychainAccess standardKeychainAccess] setString:cookie.value forKey:@"sessionID"];
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"signupOpen" sender:self];
    }
}
//アカウントを持っている方はこちら
- (IBAction)toLogin:(id)sender {
    [self performSegueWithIdentifier:@"toLogin" sender:self];
}
//サインアップできたときに戻ってこないためのやつ
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"signupOpen"]) {
        AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
        appDel.successFlag = YES;
    }
}


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
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];

    if(appDel.successFlag == YES){
        [self performSegueWithIdentifier:@"signupOpen" sender:self];
    }
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    /*
    NSString *sessionStr = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    if([sessionStr length] != 0){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.sessionID = sessionStr;
        [self performSegueWithIdentifier:@"signupOpen" sender:self];
    }
     */
    // Do any additional setup after loading the view.
}
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
