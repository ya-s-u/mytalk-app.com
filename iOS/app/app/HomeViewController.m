//
//  HomeViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/12.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "HomeViewController.h"

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
