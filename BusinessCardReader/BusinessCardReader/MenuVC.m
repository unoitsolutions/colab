//
//  MenuVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "MenuVC.h"
#import "MenuCell.h"



@interface MenuVC ()

@property (nonatomic) CGFloat MenuCellHeight;

@end

@implementation MenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MenuTitleList = @[@"Scan a Card", @"Contacts", @"Share", @"Contact Us", @"About", @"Logout"];
    MenuIconList = @[@"scan_icn",@"contacts_icn",@"share_icn",@"contactus_icn",@"about_icn",@"logout_icn"];

    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.MenuCellHeight = ([[UIScreen mainScreen] bounds].size.height - 20) / 6;
    
//    self.tableView.backgroundColor = [[AETheme sharedInstance] defaultGrayColor];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor colorWithRed:35.0/256 green:107.0/256 blue:149.0/256 alpha:1.0];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:35.0/256 green:107.0/256 blue:149.0/256 alpha:1.0];
    }
    cell.selected = NO;
    
//    NSArray *menuImageList = @[@"menu_scan", @"menu_contacts", @"menu_share", @"menu_contactus", @"menu_about", @"menu_logout"];
    
    cell.textLabel.text = [MenuTitleList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[MenuIconList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.MenuCellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
    }
    
    self.selectedMenu = indexPath.row;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/menu/%i",self.selectedMenu]];
    
    if ([self.delegate respondsToSelector:@selector(menuVC:didSelectMenu:)]) {
        [self.delegate menuVC:self didSelectMenu:self.selectedMenu];
    }
}

@end
