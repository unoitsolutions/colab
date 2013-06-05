//
//  ContactInfoVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/23/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactInfoVC.h"

@interface ContactInfoVC ()

@end

@implementation ContactInfoVC

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
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/contact/edit?contactId=%@",self.contact.contactID]];
    
    // logo
    UIImageView *view= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ateventIcon114"]];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    view.frame =  CGRectMake(0, 0, 32, 32);
    self.navigationItem.titleView = view;
    
    // edit button
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    
    // logo
//    [self.view setBackgroundColor:[[AETheme sharedInstance] defaultBackgroundColor]];
    self.cardImageView.image = self.contact.image;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",self.contact.firstName,(self.contact.lastName.length > 0 ? [NSString stringWithFormat:@" %@",self.contact.lastName] : @"" )];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.contact.job,self.contact.company];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setCardImageView:nil];
    [self setTableView:nil];
    [self setEditBarButton:nil];
    [self setTextLabel:nil];
    [self setDetailTextLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Action methods

- (IBAction)editBarButtonTapped:(id)sender
{
    
    if (self.mode == ContactInfoVCModeDefault) {
        self.mode = ContactInfoVCModeEdit;
        self.editBarButton.title = @"Done";
        
        self.textLabel.text = @"";
        self.detailTextLabel.text = @"";
    }else{
//        [[DBManager defaultManager] updateContact:self.contact];
        assert(NO);
        
        self.mode = ContactInfoVCModeDefault;
        self.editBarButton.title = @"Edit";
        
        self.textLabel.text = [NSString stringWithFormat:@"%@%@",self.contact.firstName,(self.contact.lastName.length > 0 ? [NSString stringWithFormat:@" %@",self.contact.lastName] : @"" )];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.contact.job,self.contact.company];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.mode == ContactInfoVCModeDefault) return 5;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mode != ContactInfoVCModeDefault) return (section == 0 ? 9 : 2);
    
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else if(section == 3){
        return 1;
    }else if(section == 4){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierEdit = @"CellEdit";
    
    if (self.mode == ContactInfoVCModeDefault) {
        NSUInteger section = indexPath.section;
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
//        cell.textLabel.textColor = [[AETheme sharedInstance] defaultMainColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
//        cell.detailTextLabel.textColor = [[AETheme sharedInstance] defaultDarkGrayColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        if(section == 0){
            if(indexPath.row == 0){
                cell.textLabel.text = @"Phone";
                cell.detailTextLabel.text = (self.contact.phone.length > 0 ? self.contact.phone : @" " );
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"Mobile";
                cell.detailTextLabel.text = (self.contact.mobile.length > 0 ? self.contact.mobile : @" " );
            }else if(indexPath.row == 2){
                cell.textLabel.text = @"Fax";
                cell.detailTextLabel.text = (self.contact.fax.length > 0 ? self.contact.fax : @" " );
            }
        }else if(section == 1){
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = (self.contact.email.length > 0 ? self.contact.email : @" " );
        }else if(section == 2){
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = (self.contact.address.length > 0 ? self.contact.address : @" " );
        }else if(section == 3){
            cell.textLabel.text = @"Web";
            cell.detailTextLabel.text = (self.contact.web.length > 0 ? self.contact.web : @" " );
        }else if(section == 4){
            if(indexPath.row == 0){
                cell.textLabel.text = @"Topic/s";
                cell.detailTextLabel.text = (self.contact.topicList.length > 0 ? self.contact.topicList : @" " );
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"Action/s";
                cell.detailTextLabel.text = (self.contact.followupList.length > 0 ? self.contact.followupList : @" " );
            }
        }
        
        return cell;
    }else{
        ELCTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierEdit];
        if (cell == nil){
            cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifierEdit];
            cell.delegate = self;
        }
        cell.indexPath = indexPath;
        
        if (indexPath.section == 0) {
            if(indexPath.row == 0){
                cell.leftLabel.text = @"Name";
                cell.rightTextField.text = [NSString stringWithFormat:@"%@%@",self.contact.firstName,(self.contact.lastName.length > 0 ? [NSString stringWithFormat:@" %@",self.contact.lastName] : @"" )];;
            }else if(indexPath.row == 1){
                cell.leftLabel.text = @"Phone";
                cell.rightTextField.text = self.contact.phone;
            }else if(indexPath.row == 2){
                cell.leftLabel.text = @"Mobile";
                cell.rightTextField.text = self.contact.mobile;
            }else if(indexPath.row == 3){
                cell.leftLabel.text = @"Fax";
                cell.rightTextField.text = self.contact.fax;
            }else if(indexPath.row == 4){
                cell.leftLabel.text = @"Company";
                cell.rightTextField.text = self.contact.company;
            }else if(indexPath.row == 5){
                cell.leftLabel.text = @"Job";
                cell.rightTextField.text = self.contact.job;
            }else if(indexPath.row == 6){
                cell.leftLabel.text = @"Address";
                cell.rightTextField.text = self.contact.address;
            }else if(indexPath.row == 7){
                cell.leftLabel.text = @"Email";
                cell.rightTextField.text = self.contact.email;
            }else if(indexPath.row == 8){
                cell.leftLabel.text = @"Web";
                cell.rightTextField.text = self.contact.web;
            }
        }else{
            if(indexPath.row == 0){
                cell.leftLabel.text = @"Topic/s";
                cell.rightTextField.text = self.contact.topicList;
            }else if(indexPath.row == 1){
                cell.leftLabel.text = @"Action/s";
                cell.rightTextField.text = self.contact.followupList;
            }
        }
        return cell;
    }
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - ELCTextFieldDelegate methods

- (BOOL)textFieldCell:(ELCTextFieldCell *)cell shouldReturnForIndexPath:(NSIndexPath*)indexPath withValue:(NSString *)string
{
    DLOG(@"indexPath: %i %i",indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            self.contact.firstName = string;
        }else if(indexPath.row == 1){
            self.contact.phone = string;
        }else if(indexPath.row == 2){
            self.contact.mobile = string;
        }else if(indexPath.row == 3){
            self.contact.fax = string;
        }else if(indexPath.row == 4){
            self.contact.company = string;
        }else if(indexPath.row == 5){
            self.contact.job = string;
        }else if(indexPath.row == 6){
            self.contact.address = string;
        }else if(indexPath.row == 7){
            self.contact.email = string;
        }else if(indexPath.row == 8){
            self.contact.web = string;
        }
    }else{
        if(indexPath.row == 0){
            self.contact.topicList = cell.rightTextField.text;;
        }else if(indexPath.row == 1){
            self.contact.followupList = cell.rightTextField.text;;
        }
    }
    return YES;
}

- (void)textFieldCell:(ELCTextFieldCell *)cell updateTextLabelAtIndexPath:(NSIndexPath *)indexPath string:(NSString *)string
{
    DLOG(@"indexPath: %i %i",indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            self.contact.firstName = string;
        }else if(indexPath.row == 1){
            self.contact.phone = string;
        }else if(indexPath.row == 2){
            self.contact.mobile = string;
        }else if(indexPath.row == 3){
            self.contact.fax = string;
        }else if(indexPath.row == 4){
            self.contact.company = string;
        }else if(indexPath.row == 5){
            self.contact.job = string;
        }else if(indexPath.row == 6){
            self.contact.address = string;
        }else if(indexPath.row == 7){
            self.contact.email = string;
        }else if(indexPath.row == 8){
            self.contact.web = string;
        }
    }else{
        if(indexPath.row == 0){
            self.contact.topicList = cell.rightTextField.text;;
        }else if(indexPath.row == 1){
            self.contact.followupList = cell.rightTextField.text;;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    return YES;
}

@end
