//
//  ViewViewController.h
//  SessionLoginSample
//
//  Created by 川島 大地 on 13/07/20.
//
//

#import <UIKit/UIKit.h>

@interface ViewViewController : UIViewController<UIScrollViewDelegate>{
    
}
@property (nonatomic,retain) NSMutableData *async_data;
@property (nonatomic,retain) NSURLConnection *conn;
@end
