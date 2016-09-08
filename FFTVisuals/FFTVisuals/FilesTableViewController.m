//
//  FilesTableViewController.m
//  FFTVisuals
//
//  Created by AntonioStilo on 28/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import "FilesTableViewController.h"
#import "FileManager.h"
#import "FileViewController.h"
#import "Global.h"

#define CELL_ID @"fileCell"

@interface FilesTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic) BOOL isEditing;

@end

@implementation FilesTableViewController

-(void)viewDidLoad
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.isEditing = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[FileManager sharedInstance] refershFilesList];
    self.data = [[[FileManager sharedInstance] metaFiles] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark UITableView

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[FileManager sharedInstance] deleteAudioFile:[self.data objectAtIndex:indexPath.row]];
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_ID];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:22];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = UIRandomColorLight;
    }
    
    NSDictionary *metadata = self.data[indexPath.row];
    
    cell.textLabel.text = [metadata valueForKey:kMetaDataTitle];
    cell.detailTextLabel.text = [metadata valueForKey:kMetaDataDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"fileSegueIn" sender:[self.data objectAtIndex:indexPath.row]];
}

-(IBAction)setEdit
{
    self.isEditing = !self.isEditing;
    self.tableView.editing = self.editing;
}

#pragma mark Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"fileSegueIn"]){
        FileViewController *vc = (FileViewController*)segue.destinationViewController;
        vc.metadata = (NSDictionary*)sender;
    }
}

@end
