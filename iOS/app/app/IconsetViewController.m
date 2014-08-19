//
//  IconsetViewController.m
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "IconsetViewController.h"
#import "LUKeychainAccess.h"
#import "PutRequester.h"

@interface IconsetViewController ()

@end

@implementation IconsetViewController
@synthesize data = _data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _icons = [NSMutableArray array];
    for(NSUInteger i = 0; i <= 200; i++){
        [_icons addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%lu.png",i]]];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [_icons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.576 green:0.576 blue:0.576 alpha:1.0];;
    UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
    icon.image = [_icons objectAtIndex:indexPath.row];
    
    if([[_data objectAtIndex:1] intValue] == indexPath.row){
        [cell setSelected:YES];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[NSString alloc] init];
    PutRequester *pr = [[PutRequester alloc] init];
    NSInteger res = [pr putJSON:[NSString stringWithFormat:@"%lu",indexPath.row] puttingType:0 talkID:[_data objectAtIndex:0]];
    //NSInteger res = [self putJSON:[NSString stringWithFormat:@"%lu",indexPath.row] puttingType:0];
    if(res == 0){
        [_data replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%lu",indexPath.row]];
        message = @"選択したアイコンに設定しました．";
    } else {
        message = @"アイコンを変更できませんでした．";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
