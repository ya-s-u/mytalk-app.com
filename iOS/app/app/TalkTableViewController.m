//
//  TalkTableViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkTableViewController.h"
#import "LUKeychainAccess.h"
#import "talk.h"

@interface TalkTableViewController ()

@end

@implementation TalkTableViewController
@synthesize talks;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        talk.periodStart = [data objectForKey:@"start"];
        talk.periodEnd = [data objectForKey:@"end"];
        talk.member = [[data objectForKey:@"member"] intValue];
        talk.icon = [[data objectForKey:@"icon"] intValue];
        talk.posts = [[data objectForKey:@"count"] intValue];
        [talks addObject:talk];
    }
    
    /*
	talk.name = @"おもしろトーク";
    talk.periodStart = 2014.1;
    talk.periodEnd = 2014.5;
	talk.member = 1;
	talk.icon = 1;
    talk.posts = 1111;
    
    [talks addObject:talk];
	talk = [[Talk alloc] init];
	talk.name = @"楽しげトーク";
    talk.periodStart = 2011.5;
    talk.periodEnd = 2034.2;
	talk.member = 1;
	talk.icon = 4;
    talk.posts = 1111;
    
    [talks addObject:talk];
    talk = [[Talk alloc] init];
    talk.name = @"怪しいトーク1";
    talk.periodStart = 2031.3;
    talk.periodEnd = 2034.5;
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
    // Return the number of sections.
    return 1;
}
// PropertyCellのセル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.talks count];
}
//
- (UIImage *)imageForIcon:(NSInteger)selecter
{
	switch (selecter)
	{
		case 1: return [UIImage imageNamed:@"RoundIcons-Free-Set-01.png"];
		case 2: return [UIImage imageNamed:@"RoundIcons-Free-Set-02.png"];
		case 3: return [UIImage imageNamed:@"RoundIcons-Free-Set-03.png"];
		case 4: return [UIImage imageNamed:@"RoundIcons-Free-Set-04.png"];
		case 5: return [UIImage imageNamed:@"RoundIcons-Free-Set-05png"];
	}
	return nil;
}

// PropertyCellに吐き出して表示するセルの設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
    dequeueReusableCellWithIdentifier:@"TalkCell"];
	Talk *talk = [self.talks objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];//トーク名
	nameLabel.text = talk.name;
	UILabel *periodStartLabel = (UILabel *)[cell viewWithTag:101];//開始年月
	periodStartLabel.text = [NSString stringWithFormat:@"%@ ", [talk.periodStart substringToIndex:10]];
    UILabel *periodEndLabel = (UILabel *)[cell viewWithTag:102];//終了年月
	periodEndLabel.text = [NSString stringWithFormat:@"%@ ", [talk.periodEnd substringToIndex:10]];
	UIImageView * iconImageView = (UIImageView *)
    [cell viewWithTag:103];
	iconImageView.image = [self imageForIcon:talk.icon];//アイコン画像
    UILabel *memberLabel = (UILabel *)[cell viewWithTag:104];
    memberLabel.text = [NSString stringWithFormat:@"%ld ", talk.member];// メンバー数
    UILabel *postsLabel = (UILabel *)[cell viewWithTag:105];
    postsLabel.text = [NSString stringWithFormat:@"%ld ", talk.posts];//投稿数
    
    /*
     UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
     av.backgroundColor = [UIColor clearColor];
     av.opaque = NO;
     av.image = [UIImage imageNamed:@"categorytab1.png"];
     cell.backgroundView = av;
     セルに背景画像を設定する
    */
    
    
    
    //talkの要素は{name,periodStart,periodEnd,member,icon,posts}
    
    return cell;
}
//セルが選択された時の挙動
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // toViewController
    [self performSegueWithIdentifier:@"toInside" sender:self];
}

- (void)showLoginView {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpView"];// signupviewへ移動
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
