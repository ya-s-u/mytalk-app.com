//
//  TalkTableViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkTableViewController.h"
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
- (UIImage *)imageForIcon:(int)selecter
{
	switch (selecter)
	{
		case 1: return [UIImage imageNamed:@"nav_icon_phone.png"];
		case 2: return [UIImage imageNamed:@"icon_talk1.png"];
		case 3: return [UIImage imageNamed:@"icon_talk1.png"];
		case 4: return [UIImage imageNamed:@"icon_talk1.png"];
		case 5: return [UIImage imageNamed:@"icon_talk1.png"];
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
	periodStartLabel.text = [NSString stringWithFormat:@"%d ", talk.periodStart];
    UILabel *periodEndLabel = (UILabel *)[cell viewWithTag:102];//終了年月
	periodEndLabel.text = [NSString stringWithFormat:@"%d ", talk.periodEnd];
	UIImageView * iconImageView = (UIImageView *)
    [cell viewWithTag:103];
	iconImageView.image = [self imageForIcon:talk.icon];//アイコン画像
    //talkの要素は{name,periodStart,periodEnd,shared,icon}
    
    return cell;
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
