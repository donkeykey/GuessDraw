//
//  GuessViewController.h
//  GuessDraw
//
//  Created by Shen Tianmeng on 2013/03/30.
//  Copyright (c) 2013年 Shen Tianmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"

@interface GuessViewController : UIViewController<UITextFieldDelegate>{
    //サーバとのコネクション情報を保持
//    NSURLConnection *connection;
    //受信データを入れる
//    NSMutableData *async_data;
}
@property (nonatomic) NSURL *pic_url;
@property (nonatomic) CGFloat ww;
@property (nonatomic) CGFloat hh;
@property (nonatomic) NSString *floid;
@property (nonatomic) NSString *fid;
@property (nonatomic) NSInteger err_num;

@end
