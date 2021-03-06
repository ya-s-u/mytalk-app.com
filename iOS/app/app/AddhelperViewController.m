//
//  AddhelperViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/20.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//
/*
 背景はグレー一色じゃなくて，このビューの背景画像に角丸の四角い画像など指定してウィンドウっぽくすると見栄えが良くなりそう
*/

#import "AddhelperViewController.h"
#import "AppDelegate.h"
#define kNumberOfPages 3


@interface AddhelperViewController ()

@end

@implementation AddhelperViewController
@synthesize scrollView = _scrollView;
@synthesize pageControll = _pageControll;

-(void)awakeFromNib
{
    _summaryText = [NSArray arrayWithObjects:
                    @"あいうと",
                    @"かきくけ",
                    @"さしせう",
                    nil
                    ];
    _summaryTitle = [NSArray arrayWithObjects:
                     @"taitoru",
                     @"たいとる",
                     @"あいうえおあうえお",
                     nil
                     ];
}
// pageControlの左右がタップされたときに呼ばれる
// scrollViewのスクロール位置をズラして表示を変える
- (void)pageControlDidChange:(UIPageControl *)sender
{
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * sender.currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

// scrollViewが指で左右にスワイプされたときに呼ばれる
// pageControlの現在ページの表示位置を変更する
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    if (fmod(_scrollView.contentOffset.x, pageWidth) == 0.0) {
        int pageNum = _scrollView.contentOffset.x / pageWidth;
        _pageControll.currentPage = pageNum;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // UIPageControlをセットアップする
    // storyboardで配置していても、これをやらないと表示されない。。
    [self.view addSubview:_pageControll];
    [_pageControll addTarget:self action:@selector(pageControlDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // UIScrollViewをセットアップする
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*kNumberOfPages, _scrollView.frame.size.height);
    // ページごとにUIViewControllerを生成し、view.frameをズラしながらaddSubviewする
    CGSize size = _scrollView.frame.size;
    for (int i=0; i<kNumberOfPages; i++) {
        // TODO ここでは適当にページ番号のラベルを表示させている
        // 実際はページ数ごとに辞書の配列でも作って持っておいて、ここでそのデータを元に生成する
        UIViewController *pageSubView = [[UIViewController alloc] init];
        pageSubView.view.frame = CGRectMake(size.width*i, 0, size.width, size.height);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size.width-200)/2, 30, 200, 30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:textTitleFont];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((size.width-200)/2, 70, 200, 60)];
        [contentLabel setTextAlignment:NSTextAlignmentCenter];
        [contentLabel setFont:textFont];
        contentLabel.numberOfLines = 3;
        
        label.text = [_summaryTitle objectAtIndex:i];
        contentLabel.text = [_summaryText objectAtIndex:i];
        
        [[pageSubView view] addSubview:label];
        [[pageSubView view] addSubview:contentLabel];
        [_scrollView addSubview:pageSubView.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
