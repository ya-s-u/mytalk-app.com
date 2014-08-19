//
//  AuthorsetTableViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "AuthorsetTableViewController.h"
#import "PutRequester.h"

@interface AuthorsetTableViewController ()

@end

@implementation AuthorsetTableViewController
@synthesize data = _data;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_data objectAtIndex:2] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [[[_data objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"name"];
    if([cell.textLabel.text isEqualToString:[_data objectAtIndex:1]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _author = indexPath;
        NSLog(@"match");
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PutRequester *pr = [[PutRequester alloc] init];
    NSString *message = [[NSString alloc] init];
    NSInteger res = [pr putJSON:[[[_data objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"name"]
                    puttingType:1 talkID:[_data objectAtIndex:0]];
    NSLog(@"send");
    if(res == 0){
        message = @"選択した名前に設定しました．";
        _author = indexPath;
        [_data replaceObjectAtIndex:1 withObject:[[[_data objectAtIndex:2] objectAtIndex:indexPath.row] objectForKey:@"name"]];
    } else {
        message = @"名前を変更できませんでした．";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    [tableView reloadData];
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    
    if (path.row != _author.row)
    {
        return path;
    }
    return nil;
}


@end
