//
//  DrawViewController.h
//  GuessDraw
//
//  Created by Shen Tianmeng on 2013/03/30.
//  Copyright (c) 2013年 Shen Tianmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAppDelegate.h"

@interface DrawViewController : UIViewController{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    NSMutableData *receivedData;
    
    NSString* fid;
    NSString* floid;
    NSString* filename;
}

//@property (nonatomic) NSString* FBID;
@property (nonatomic) NSString* subj;
@property (nonatomic) int white_flag;


@end
