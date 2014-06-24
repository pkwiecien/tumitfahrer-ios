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
@property (nonatomic, strong) NSArray *shortAboutArray;
@property (nonatomic, strong) NSArray *longAboutArray;

@end

@implementation TeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.teamPhotos = [NSArray arrayWithObjects:[UIImage imageNamed:@"PawelPhoto.jpg"], [ActionManager imageWithColor:[UIColor grayColor]], [UIImage imageNamed:@"LukasPhoto.jpg"], [UIImage imageNamed:@"BehrozPhoto.jpg"], [UIImage imageNamed:@"SaqibPhoto.jpg"], [ActionManager imageWithColor:[UIColor grayColor]], [UIImage imageNamed:@"ShahidPhoto.jpg"], [UIImage imageNamed:@"AbiPhoto.jpg"], [UIImage imageNamed:@"AmrPhoto.jpg"], [UIImage imageNamed:@"DansenPhoto.jpg"], nil];        
        self.shortAboutArray = [NSArray arrayWithObjects:@"Pawel Kwiecien\nRole: Main developer of iOS app\nMotto: Life begins at the end of your comfort zone.",@"Michael Schermann\nRole:  Creative director\nMotto: When in danger, when in doubt, run in circles, scream, and shout.",@"Lukasz Kwiatkowski\nRole: UI/UX Designer, Photography, Marketing\nMotto: Creativity is doing something out of nothing", @"Behroz Sikander\nRole: Backend / VisioM developer\nAfter this project, I like Ruby more than Natalie Portman ;)",@"Hafiz Saqib Javed\nRole: Notification Engine/Pebble smartwatch developer",@"Anuradha Ganapathi\nRole: Web application developer\nMotto: Ruby is better than diamond.",@"Muhammad Shahid Aslam\nRole: Backend and Web application Developer\nMotto: Failure is not an option, it comes bundled with the software.",@"Abhijith Srivatsav\nRole: Android Developer\nMotto: There is no spoon.",@"Amr Arafat\nRole: Android Developer\nMotto: It’s not a Bug, It’s a feature *evil smile*", @"Dansen Zhou\nRole:  iOS, Android, Web application tester", nil];
        self.longAboutArray = [NSArray arrayWithObjects:@"TUMitfahrer was for me the final project for my Master Thesis. I developed complete iOS application and backend using Ruby on Rails. My research included innovative product development processes.", @"TUMitfahrer is an awesome project because the teams grew together on an innovative project. TUMitfahrer enabled the students to pursue their ideas while fulfilling their study requirements.",@"I took this project as my IDP. Personally i enjoyed that project because i could use my slightly artistic background in real application, to design something which students could enjoy.", @"TUMitfahrer was an awesome project that gave me the chance to work on multiple platforms. I learnt ROR, Android, iPhone, Java and C++ in a single project.",@"Getting an opportunity to work on a real time project with collaborative environment and multiple technologies, couldn’t get anything better. I took it as an IDP and really enjoyed working on Pebble and RoR.",@"I took this project as my IDP and it is an awesome experience and opportunity to learn new language like Ruby on Rails.", @"I took this project as IDP. I learned new things like how to use websockets for chat and how to develop responsive web application.",@"TUMitfahrer is my IDP, for which I’m responsible for the Android application. I’m the resident Android evangelist and the go-to guy for everything Android. The project gives me an opportunity to exercise my skills and experiment with app building techniques.", @"TUMitfahrer is an exciting project.  I learned a lot of stuff and had a lot of fun. I was on the Android team and I really enjoyed working on the project.",@"I took this project as my IDP. In this awesome project, I take charge of all the tests including unit test, ui automatic test, integration test, etc. It is both excited and painful to join all the different platforms with different environments, different programme languages.",  nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customLightGray];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.screenName = @"Team screen";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamPhotos count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    if (!cell) {
        cell = [TeamMemberCell teamMemberCell];
    }
    
    CircularImageView *circularImageView = nil;
    UITextView *shortTextView = nil;
    
    if (indexPath.row % 2 == 0) {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 120) image:[self.teamPhotos objectAtIndex:indexPath.row]];
        shortTextView = [[UITextView alloc]initWithFrame:CGRectMake(140, 10, [UIScreen mainScreen].bounds.size.width - 150, 120)];
    } else {
        circularImageView = [[CircularImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 10, 120, 120) image:[self.teamPhotos objectAtIndex:indexPath.row]];
        shortTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 150, 120)];
    }
    
    shortTextView.editable = NO;
    shortTextView.selectable = NO;
    shortTextView.backgroundColor = [UIColor clearColor];
    shortTextView.text = [self.shortAboutArray objectAtIndex:indexPath.row];
    shortTextView.font = [UIFont systemFontOfSize:14];
    shortTextView.scrollEnabled = NO;
    
    UITextView *longTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 130, [UIScreen mainScreen].bounds.size.width - 10, 120)];
    longTextView.editable = NO;
    longTextView.selectable = NO;
    longTextView.backgroundColor = [UIColor clearColor];
    longTextView.text = [self.longAboutArray objectAtIndex:indexPath.row];
    longTextView.font = [UIFont systemFontOfSize:14];
    longTextView.scrollEnabled = NO;

    [cell addSubview:circularImageView];
    [cell addSubview:shortTextView];
    [cell addSubview:longTextView];
    
    return cell;
}



@end
