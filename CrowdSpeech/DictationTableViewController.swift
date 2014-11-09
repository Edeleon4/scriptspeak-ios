//
//  DictationTableViewController.swift
//  CrowdSpeech
//
//  Created by Eduardo de Leon on 11/9/14.
//  Copyright (c) 2014 Eduardo de Leon. All rights reserved.
//

import Foundation
//import BTBitesTableViewController.h
//import BTBiteDetailViewController.h
//import BTBiteTableViewCell.h
//import BTDeal.h
//import BTUser.h
//import BTApiClient.h
import UIKit

class DictationTableViewController : UITableViewController {
    let style : UITableViewStyle;

    override init(style: UITableViewStyle) {
        self.style = style;
    }
    <#properties and methods#>
    }

    - (void)viewDidLoad
        {
            [super viewDidLoad];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeals) name:@"reloadDeals" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeals) name:@"User-Signed-In" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDeals) name:@"User-Logged-In" object:nil];
            
            self.refreshControl = [[UIRefreshControl alloc]init];
            [self.tableView addSubview:refreshControl];
            [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
            
            self.dictations = [Dictation]()
            
            
            UIView *empty = [UIView new];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty.png"]];
            
            
            imageView.frame = CGRectMake(0, 0, imageView.frame.size.width*0.7, imageView.frame.size.height*0.7);
            
            imageView.center = CGPointMake(CGRectGetMidX(self.tableView.bounds),  (imageView.frame.size.height/2 + 70));
            
            [empty setAlpha:.5];
            
            [empty addSubview:imageView];
            self.tableView.nxEV_emptyView = empty;
            self.tableView.nxEV_hideSeparatorLinesWheyShowingEmptyView = YES;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [self reloadDeals];
            
    }
-(void) refreshTable {
    [self reloadDeals];
}


-(void) reloadDeals {
    [self reloadLoggedInDeals];
    }
    
    - (void) reloadLoggedInDeals {
        [[BTApiClient sharedClient] getDeals:@{} completion:^(NSDictionary *results, NSError *error) {
            if(error) {
                
            }
            else if (results[@"errors"]) {
                
            }
            else if(results[@"deals_users"]) {
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                
                NSMutableArray *bites = [NSMutableArray new];
                for( NSDictionary * params in results[@"deals_users"]) {
                    BTDeal *deal = [BTDeal dealFromNestedParams: params];
                    [bites insertObject:deal atIndex:0];
                }
                self.biteData = bites;
                [self.tableView reloadData];
            }
            
            [refreshControl endRefreshing];
            
        }];
        }
        
        - (void) reloadLoggedOutDeals {
            [[BTApiClient sharedClient] getLoggedOutDeals:@{} completion:^(NSDictionary *results, NSError *error) {
                if(error) {
                    
                }
                else if (results[@"errors"]) {
                    
                }
                else if(results[@"deals"]) {
                    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                    
                    NSMutableArray *bites = [NSMutableArray new];
                    for( NSDictionary * params in results[@"deals"]) {
                        BTDeal *deal = [BTDeal dealFromParams: params];
                        [bites insertObject:deal atIndex:0];
                    }
                    self.biteData = bites;
                    [self.tableView reloadData];
                }
                
                [refreshControl endRefreshing];
                
            }];
            }
            
            - (void)didReceiveMemoryWarning
                {
                    [super didReceiveMemoryWarning];
                    // Dispose of any resources that can be recreated.
            }
            
#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    }
*/
    func tableView(tableView:UITableView, numberOfSectionsInTableView section: Int)-> Int{
        return 1
    }

    /*
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.biteData count];
    }
*/
    // use as many rows as number of dictations
     func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.dictations.count
    }

/*
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTBiteTableViewCell *cell =  (BTBiteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    BTUser *user = [[BTApiClient sharedClient] currentUser];
    user.lattitude = 42.358453;
    user.longitude = -71.092093;
    
    BTDeal *deal = [biteData objectAtIndex:indexPath.row];
    
    cell.restaurantNameLabel.text = deal.restaurantName;
    [cell.descriptionTextView setText:deal.dealDescription];
    
    NSURL *imageURL = [NSURL URLWithString:deal.imageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    [cell.dealImageView setImage:[UIImage imageWithData:imageData]];
    
    });
    });
    
    if(deal.claimed) {
        [cell.statusLabel setText:@"(Claimed)"];
        [cell.statusLabel setHidden:NO];
    }
    else if(deal.notInterested) {
        [cell.statusLabel setText:@"(Not Interested)"];
        [cell.statusLabel setHidden:NO];
    }
    else {
        [cell.statusLabel setHidden:YES];
    }
    
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:deal.lattitude longitude:deal.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:user.lattitude longitude:user.longitude];
    
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.02f mi", [location1 distanceFromLocation:location2]/ 1609.344]];
    
    NSString *timeLeftString = [deal getTimeLeftString];
    
    [cell.expirationLabel setText: timeLeftString];
    
    if ([timeLeftString isEqualToString:@"Deal expired"]) {
        [cell.contentView setAlpha:.5];
    }
    else {
        [cell.contentView setAlpha:1];
    }
    
    return cell;
}
*/

// populate each cell
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath)->UITableViewCell{
    let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    
    // Get the corresponding candy from our candies array
    let dictation = self.dictations[indexPath.row]
    
    // Configure the cell
    cell.textLabel!.text = dictation.text
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell
}


