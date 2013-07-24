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
@property (weak, nonatomic) IBOutlet UIView *indView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ind;



@end

@implementation ViewViewController
@synthesize async_data;
@synthesize conn;
@synthesize sView;

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
    //[self loadImage:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/pic/test3.jpg"];
}

-(void)loadImage:(NSString *)str {
    NSLog(@"loadImage:str=%@",str);
    NSURL *url = [NSURL URLWithString:str];
    //[self abort];
    async_data = [[NSMutableData alloc] initWithCapacity:0];
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ConnectionError" message:@"ConnectionError" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

// 接続開始
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // データを初期化
    NSLog(@"connection start");
    async_data = [[NSMutableData alloc] initWithData:0];
    self.indView.hidden = false;
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // データを追加する
    NSLog(@"connection loading");
    [async_data appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *error_str = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RequestError" message:error_str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"complete");
    self.indView.hidden = true;

    UIImage *getImg = [UIImage imageWithData:async_data];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:getImg];
    imgView.frame = CGRectMake(50, self.sView.contentSize.height, getImg.size.width/3, getImg.size.height/3);
    // 接続解放呼び出し
    [self abort];
    // 取得した画像を画面に表示
    [self.sView addSubview:imgView];
    self.sView.contentSize = CGSizeMake(self.view.frame.size.width, self.sView.contentSize.height + imgView.frame.size.height + self.navigBar.frame.size.height + 50);

}

// 通信用オブジェクトを解放
-(void)abort{
    NSLog(@"connection abort");

    if(conn != nil){
        [conn cancel];
        conn = nil;
    }
    if(async_data != nil){
        async_data = nil;
    }
}

/*
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
*/

- (void) initialize{
    // Do any additional setup after loading the view from its nib.
    [self.ind startAnimating];
    //完成した画像のURL一覧を取得
    [self download:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/get_comp_pic.php"];
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

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            break;
    }
    
}

- (void)download:(NSString *) str{
    self.indView.hidden = false;
    // 送信するリクエストを生成する。
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url);
            } else if (-1019) {
                NSLog(@"auth error. reason=%@", error);
            } else {
                NSLog(@"unknown error occurred. reason = %@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self netError];
            });
        } else {
            int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (httpStatusCode == 404) {
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                // } else if (・・・) {
                // 他にも処理したいHTTPステータスがあれば書く。
                
            } else {
                NSLog(@"success request!!");
                NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                
                
                NSString *contents = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
                NSData *tmp = [contents dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error=nil;
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:tmp
                                                                           options:NSJSONReadingAllowFragments error:&error];
                //self.checkLabel.text = [jsonObject objectForKey:@"pic_url"];
                NSLog(@"pic_url error:%@",[jsonObject objectForKey:@"error"]);
                //err_num = [[jsonObject objectForKey:@"error"] intValue];
                
                NSDictionary *comp_file = [jsonObject objectForKey:@"comp_file"];
                //NSLog(@"comp_file:%@",comp_file);


                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.indView.hidden = true;
                    for(id obj in comp_file){
                        [self loadImage:[NSString stringWithFormat:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/pic/complete/%@",obj]];
                    }
                });
                
            }
        }
    }];

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
