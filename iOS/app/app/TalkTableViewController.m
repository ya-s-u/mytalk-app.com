//
//  TalkTableViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkTableViewController.h"

#import "talk.h"

@interface TalkTableViewController (){
    NSDictionary *listDict;
    NSString* selectedImage;
}

@end

@implementation TalkTableViewController
@synthesize talks;
@synthesize sessionID = _sessionID;


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
    talks = [NSMutableArray arrayWithCapacity:20];
    
	Talk *talk = [[Talk alloc] init];
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
    
    //ゴーストセル(最後のセルだけ表示されない)
    [talks addObject:talk];
    talk = [[Talk alloc] init];
    talk.name = @"怪しいトーク2";
    talk.periodStart = 2031.3;
    talk.periodEnd = 2034.5;
	talk.member = 1;
	talk.icon = 4;
    talk.posts = 1111;

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
	periodStartLabel.text = [NSString stringWithFormat:@"%ld ", talk.periodStart];
    UILabel *periodEndLabel = (UILabel *)[cell viewWithTag:102];//終了年月
	periodEndLabel.text = [NSString stringWithFormat:@"%ld ", talk.periodEnd];
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



@end
