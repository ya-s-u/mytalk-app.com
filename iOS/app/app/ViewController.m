//
//  ViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//
/*
 *12:08 後藤 誉昌 確認用に単純なgetで認証無しで叩けるの作った！
 
 curl http://omoide.folder.jp/api/users/ping
 
 接続確認用に使って〜！
 12:10 後藤 誉昌 あとpost確認用に、
 
 http://omoide.folder.jp/api/users/ping2
 
 でpostのbody部分をそのまま返すからこれも確認用に使ってみて〜
 *
 *
 *
 *
 */

#import "ViewController.h"
#import "SignUpViewController.h"
#import "Validation.h"
//#import "SVProgressHUD.h"
#import "LUKeychainAccess.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mailAddress = _mailAddress;
@synthesize passWord = _passWord;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    //[self.view addGestureRecognizer:gestureRecognizer];
    //ボタンの角丸
    [[_login layer] setCornerRadius:5.0];
    [_login setClipsToBounds:YES];
}
- (IBAction)login:(id)sender {
    
   
    //NSLog(@"loginbutton");
    self.mailAddress = self.identification.text;
    NSString *mailString = self.mailAddress;
    self.passWord = self.password.text;
    NSString *passString = self.passWord;
    
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
        [request setTimeoutInterval:200];
        [request setHTTPShouldHandleCookies:FALSE];
        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
        //同期通信で送信
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        // デバッグ用
        //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSString *token = [dict objectForKey:@"response"];
        //NSLog(@"response is %@", token);
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                // エラー処理を行う。
                if (error.code == -1003) {
                    NSLog(@"not found hostname. targetURL=%@", url);
                } else if (-1019) {
                    NSLog(@"auth error. reason=%@", error);
                } else {
                    NSLog(@"unknown error occurred. reason = %@", error);
                }
                
            } else {
                NSInteger httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
                if (httpStatusCode == 404) {
                    NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                    // } else if (・・・) {
                    // 他にも処理したいHTTPステータスがあれば書く。
                    
                } else {
                    //NSLog(@"success request!!");
                    //NSLog(@"statusCode = %lu", ((NSHTTPURLResponse *)response).statusCode);
                    //NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
        if (status == 400) {
            self.message.text = @"IDまたはパスワードが間違っています。";
        } else if(status == 0){
            self.message.text = @"通信エラーです。";
        } else {
            //一度しか実行しないコードブロック
            static dispatch_once_t token;
            dispatch_once(&token, ^{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
            //クッキーをKeyChainに保存する
            [[LUKeychainAccess standardKeychainAccess] setObject:cookies forKey:@"cookie"];
                
                
                
                
            [self performSegueWithIdentifier:@"backLogin" sender:self];
                 });
        }
                }
            }
        }];
        
    }
}
/*
 *
 *  ログインボタンをクロスフェードする関数
- (void)makeClossFade{
    
    UIButton* button =
    [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
    [button setImage:currentImage forState:UIControlStateNormal];
    [self.view addSubView:button];
    
    UIImage* nextImage = [UIImage imageNamed:@"hoge.png"];
    //使用後にブロック内でメモリ解放するための__block宣言
    __block UIImageView* nextImageView =
    [[UIImageView alloc] initWithImage:nextImage];
    [nextImageView setAlpha:0.0f];
    [button addSubView:nextImageView];
    
    [UIView transitionWithView:button
                      duration:0.5
     //アニメーション設定
                       options:UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                        [nextImageView setAlpha:1.0f];
                    }
                    completion:^(BOOL finished){
                        [button setImage:nextImage
                                forState:UIControlStateNormal];
                        //メモリ解放
                        [nextImageView removeFromSuperview];
                        [nextImageView release];
                    }];
    
}
 */
- (IBAction)password:(id)sender {
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // ナビゲーションバー非表示
}
@end
