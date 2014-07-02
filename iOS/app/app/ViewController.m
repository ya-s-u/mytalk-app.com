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
	// Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)login:(id)sender {
    NSLog(@"loginbutton");
    self.mailAddress = self.identification.text;
    NSString *mailString = self.mailAddress;
    self.passWord = self.password.text;
    NSString *passString = self.passWord;
     
    // どちらかが何も入力されてない時
    if ([mailString length] == 0 || [passString length] == 0) {
        //nameString = @"World";
    } else {
        [self performSegueWithIdentifier:@"loginOpen" sender:self];
    }
    //NSString *greeting = [[NSString alloc] initWithFormat:@"Hello, %@!",nameString];
    //self.label.text = greeting;
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
    if (theTextField == self.mailAddress) {
        [theTextField resignFirstResponder];
    }
    if (theTextField == self.passWord) {
        [theTextField resignFirstResponder];
    }
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
