//
//  GuessViewController.m
//  GuessDraw
//
//  Created by Shen Tianmeng on 2013/03/30.
//  Copyright (c) 2013年 Shen Tianmeng. All rights reserved.
//

#import "GuessViewController.h"

@interface GuessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *guessPic;
@property (weak, nonatomic) IBOutlet UILabel *letsLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;
@property (weak, nonatomic) IBOutlet UIView *bot_view;
@property (weak, nonatomic) IBOutlet UIView *ind_view;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ind;
@property (weak, nonatomic) IBOutlet UITextField *tf;






@end

@implementation GuessViewController

@synthesize pic_url;
@synthesize ww;
@synthesize hh;
@synthesize floid;
@synthesize fid;
@synthesize err_num;

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
    
    [self initialize];
    
}

- (void)initialize{
    //initialize//
    self.letsLabel.font = [UIFont fontWithName:@"HoboStd" size:30.0];
    //インジケータくるくる
    [self.ind startAnimating];
    //インジケータ隠す
    self.ind_view.hidden = true;

    /////bottom位置調整/////
    CGRect r = [[UIScreen mainScreen] applicationFrame];
    ww = r.size.width;
    hh = r.size.height;
    NSLog(@"height:%lf",hh);
    self.bot_view.frame = CGRectMake(0,hh - 44,ww,44);
    //navigationbar色設定
    UIImage* bgImage = [UIImage imageNamed: @"brown.png"];
    [bgImage drawInRect:CGRectMake(0, 0, self.naviBar.frame.size.width, self.naviBar.frame.size.height)];
    [self.naviBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.letsLabel.font = [UIFont fontWithName:@"HoboStd" size:30.0];
    /////backicon画像表示/////
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [customView setBackgroundImage:[UIImage imageNamed:@"backward.png"]
                          forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(tapBackicon) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.naviItem.leftBarButtonItem = buttonItem;
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
    label.text = @"Guess   ";
    //UINavigationItemの titleViewにラベルを挿入
    self.naviItem.titleView = label;
    
    // ソフトキーボードの表示、非表示の通知を登録する
    NSNotificationCenter *center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keybaordWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //キーボード設定
    self.tf.keyboardType = UIKeyboardTypeDefault;
    self.tf.returnKeyType = UIReturnKeyDone;
    self.tf.delegate = self;

    //アプリがアクティブになった時のnotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeAct)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self download];
}

- (void)becomeAct{
    NSLog(@"become act");
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
}

- (void)viewDidUnload{
//    [self setCheckLabel:nil];
    [self setGuessPic:nil];
//    [self setNameData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapBackicon{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
}

- (void) netError{
    NSLog(@"netError");
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"通信エラー" message:@"通信状況を確認してください。"
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
    
}

- (void)download{
    self.ind_view.hidden = false;
    // 送信するリクエストを生成する。
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/get_pic.php"];
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
                [self netError];
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
                err_num = [[jsonObject objectForKey:@"error"] intValue];

                floid = [jsonObject objectForKey:@"flow_id"];
                NSLog(@"floid:%@",floid);
                NSLog(@"get_pic url:%@",[jsonObject objectForKey:@"pic_url"]);
                
                //local prepare
                //画像URLからUIImageを生成
                pic_url = [NSURL URLWithString:[jsonObject objectForKey:@"pic_url"]];
               

                //                [iv release];
                
                
                
                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (err_num == 1) {
                        // 生成と同時に各種設定も完了させる例
                        UIAlertView *alert =
                        [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"Guessできる画像がありませんでした。"
                                                  delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
                        [alert show];

                    }else{
                        // ここに何か処理を書く。
                        NSData *pic_data = [NSData dataWithContentsOfURL:pic_url];
                        UIImage *pic_img = [UIImage imageWithData:pic_data];
                        
                        
                        //UIImageViewにUIImageをセット
                        UIImageView *iv = [[UIImageView alloc] initWithImage:pic_img];
                        
                        //UIImageViewの位置（xy座標）を設定
                        iv.frame = CGRectMake(0, self.guessPic.frame.origin.y, pic_img.size.width, pic_img.size.height);
                        
                        //UIImageViewの設置とメモリ解放
                        [self.view addSubview:iv];
                        
                        UIImageView *binder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bind.png"]];
                        binder.frame = CGRectMake(0, self.guessPic.frame.origin.y, pic_img.size.width,17);
                        [self.view addSubview:binder];
                        
                        [self.bot_view removeFromSuperview];
                        [self.view addSubview:self.bot_view];

                        self.ind_view.hidden = true;
                    }
                });
                
            }
        }
    }];
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

- (void)keyboardWillShow:(NSNotification*)notification{
    NSLog(@"show");
    // キーボードの上にtextboxを移動
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat padding = hh - keyboardRect.size.height -44;
    NSLog(@"%lf",padding);
    [UIView
     animateWithDuration:0.25
     animations:^{
         self.bot_view.frame = CGRectMake(0,padding,ww,44);
     }
     ];
    //self.bot_view.frame = CGRectMake(0,(hh - keyboardRect.size.height)-44,ww,44);
    NSLog(@"%lf",keyboardRect.size.height);
}

- (void)keybaordWillHide:(NSNotification*)notification{
    NSLog(@"hide");
    [UIView
     animateWithDuration:0.25
     animations:^{
         self.bot_view.frame = CGRectMake(0,hh - 44,ww,44);
     }
     ];
     
}

- (void) sendToServer{
    NSLog(@"sending...");
    [self.tf resignFirstResponder];
    self.ind_view.hidden = false;
    
    //check FBID
    SLAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    fid = delegate.FBID;
    // 送信するリクエストを生成する。
    NSString *keyword = [self.tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self.tf.text length] > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/insert_title.php?flow_id=%@&fb_id=%@&title=%@",floid,fid,keyword]];
        NSLog(@"tf:%@",self.tf.text);
        NSLog(@"url:%@",url);
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
                
            } else {
                int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
                if (httpStatusCode == 404) {
                    NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
                    // } else if (・・・) {
                    // 他にも処理したいHTTPステータスがあれば書く。
                    
                } else {
                    NSLog(@"success request!!");
                    NSLog(@"statusCode = %d", ((NSHTTPURLResponse *)response).statusCode);
                    //NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    //NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding]);
                    //NSLog(@"responseText = %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                    //self.titleLabel.text = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                    
                    NSString *contents = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
                    NSData *tmp = [contents dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error=nil;
                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:tmp
                                                                               options:NSJSONReadingAllowFragments error:&error];
                    //self.checkLabel.text = [jsonObject objectForKey:@"pic_url"];
                }
            }
            // ここはサブスレッドなので、メインスレッドで何かしたい場合には
            dispatch_async(dispatch_get_main_queue(), ^{
                // ここに何か処理を書く。
                self.ind_view.hidden = true;
                [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
                
            });
        }];
    }else{
        NSLog(@"string is null");
    }
    
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ( touch.view.tag == 500 ){
        [self sendToServer];
    }else{
        [self.tf resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tf resignFirstResponder];
    [self sendToServer];
    return YES;
}




@end
