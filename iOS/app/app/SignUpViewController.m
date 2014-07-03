//
//  SignUpViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/02.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "SignUpViewController.h"
#import "TabViewController.h"

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
     * ここにサインアップの処理を書く
     */
    
    NSString *orign = @"http://www.filltext.com";
    NSString *url = [NSString stringWithFormat:@"%@/?rows=1&fname=%@&lname=%@&pretty=true",orign,mailString,passString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"1stParameter：%@　2ndParameter：%@", [array valueForKeyPath:@"fname"],
          [array valueForKeyPath:@"lname"]);
    
    
    
    if ([mailString length] == 0 || [passString length] == 0) {
        //nameString = @"World";
    } else {
        //サインアップできた場合のみこっちを実行する
        [self performSegueWithIdentifier:@"signupOpen" sender:self];
    }
    
    
    
}
//無条件でログイン画面へ移動セグエ
- (IBAction)toLogin:(id)sender {
    [self performSegueWithIdentifier:@"toLogin" sender:self];
}
//サインアップできたときに戻ってこないため
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
