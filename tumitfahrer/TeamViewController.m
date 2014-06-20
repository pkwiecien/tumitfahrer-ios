//
//  TeamViewController.m
//  tumitfahrer
//
//  Created by Pawel Kwiecien on 6/15/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamMemberCell.h"
#import "CircularImageView.h"
#import "ActionManager.h"

@interface TeamViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSArray *teamPhotos;
@property (nonatomic, strong) NSArray *aboutPersonArray;

@end

@implementation TeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.teamPhotos = [NSArray arrayWithObjects:[UIImage imageNamed:@"PawelPhoto"], [ActionManager imageWithColor:[UIColor grayColor]], [UIImage imageNamed:@"BehrozPhoto"], [UIImage imageNamed:@"SaqibPhoto"], [ActionManager imageWithColor:[UIColor grayColor]], [UIImage imageNamed:@"ShahidPhoto"], [UIImage imageNamed:@"LukasPhoto"], [UIImage imageNamed:@"AmrPhoto"], [UIImage imageNamed:@"AbiPhoto"], [UIImage imageNamed:@"DansenPhoto"], nil];
        self.aboutPersonArray = [NSArray arrayWithObjects:@"Pawel Kwiecien\nTask: Main developer of iOS app\nAbout: TUMitfahrer was for me a Master Thesis project.",@"Michael Schermann",@"Behroz Sikander",@"Saqib Javed",@"Anuradha Ganapathi",@"Shahid Aslam",@"Lukasz Kwiatkowski",@"Amr Arafat",@"Abhijith Srivatsav", @"Dansen Zhou", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamPhotos count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    if (!cell) {
        cell = [TeamMemberCell teamMemberCell];
    }
    
    CircularImageView *circularImageView = nil;
    UITextView *textView = nil;
    
    if (indexPath.row % 2 == 0) {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 120) image:[self.teamPhotos objectAtIndex:indexPath.row]];
        textView = [[UITextView alloc]initWithFrame:CGRectMake(140, 10, [UIScreen mainScreen].bounds.size.width - 150, 120)];
    } else {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 10, 120, 120) image:[self.teamPhotos objectAtIndex:indexPath.row]];
        textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 150, 120)];
    }
    textView.editable = NO;
    textView.selectable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [self.aboutPersonArray objectAtIndex:indexPath.row];
    textView.font = [UIFont systemFontOfSize:14];
    
    [cell addSubview:circularImageView];
    [cell addSubview:textView];
    
    return cell;
}



@end
