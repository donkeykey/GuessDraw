//
//  DrawViewController.m
//  GuessDraw
//
//  Created by Shen Tianmeng on 2013/03/30.
//  Copyright (c) 2013年 Shen Tianmeng. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIImageView *bindImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *letsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
//@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *indicator_view;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;





- (IBAction)eraserButtonPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;
//- (IBAction)backButtonPressed:(id)sender;




@end

@implementation DrawViewController
@synthesize mainImage = _mainImage;
@synthesize tempDrawImage = _tempDrawImage;
@synthesize titleLabel = _titleLabel;
@synthesize letsLabel = _letsLabel;
@synthesize subj;
//@synthesize FBID = _FBID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [self setMainImage:nil];
    [self setTempDrawImage:nil];
    [super viewDidUnload];
    

    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)viewDidLoad
{
    [self initialize];
    
    // 送信するリクエストを生成する。
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/get_title.php"];
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
                //self.titleLabel.text = [jsonObject objectForKey:@"title"];
                //self.titleLabel.text = @"hoge";
                subj = [jsonObject objectForKey:@"title"];
                floid = [jsonObject objectForKey:@"flow_id"];
                NSLog(@"title:%@",subj);
                NSLog(@"floid:%@",floid);
                //self.titleLabel.text = subj;
                //self.indicator_view.hidden = true;
                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
                    //self.titleLabel.text = @"hoge";
                    self.titleLabel.text = subj;
                    self.indicator_view.hidden = true;
                });
            }
        }
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) initialize{
    
    //initialize//
    /////indicatorくるくる/////
    [self.indicator startAnimating];
    /////bottom位置調整/////
    CGRect r = [[UIScreen mainScreen] applicationFrame];
    CGFloat w = r.size.width;
    CGFloat h = r.size.height;
    NSLog(@"height:%lf",h);
    self.bottom_view.frame = CGRectMake(0,h - 44,w,44);
    /////canvas位置調整/////
    if (h == 568) {//iphone5用
        self.mainImage.frame = CGRectMake(0,h - 100 - self.mainImage.frame.size.height,w,self.mainImage.frame.size.height);
        self.tempDrawImage.frame = CGRectMake(0,h - 100 - self.tempDrawImage.frame.size.height,w,self.tempDrawImage.frame.size.height);
        self.bindImage.frame = CGRectMake(0,h - 100 - self.mainImage.frame.size.height,w,self.bindImage.frame.size.height);
    }else{
        self.mainImage.frame = CGRectMake(0,h - 60 - self.mainImage.frame.size.height,w,self.mainImage.frame.size.height);
        self.tempDrawImage.frame = CGRectMake(0,h - 60 - self.tempDrawImage.frame.size.height,w,self.tempDrawImage.frame.size.height);
        self.bindImage.frame = CGRectMake(0,h - 60 - self.mainImage.frame.size.height,w,self.bindImage.frame.size.height);
    }
    self.mainImage.userInteractionEnabled = YES;
    self.tempDrawImage.userInteractionEnabled = YES;
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
    label.text = @"Draw   ";
    //UINavigationItemの titleViewにラベルを挿入
    self.naviItem.titleView = label;
    
    /////////////////////////////
    
    //初期お絵かき色設定
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 5.0;
    opacity = 1.0;
}

- (void) netError{
    NSLog(@"netError");
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"通信エラー" message:@"通信状況を確認してください。"
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapBackicon{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
}
- (void)eraserButtonPressed {
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
}
- (void)penButtonPressed {
    red = 0/255.0;
    green = 0/255.0;
    blue = 0/255.0;
    opacity = 1.0;
}

- (IBAction)reset:(id)sender {
    
    self.mainImage.image = nil;
    
}


//send buttonを押すと，写真を送る．POSTDATAの作成とかそのへんは外に出して関数化してもいいかもしれない．

- (void)sendButtonPressed{
    self.indicator_view.hidden = false;

    NSData* jpegData = [[NSData alloc] initWithData:UIImageJPEGRepresentation( self.mainImage.image, 0.5 )];
    
    //ここからPOSTDATAの作成 insert_pic
    NSString *urlString = @"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/insert_pic.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------168072824752491622650073";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"pic\"; filename=\"user.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:jpegData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSError *error=nil;
    NSDictionary *jsonObject2 = [NSJSONSerialization JSONObjectWithData:returnData
                                                               options:NSJSONReadingAllowFragments error:&error];
//    self.titleLabel.text = [jsonObject objectForKey:@"title"];
    filename = [jsonObject2 objectForKey:@"file_name"];
    NSLog(@"filename:%@",filename);
    
    //check FBID
    SLAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    fid = delegate.FBID;
    NSLog(@"fid:%@",fid);
    [super viewDidLoad];
    
    
    //insert_pic_info
    // 送信するリクエストを生成する。
    NSURL *url_insert_pic_info = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-218-53-195.us-west-2.compute.amazonaws.com/guess_draw/api/insert_pic_info.php?flow_id=%@&file_name=%@&fb_id=%@",floid,filename, fid]];
    NSURLRequest *request_insert_pic_info = [[NSURLRequest alloc] initWithURL:url_insert_pic_info];
    
    // リクエストを送信する。
    // 第３引数のブロックに実行結果が渡される。
    [NSURLConnection sendAsynchronousRequest:request_insert_pic_info queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // エラー処理を行う。
            if (error.code == -1003) {
                NSLog(@"not found hostname. targetURL=%@", url_insert_pic_info);
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
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url_insert_pic_info);
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
  //              NSData *tmp = [contents dataUsingEncoding:NSUTF8StringEncoding];
  //              NSError *error=nil;
  //              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:tmp
    //                                                                       options:NSJSONReadingAllowFragments error:&error];
                //self.titleLabel.text = @"end";

                
                
                // ここはサブスレッドなので、メインスレッドで何かしたい場合には
                dispatch_async(dispatch_get_main_queue(), ^{
                    // ここに何か処理を書く。
                    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
                    self.indicator_view.hidden = true;

                });
            }
        }
    }];
    
    
//    NSLog(@"%@", returnString);
    
    //ここにinsert_pic_infoを入れる
}

/*
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"complete !");}];
}
*/

// データ受信時に１回だけ呼び出される。
// 受信データを格納する変数を初期化する。
- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    
    // receiveDataはフィールド変数
    receivedData = [[NSMutableData alloc] init];
}

// データ受信したら何度も呼び出されるメソッド。
// 受信したデータをreceivedDataに追加する
- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

// データ受信が終わったら呼び出されるメソッド。
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // 今回受信したデータはHTMLデータなので、NSDataをNSStringに変換する。
    NSString *html
    = [[NSString alloc] initWithBytes:receivedData.bytes
                               length:receivedData.length
                             encoding:NSUTF8StringEncoding];
    
    // 受信したデータをUITextViewに表示する。
    //textView.text = html;
    NSLog(@"sent? %@", html);
    
    // 終わった事をAlertダイアログで表示する。
    UIAlertView *alertView
    = [[UIAlertView alloc] initWithTitle:nil
                                message:@"Finish Loading"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    [alertView show];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    if ( touch.view.tag == self.tempDrawImage.tag ){
        lastPoint = [touch locationInView:self.mainImage];
        NSLog(@"%ld",(long)touch.view.tag);
    }else if(touch.view.tag == 10){
        NSLog(@"pen");
        [self penButtonPressed];
    }else if(touch.view.tag == 20){
        NSLog(@"check");
        [self sendButtonPressed];
    }else if(touch.view.tag == 30){
        NSLog(@"eraser");
        [self eraserButtonPressed];
    }else{
        NSLog(@"nothing");
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    if ( touch.view.tag == self.tempDrawImage.tag ){
        CGPoint currentPoint = [touch locationInView:self.mainImage];
        
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    //self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
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


@end
