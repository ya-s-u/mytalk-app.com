//
//  HomeViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/12.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "HomeViewController.h"
#import "LUKeyChainAccess.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // ナビゲーションバー非表示
    [[_signup layer] setCornerRadius:5.0];
    [_signup setClipsToBounds:YES];
    [[_login layer] setCornerRadius:5.0];
    [_login setClipsToBounds:YES];
    //バーの色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.122 green:0.514 blue:0.800 alpha:1.000];
    //バーの文字色とフォント
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:15.0f]}];
    //戻るボタンの色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    // NavigationBar 表示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
