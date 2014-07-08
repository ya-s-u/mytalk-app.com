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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
