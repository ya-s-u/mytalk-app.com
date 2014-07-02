//
//  TabViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/01.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TabViewController.h"


@interface TabViewController ()

@end

@implementation TabViewController
@synthesize successFlag = _successFlag;

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

}
/*
 * ログイン画面を表示する。
 */
- (BOOL)hasLoginSettings {
    if(_successFlag) return YES;
    else return NO;
    //NOでログインしてない
}
- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"agfeagewa");
    if (![self hasLoginSettings]) {
        [self showLoginView];
    }
}
- (void)showLoginView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpView"];// signupviewへ移動
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];
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
