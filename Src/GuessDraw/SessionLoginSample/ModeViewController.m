//
//  ModeViewController.m
//  GuessDraw
//
//  Created by Shen Tianmeng on 2013/03/28.
//  Copyright (c) 2013年 Shen Tianmeng. All rights reserved.
//

#import "ModeViewController.h"
#import "DrawViewController.h"
#import "GuessViewController.h"
#import "ViewViewController.h"

@interface ModeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *modeGuessButton;
@property (strong, nonatomic) IBOutlet UIButton *modeDrawButton;
@property (strong, nonatomic) IBOutlet UIButton *modeViewButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;



- (IBAction)pushedGuessMode:(id)sender;
- (IBAction)pushedDrawMode:(id)sender;
- (IBAction)pushedViewMode:(id)sender;



@end

@implementation ModeViewController
@synthesize modeDrawButton = _modeDrawButton;
@synthesize modeGuessButton = _modeGuessButton;
@synthesize modeViewButton = _modeViewButton;


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
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view, typically from a nib.
    [self.modeDrawButton.titleLabel setFont:[UIFont fontWithName:@"HoboStd" size:40.0]];
    [self.modeGuessButton.titleLabel setFont:[UIFont fontWithName:@"HoboStd" size:40.0]];
    [self.modeViewButton.titleLabel setFont:[UIFont fontWithName:@"HoboStd" size:40.0]];
    
    UIImage* bgImage = [UIImage imageNamed: @"brown.png"];
    [bgImage drawInRect:CGRectMake(0, 0, self.navBar.frame.size.width, self.navBar.frame.size.height)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];


    /////UINavigation Itemの設定/////
    //タイトルフォント設定
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //背景色指定
    label.backgroundColor = [UIColor clearColor];
    //フォントサイズ指定
    label.font = [UIFont fontWithName:@"HoboStd" size:28.0];
    //フォントをセンタリングする
    label.textAlignment = NSTextAlignmentCenter;
    //フォントの色指定
    label.textColor =[UIColor whiteColor];
    //タイトルテキスト指定
    label.text = @"Guess Draw    ";
    //UINavigationItemの titleViewにラベルを挿入
    self.navItem.titleView = label;
    

    /////listicon画像表示/////
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"listicon.png"]
                          forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(tapListicon) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navItem.leftBarButtonItem = buttonItem;
    
    /////ボタン位置調整/////
    CGRect r = [[UIScreen mainScreen] applicationFrame];
    CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    CGFloat btn_h = (h - self.navBar.frame.size.height)/3;
    
    self.modeDrawButton.frame = CGRectMake(0,self.navBar.frame.size.height,w,btn_h);
    self.modeGuessButton.frame = CGRectMake(0,self.navBar.frame.size.height + btn_h,w,btn_h);
    self.modeViewButton.frame = CGRectMake(0,self.navBar.frame.size.height + 2*btn_h,w,btn_h);


}

- (void) tapListicon{
    NSLog(@"tap");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushedGuessMode:(id)sender {
    GuessViewController *guessView = [[GuessViewController alloc] initWithNibName:@"GuessViewController" bundle:nil];
    [self presentViewController:guessView animated:YES completion:NO];

}

- (IBAction)pushedDrawMode:(id)sender {
    
    DrawViewController *drawView = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    [self presentViewController:drawView animated:YES completion:NO];
}

- (IBAction)pushedViewMode:(id)sender {
    ViewViewController *viewView = [[ViewViewController alloc] initWithNibName:@"ViewViewController" bundle:nil];
    [self presentViewController:viewView animated:YES completion:NO];
}

@end
