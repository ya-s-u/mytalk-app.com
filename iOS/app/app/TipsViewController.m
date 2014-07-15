//
//  TipsViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/12.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TipsViewController.h"
#define kNumberOfPages 11

@interface TipsViewController ()

@end

@implementation TipsViewController
@synthesize scrollView;
@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// pageControlの左右がタップされたときに呼ばれる
// scrollViewのスクロール位置をズラして表示を変える
- (void)pageControlDidChange:(UIPageControl *)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * sender.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    NSLog(@"pageControlDidChange, %lu", sender.currentPage);
}

// scrollViewが指で左右にスワイプされたときに呼ばれる
// pageControlの現在ページの表示位置を変更する
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if (fmod(scrollView.contentOffset.x, pageWidth) == 0.0) {
        int pageNum = scrollView.contentOffset.x / pageWidth;
        controller.currentPage = pageNum;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // UIPageControlをセットアップする
    [self.view addSubview:controller];
    [controller addTarget:self action:@selector(pageControlDidChange:) forControlEvents:UIControlEventValueChanged];
    //表示する内容を登録する
    NSArray *src = [NSArray arrayWithObjects:
                    @"OSアプリもしくはWEBサイト上から簡単にトークをアップロードできます。今あるトークに追加する事も可能です。",
                    @"保存できるトーク数に制限がなく、全て無料でご利用いただけます。トーク内容は全て自動でバックアップされます。",
                    @"トーク内容は暗号化したのち保存されます。サイト全体についても細心の注意を払いセキュリティ対策を施しています。", nil];
    
    // UIScrollViewをセットアップする
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*kNumberOfPages, scrollView.frame.size.height);
    CGSize size = scrollView.frame.size;
    for (int i=0; i<3; i++) {
        UIViewController *pageSubView = [[UIViewController alloc] init];
        pageSubView.view.frame = CGRectMake(size.width*i, 0, size.width, size.height);
        //TIPS関係のラベルの設定
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size.width-300)/2, 50, 300, 100)];
        [label setTextAlignment:UITextAlignmentCenter];
        label.numberOfLines = 3;
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        [label setFont:font];
        label.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:14];
        label.textColor = [UIColor whiteColor];
        label.text = [src objectAtIndex:i];
        [[pageSubView view] addSubview:label];
        [scrollView addSubview:pageSubView.view];
    }
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
