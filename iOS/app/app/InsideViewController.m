//
//  InsideViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/16.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "InsideViewController.h"
#import "PagingScrollView.h"
#import "AppDelegate.h"
#define TABLE_WIDTH 320.f
@interface InsideViewController ()

@end

@implementation InsideViewController
int counts = 0;
int counts2 = 0;
int counts3 = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)pageScrollView {
    //NSLog(@"swipe %f, %f" ,scrollView.contentOffset.x, scrollView.frame.size.width);
    static NSInteger previousPage = 0;
    CGFloat pageWidth = pageScrollView.frame.size.width;
    float fractionalPage = pageScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed
        // Do your thing!
        NSLog(@"CHANGE PAGE NOW:%lu", page);
        previousPage = page;
        
        switch (page) {
            case 0:{
                // 0ページ目にきたときにしたい処理
                break;
            }
            case 1:{
                // 1ページ目にきたときにしたい処理
                break;
            }
            case 2:{
                // 2ページ目にきたときにしたい処理
                break;
            }
            default:
                break;
        }
        
    }
}
- (void)viewDidAppear:(BOOL)animated {
    
    int numberOfTables = 3;
    
    CGFloat height = self.view.bounds.size.height;
    CGRect tableBounds = CGRectMake(0.0f, 100.f, TABLE_WIDTH, height-100);
    CGRect labelBounds = CGRectMake(120.0f,65.0f,90,30);
    CGRect prevlabelBounds = CGRectMake(10.0f,65.0f,90,30);
    CGRect nextlabelBounds = CGRectMake(240.0f,65.0f,90,30);
    
    PagingScrollView *scrollView = [[PagingScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(TABLE_WIDTH * numberOfTables, height);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentOffset = CGPointMake(320, 0);
    [self.view addSubview:scrollView];

    CGRect tableFrame = tableBounds;
    CGRect labelFrame = labelBounds;
    CGRect prevlabelFrame = prevlabelBounds;
    CGRect nextlabelFrame = nextlabelBounds;
    tableFrame.origin.x = 0.f;
    for (int i = 0; i < numberOfTables; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        UILabel *prevlabel = [[UILabel alloc] initWithFrame:prevlabelFrame];
        UILabel *nextlabel = [[UILabel alloc] initWithFrame:nextlabelFrame];
        label.textColor = textColor;
        label.font = textFont;
        prevlabel.textColor = textColor;
        prevlabel.font = textFont;
        nextlabel.textColor = textColor;
        nextlabel.font = textFont;
        tableView = [[UITableView alloc] initWithFrame:tableFrame];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        switch (i) {
            case 0:
                prevlabel.text = @"2014年7月";
                label.text = @"2014年8月";
                nextlabel.text = @"2014年9月";
                break;
            case 1:
                prevlabel.text = @"2014年8月";
                label.text = @"2014年9月";
                nextlabel.text = @"2014年7月";
                break;
            case 2:
                prevlabel.text = @"2014年9月";
                label.text = @"2014年10月";
                nextlabel.text = @"2014年11月";
                break;
            default:
                break;
        }
        [scrollView addSubview:prevlabel];
        [scrollView addSubview:label];
        [scrollView addSubview:nextlabel];
        [scrollView addSubview:tableView];
        
        tableFrame.origin.x += TABLE_WIDTH;
        labelFrame.origin.x += TABLE_WIDTH;
        prevlabelFrame.origin.x += TABLE_WIDTH;
        nextlabelFrame.origin.x += TABLE_WIDTH;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)awakeFromNib {
    
    _prevmessages = [[NSArray alloc] initWithObjects:
                 @"Hello, how are you.",
                 @"I'm great, how are you?",
                 @"I'm fine, thanks. Up for dinner tonight?",
                 @"Glad to hear. No sorry, I have to work.",
                 @"Oh that sucks. A pitty, well then - have a nice day..",
                 @"Thanks! You too. Cuu soon.",
                 nil];
    _messages = [[NSArray alloc] initWithObjects:
                 @"Hello, how are you.",
                 @"I'm great, how are you?",
                 @"I'm fine, thanks. Up for dinner tonight?",
                 @"Glad to hear. No sorry, I have to work.",
                 @"Oh that sucks. A pitty, well then - have a nice day..",
                 @"Thanks! You too. Cuu soon.",
                 nil];
    _nextmessages = [[NSArray alloc] initWithObjects:
                 @"Hello, how are you.",
                 @"I'm great, how are you?",
                 @"I'm fine, thanks. Up for dinner tonight?",
                 @"Glad to hear. No sorry, I have to work.",
                 @"Oh that sucks. A pitty, well then - have a nice day..",
                 @"Thanks! You too. Cuu soon.",
                 nil];
    
    [super awakeFromNib];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    counts++;
    if(counts == 1){
        return [_prevmessages count];
    }else if(counts == 2){
        return [_messages count];
    } else {
        return [_nextmessages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)cellTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    static NSString* cellIdentifier;
    counts3++;
    if(counts3 == 1){
        cellIdentifier = @"prevmessagingCell";
    }else if(counts3== 2){
        cellIdentifier = @"messagingCell";
    } else {
        cellIdentifier = @"nextmessagingCell";
    }
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [cellTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    counts2++;
    if(counts2 == 1){
        CGSize messageSize = [PTSMessagingCell messageSize:[_prevmessages objectAtIndex:indexPath.row]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    }else if(counts2 == 2){
        CGSize messageSize = [PTSMessagingCell messageSize:[_messages objectAtIndex:indexPath.row]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    }else{
        CGSize messageSize = [PTSMessagingCell messageSize:[_nextmessages objectAtIndex:indexPath.row]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    }
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
    if (indexPath.row % 2 == 0) {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
    } else {
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
    }
    
    ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
    ccell.timeLabel.text = @"2012-08-29";
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if(selection){
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}    // Dispose of any resources that can be recreated.

@end
