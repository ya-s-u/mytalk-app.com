//
//  TalkViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/13.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkViewController.h"
#import "AppDelegate.h"
#import "Talk.h"
#import "TalkTableViewCell.h"
#import "LUKeychainAccess.h"

@interface TalkViewController ()

@end

@implementation TalkViewController
@synthesize talks;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    //ナビゲーションバー表示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setHidesBackButton:YES];
}
/*
-(void) awakeFromNib{
    _talks = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        NSString *title = [NSString stringWithFormat:@"Item %d", i];
        [_talks addObject:title];
    }

}
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TalkCell"];
    //_tableView.dataSource = self;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //INITIALIZING
    //バーの色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.122 green:0.514 blue:0.800 alpha:1.000];
    //バーの文字色とフォント
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:15.0f]}];
    //戻るボタンの色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    // sessionIDを使って各種トーク情報を読み込んでテーブルに追加するとこ
    // 未ログイン時は何も表示しないようにする
    NSArray *cookie = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"cookie"];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSError *e = nil;
    NSString *url = @"http://omoide.folder.jp/api/talks";
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
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSDictionary *token = [dict objectForKey:@"response"];
    NSDictionary *talkData = [token objectForKey:@"Talk"];
    NSInteger status = [(NSHTTPURLResponse*)response statusCode];
    //NSLog(@"token is %@", talkData);
    NSLog(@"statuscode:%ld",status);
    //NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    if (status == 400) {
        NSLog(@"受信エラー");
    }
    //cookieを取得しようとしてみる
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:response.URL];
    //cookieを取得できたら
    if([cookies count] != 0){
        NSHTTPCookie *rescookie = [cookies objectAtIndex:0];
        //SessionIDが変更があればCookieをKeyChainに保存する
        if(rescookie.value != [cookie objectAtIndex:6])[[LUKeychainAccess standardKeychainAccess] setObject:cookies forKey:@"cookie"];
    }
    /*
     *  テーブルにJSONを流し込む部分
     */
    talks = [NSMutableArray arrayWithCapacity:20];
	Talk *talk;
    
    for (NSDictionary *data in talkData) {
        talk = [[Talk alloc] init];
        talk.name = [data objectForKey:@"title"];
        talk.periodStart = [self countOfDates:[data objectForKey:@"start"] end:[data objectForKey:@"end"]];
        talk.member = [[data objectForKey:@"member"] intValue];
        talk.icon = [[data objectForKey:@"icon"] intValue];
        talk.posts = [[data objectForKey:@"count"] intValue];
        [talks addObject:talk];
    }
    
    /*
     talk = [[Talk alloc] init];
     talk.name = @"おもしろトーク";
     talk.periodStart = @"2014-04-02 12:01:00";
     talk.periodEnd = @"2014-04-02 12:01:00";
     talk.member = 1;
     talk.icon = 1;
     talk.posts = 1111;
     
     [talks addObject:talk];
     talk = [[Talk alloc] init];
     talk.name = @"楽しげトーク";
     talk.periodStart = @"2014-04-02 12:01:00";
     talk.periodEnd = @"2014-04-02 12:01:00";
     talk.member = 1;
     talk.icon = 4;
     talk.posts = 1111;
     
     [talks addObject:talk];
     talk = [[Talk alloc] init];
     talk.name = @"怪しいトーク1";
     talk.periodStart = @"2014-04-02 12:01:00";
     talk.periodEnd = @"2014-04-02 12:01:00";
     talk.member = 1;
     talk.icon = 4;
     talk.posts = 1111;
     [talks addObject:talk];
     */
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// PropertyCellのセル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.talks count];
}
//
- (UIImage *)imageForIcon:(NSInteger)selecter
{
    //selecter=0ならばデフォルト画像
    if(selecter == 0){
        return [UIImage imageNamed:@"RoundIcons-Free-Set-01.png"];
    }else{
        NSString *imgName = [NSString stringWithFormat:@"%ld.png",selecter];
        return [UIImage imageNamed:imgName];
    }
	/*
    switch (selecter)
	{
		case 1: return [UIImage imageNamed:@"RoundIcons-Free-Set-01.png"];
		case 2: return [UIImage imageNamed:@"RoundIcons-Free-Set-02.png"];
		case 3: return [UIImage imageNamed:@"RoundIcons-Free-Set-03.png"];
		case 4: return [UIImage imageNamed:@"RoundIcons-Free-Set-04.png"];
		case 5: return [UIImage imageNamed:@"RoundIcons-Free-Set-05.png"];
	}
     */
	return nil;
}

// PropertyCellに吐き出して表示するセルの設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkTableViewCell *cell = (TalkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TalkCell"];
	Talk *talk = [self.talks objectAtIndex:indexPath.row];
    cell.titleLabel.text = talk.name;
	cell.periodLabel.text = [NSString stringWithFormat:@"%@ ", talk.periodStart];
	cell.icon.image = [self imageForIcon:talk.icon];
    cell.memberLabel.text = [NSString stringWithFormat:@"%ld ", talk.member];
    cell.postLabel.text = [NSString stringWithFormat:@"%ld ", talk.posts];
    
    /*
     UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
     av.backgroundColor = [UIColor clearColor];
     av.opaque = NO;
     av.image = [UIImage imageNamed:@"categorytab1.png"];
     cell.backgroundView = av;
     セルに背景画像を設定する
     */
    
    return cell;
}
//セルが選択された時の挙動
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // toViewController
    [self performSegueWithIdentifier:@"toInside" sender:self];
}
- (IBAction)swiching:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"Firstが選択されています");
            break;
            
        case 1:
            NSLog(@"Secondが選択されています");
            break;
            
        default:
            break;
    }
    
    
}
- (NSString *)countOfDates:(NSString *)startDay end:(NSString *)endDay{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
	[inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dateA = [inputDateFormatter dateFromString:startDay];
	NSDate *dateB = [inputDateFormatter dateFromString:endDay];
	NSTimeInterval  since = [dateB timeIntervalSinceDate:dateA];
	//NSLog(@"%f秒", since);
	//NSLog(@"%f分", since/60);
	//NSLog(@"%f時", since/(60*60));
	//NSLog(@"%f日", since/(24*60*60));
    if(since/(24*60*60) > 31){
        return [NSString stringWithFormat:@"%fヶ月",since/(24*60*60)/30];
    }else if(since/(24*60*60) > 365){
        return [NSString stringWithFormat:@"%f年",since/(24*60*60)/365];
    }else if(since/(24*60*60) < 31){
        return [NSString stringWithFormat:@"%f日",since/(24*60*60)];
    }else{
        return [NSString stringWithFormat:@"%f時間",since/(60*60)];
    }
}
@end
