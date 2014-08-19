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
#import "LUKeychainAccess.h"
#import "TalkSettingViewController.h"
#define TABLE_WIDTH 320.f
@interface InsideViewController ()

@end

@implementation InsideViewController
@synthesize talkID = _talkID;
@synthesize talkData = _talkData;
@synthesize messages = _messages;
int numberOfTables = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
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
    //scrollView.contentOffset = CGPointMake(320, 0);　初期位置の設定
    [self.view addSubview:scrollView];

    CGRect tableFrame = tableBounds;
    CGRect labelFrame = labelBounds;
    CGRect prevlabelFrame = prevlabelBounds;
    CGRect nextlabelFrame = nextlabelBounds;
    tableFrame.origin.x = 0.f;
    _tableViewArray = [NSMutableArray array];
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        [_tableViewArray addObject:tableView];
        
        if(i == 0){
            prevlabel.text = @"";
            label.text = [_timeLabelArray objectAtIndex:i];
            if(numberOfTables != 1) nextlabel.text = [_timeLabelArray objectAtIndex:i+1];
        } else if(i + 1 == numberOfTables) {
            prevlabel.text = [_timeLabelArray objectAtIndex:i-1];
            label.text = [_timeLabelArray objectAtIndex:i];
            nextlabel.text = @"";
        } else {
            prevlabel.text = [_timeLabelArray objectAtIndex:i-1];
            label.text = [_timeLabelArray objectAtIndex:i];
            nextlabel.text = [_timeLabelArray objectAtIndex:i+1];
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
- (void)getJSON
{
    NSArray *cookieTmp = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"cookie"];
    NSArray *cookie = [NSArray arrayWithObjects:[cookieTmp objectAtIndex:([cookieTmp count] - 1)], nil];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSError *e = nil;
    NSString *url = [NSString stringWithFormat:@"http://omoide.folder.jp/api/talks/%@",_talkID];
    // NSHTTPCookieを作成
    NSDictionary *header = [NSHTTPCookie requestHeaderFieldsWithCookies:cookie];
    
    //リクエストを生成
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20];
    [request setAllHTTPHeaderFields:header];
    
    //同期通信で送信
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"送信エラー");
    }
    
    //取得したレスポンスをJSONパース
    _talkData = [NSDictionary dictionary];
    _memberData = [NSDictionary dictionary];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSDictionary *token = [[dict objectForKey:@"response"] objectForKey:@"timeline"];
    _authour = [[[dict objectForKey:@"response"] objectForKey:@"head"] objectForKey:@"author"];
    _talkTitle = [[[dict objectForKey:@"response"] objectForKey:@"head"] objectForKey:@"title"];
    _icon = [[[dict objectForKey:@"response"] objectForKey:@"head"] objectForKey:@"icon"];
    _memberData = [[dict objectForKey:@"response"] objectForKey:@"member"];

    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
    //NSLog(@"token is %@", token2);
    NSLog(@"statuscode:%ld",status);
    _talkData = token;
    
    if (status == 400) {
        NSLog(@"受信エラー");
    }
    //cookieを取得しようとしてみる
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSArray *cookieReceived = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
    //cookieを取得できたら
    if([cookieReceived count] != 0){
        NSHTTPCookie *rescookie = [cookieReceived objectAtIndex:0];
        NSHTTPCookie *originalCookie = [cookie objectAtIndex:0];
        //SessionIDが変更があればCookieをKeyChainに保存する
        if(rescookie.value != originalCookie.value){
            [[LUKeychainAccess standardKeychainAccess] setObject:cookieReceived forKey:@"cookie"];
        }
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    numberOfTables = 0;
    
    [self getJSON];
    
    NSArray *yearKeys = [NSArray array];
    yearKeys = [_talkData allKeys];
    _timeLabelArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < [yearKeys count]; i++){  // 年
        NSArray *tempKeys = [NSArray array];
        tempKeys = [[_talkData objectForKey:[yearKeys objectAtIndex:i]] allKeys];
        tempKeys = [tempKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
            return a.intValue - b.intValue; // 該当年の月をソート
        }];
        for (NSUInteger j = 0; j < [tempKeys count]; j++){  // 月
            // テーブルビューの数を増やす
            numberOfTables++;
            // 上部ラベルの内容を配列に入れる
            [_timeLabelArray addObject:[NSString stringWithFormat:@"%@年%@月", [yearKeys objectAtIndex:i], [tempKeys objectAtIndex:j]]];
        }
    }
    
    NSArray *monthKeys = [NSArray array];
    monthKeys = [[_talkData objectForKey:[yearKeys objectAtIndex:0]] allKeys];
    monthKeys = [monthKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return a.intValue - b.intValue; // ソート
    }];
    
    
    messages = [NSMutableArray array];
    for (NSUInteger i = 0; i < [yearKeys count]; i++){  // 年
        NSArray *tempKeys = [NSArray array];
        tempKeys = [[_talkData objectForKey:[yearKeys objectAtIndex:i]] allKeys];
        tempKeys = [tempKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
            return a.intValue - b.intValue; // 該当年の月をソート
        }];
        for (NSUInteger j = 0; j < [tempKeys count]; j++){  // 月
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            NSDictionary *messageValues = [[_talkData objectForKey:[yearKeys objectAtIndex:i]] objectForKey:[tempKeys objectAtIndex:j] ];
            NSMutableArray *tempMessages = [NSMutableArray array];
            NSMutableArray *authourArray = [NSMutableArray array];
            NSMutableArray *timeDataArray = [NSMutableArray array];
            int index = 0;
            for (NSDictionary *data in messageValues) { // 各セルのデータ格納
                if([[data objectForKey:@"type"] isEqualToString:@"message"]){
                    [tempMessages addObject:[data objectForKey:@"value"]];
                } else {
                    [tempMessages addObject:[data objectForKey:@"type"]];
                }
                if([[data objectForKey:@"name"] isEqualToString:_authour]){
                    [authourArray insertObject:@"1" atIndex:index];
                } else {
                    [authourArray insertObject:[data objectForKey:@"name"] atIndex:index];
                }
                [timeDataArray insertObject:[data objectForKey:@"date"] atIndex:index];
                index++;
            }
            
            [tempDict setObject:tempMessages forKey:@"msg"];
            [tempDict setObject:authourArray forKey:@"authour"];
            [tempDict setObject:timeDataArray forKey:@"time"];
            
            [messages addObject:tempDict];
        }
    }
    NSLog(@"talkID : %@",_talkID);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger index = [_tableViewArray indexOfObject:tableView];
    if (index != NSNotFound) {
        return [[[messages objectAtIndex:index] objectForKey:@"msg" ] count];
    } else { // no
        NSLog(@"error");
        return [[[messages objectAtIndex:0] objectForKey:@"msg" ] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)cellTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    static NSString* cellIdentifier;
    cellIdentifier = @"messagingCell";
    /* トーク内画面でセルを区別する用途は今ん所ないので全て同じセルidentifier */
    PTSMessagingCell * cell = (PTSMessagingCell*) [cellTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    NSUInteger index = [_tableViewArray indexOfObject:cellTableView];
    if (index != NSNotFound) {
        if ([@"1" isEqualToString:[[[messages objectAtIndex:index] objectForKey:@"authour"] objectAtIndex:indexPath.row]]) {
            cell.sent = YES;
            cell.avatarImageView.image = [UIImage imageNamed:@"icon-user_22x22.png"];
            cell.nameLabel.text = @"admin";
        } else {
            cell.sent = NO;
            cell.avatarImageView.image = [UIImage imageNamed:@"icon-user_22x22.png"];
            cell.nameLabel.text = [[[messages objectAtIndex:index] objectForKey:@"authour"] objectAtIndex:indexPath.row];
        }
        
        cell.messageLabel.text = [[[messages objectAtIndex:index] objectForKey:@"msg"] objectAtIndex:indexPath.row];
        NSString *m = [[[[messages objectAtIndex:index] objectForKey:@"time"] objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(5, 2)];

        NSString *d = [[[[messages objectAtIndex:index] objectForKey:@"time"] objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(8, 2)];
        NSString *h = [[[[messages objectAtIndex:index] objectForKey:@"time"] objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(11, 2)];
        NSString *s = [[[[messages objectAtIndex:index] objectForKey:@"time"] objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(14, 2)];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@:%@",h,s];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@月%@日",m,d];
    } else { // no
        NSLog(@"error");
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger index = [_tableViewArray indexOfObject:tableView];
    if (index != NSNotFound) {
        CGSize messageSize = [PTSMessagingCell messageSize:[[[messages objectAtIndex:index] objectForKey:@"msg" ] objectAtIndex:indexPath.row]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
        } else { // no
        NSLog(@"error");
        CGSize messageSize = [PTSMessagingCell messageSize:[[[messages objectAtIndex:0] objectForKey:@"msg" ] objectAtIndex:indexPath.row]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"setting"]) {
        TalkSettingViewController *viewCon = segue.destinationViewController;
        viewCon.talkSettings = [NSMutableArray array];
        [viewCon.talkSettings addObject:_talkID];
        [viewCon.talkSettings addObject:_authour];
        [viewCon.talkSettings addObject:_talkTitle];
        [viewCon.talkSettings addObject:_icon];
        [viewCon.talkSettings addObject:_memberData];
    }
}
 

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
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
