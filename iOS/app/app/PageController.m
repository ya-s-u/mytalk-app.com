//
//  PageController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/10.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "PageController.h"
#import "ContentViewController.h"

@interface PageController ()

@end

@implementation PageController

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
    self.dataSource = self;
    self.delegate = self;
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    // タブの数
    return 5;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    // タブに表示するView、今回はUILabelを使用
    ViewPagerController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPagerController"];
    //activeTabIndex;
    UILabel* label = [UILabel new];
    label.text = [NSString stringWithFormat:@"Tab #%lu", (unsigned long)index];
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    // タブ番号に対応するUIViewControllerを返す
    // タブに対応するページを表示する部分
    ContentViewController* contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    contentViewController.labelText = [NSString stringWithFormat:@"Tab #%lu", index];
    return contentViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
