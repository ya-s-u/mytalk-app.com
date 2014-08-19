//
//  TalkSettingViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/18.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkSettingViewController.h"
#import "LUKeychainAccess.h"
#import "AppDelegate.h"
#import "IconsetViewController.h"

@interface TalkSettingViewController ()

@end

@implementation TalkSettingViewController
@synthesize talkSettings = _talkSettings;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _sectionList = [NSArray arrayWithObjects:@"アイコン", @"タイトル", @"自分", @"共有設定", nil];
    //_iconList = [NSArray arrayWithObjects:@"<#string#>" count:<#(NSUInteger)#>]; // アイコン名
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    [backButton setTitleTextAttributes:@{NSFontAttributeName : textFont} forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _sectionList = [NSArray arrayWithObjects:@"アイコン", @"タイトル", @"自分", @"共有設定", nil];
   
    NSArray *cookie = [[LUKeychainAccess standardKeychainAccess] objectForKey:@"cookie"];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSError *e = nil;
    NSString *url = [NSString stringWithFormat:@"http://omoide.folder.jp/api/talks/%@",[_talkSettings objectAtIndex:0]];
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
    [_talkSettings replaceObjectAtIndex:1 withObject:[[token objectForKey:@"head"] objectForKey:@"author"]];
    [_talkSettings replaceObjectAtIndex:2 withObject:[[token objectForKey:@"head"] objectForKey:@"title"]];
    [_talkSettings replaceObjectAtIndex:3 withObject:[[token objectForKey:@"head"] objectForKey:@"icon"]];
    
    [self.tableView reloadData];
    
    
    /* 共有設定のスイッチ
    UISwitch *sw = [[UISwitch alloc]init];
    sw.center = CGPointMake(100, 50);
    sw.on = YES;
    [sw addTarget:self action:@selector(switch_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0){
        
        UIImageView *icon = (UIImageView *)[cell viewWithTag:53];
        icon.image = [self imageForIcon:[[_talkSettings objectAtIndex:3] intValue]];
        
        UILabel *detail = (UILabel *)[cell viewWithTag:51];
        detail.text = [NSString stringWithFormat:@"%d:アイコン名",[[_talkSettings objectAtIndex:3] intValue]];
    } else if(indexPath.section == 1){
        UILabel *title = (UILabel *)[cell viewWithTag:50];
        title.text = [_talkSettings objectAtIndex:2];
    } else if(indexPath.section == 2){
        UILabel *title = (UILabel *)[cell viewWithTag:50];
        title.text = [_talkSettings objectAtIndex:1];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}
- (UIImage *)imageForIcon:(NSInteger)selecter
{
        NSString *imgName = [NSString stringWithFormat:@"%lu.png",selecter];
        return [UIImage imageNamed:imgName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"icon" sender:self];
    } else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"title" sender:self];
    } else if(indexPath.section == 2){
        [self performSegueWithIdentifier:@"authour" sender:self];
    } else {
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return (70);
    } else {
        return (35);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionList objectAtIndex:section];
}
- (void)switch_ValueChanged:(id)sender
{
    UISwitch *sw = sender;
    if (sw.on) {
        NSLog(@"スイッチがONになりました．");
    } else {
        NSLog(@"スイッチがOFFになりました．");
    }
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    
    if (path.section != 3)
    {
        return path;
    }
    return nil;
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"icon"]) {
        IconsetViewController *viewCon = segue.destinationViewController;
        viewCon.data = [NSMutableArray array];
        [viewCon.data addObject:[_talkSettings objectAtIndex:0]];
        [viewCon.data addObject:[_talkSettings objectAtIndex:3]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
