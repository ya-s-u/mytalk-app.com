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

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize mailAd = _mailAd;
@synthesize passWd = _passWd;
- (IBAction)mail:(id)sender {
}
- (IBAction)pass:(id)sender {
}
- (IBAction)signup:(id)sender {
    self.mailAd = self.mail.text;
    NSString *mailString = self.mailAd;
    self.passWd = self.pass.text;
    NSString *passString = self.passWd;
    /*
     * サインアップ処理ここから（暫定)
     * RequestHeaderを作る
     */
    
    NSString *orign = @"http://www.filltext.com";
    NSString *url = [NSString stringWithFormat:@"%@/?rows=1&fname=%@&lname=%@&pretty=true",orign,mailString,passString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *data = [NSMutableArray array];
    NSString *sessionStr = [data objectAtIndex:0];
    NSLog(@"sessionStr : %@", sessionStr);
    
    
    if ([mailString length] == 0 || [passString length] == 0) {
        //全ての項目を入力してください。
    } else if([sessionStr length] == 0){
        //ログインに失敗?
        
    } else {
        //サインアップできた場合のみこっちを実行する
        [self performSegueWithIdentifier:@"signupOpen" sender:self];
    }
    
    
    
}
//無条件でログイン画面へ移動セグエ
- (IBAction)toLogin:(id)sender {
    [self performSegueWithIdentifier:@"toLogin" sender:self];
}
//サインアップできたときに戻ってこないためのやつ
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signupOpen"]) {
        TabViewController *tvc = segue.destinationViewController;
        tvc.successFlag = YES;
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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
