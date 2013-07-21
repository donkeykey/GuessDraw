//
//  ViewViewController.m
//  SessionLoginSample
//
//  Created by 川島 大地 on 13/07/20.
//
//

#import "ViewViewController.h"

@interface ViewViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigItem;
@property (weak, nonatomic) IBOutlet UIScrollView *sView;


@end

@implementation ViewViewController

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
    
    [self initialize];
    [self loadImage];
}

- (void) loadImage{
    // ここに何か処理を書く。
    NSURL *pic_url = [NSURL URLWithString:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/pic/test1.jpg"];
    NSData *pic_data = [NSData dataWithContentsOfURL:pic_url];
    UIImage *pic_img = [UIImage imageWithData:pic_data];
    
    
    //UIImageViewにUIImageをセット
    UIImageView *iv = [[UIImageView alloc] initWithImage:pic_img];
    
    //UIImageViewの位置（xy座標）を設定
    iv.frame = CGRectMake(20, 50, pic_img.size.width/3, pic_img.size.height/3);
    
    //UIImageViewの設置とメモリ解放
    [self.sView addSubview:iv];
    self.sView.contentSize = CGSizeMake(self.view.frame.size.width, iv.frame.size.height + self.navigBar.frame.size.height + 50);

}

- (void) initialize{
    // Do any additional setup after loading the view from its nib.
    //navigationbar色設定
    UIImage* bgImage = [UIImage imageNamed: @"brown.png"];
    [bgImage drawInRect:CGRectMake(0, 0, self.navigBar.frame.size.width, self.navigBar.frame.size.height)];
    [self.navigBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    /////backicon画像表示/////
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"backward.png"]
                          forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(tapBackicon) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigItem.leftBarButtonItem = buttonItem;
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
    label.text = @"View   ";
    //UINavigationItemの titleViewにラベルを挿入
    self.navigItem.titleView = label;
}
- (void)tapBackicon{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
