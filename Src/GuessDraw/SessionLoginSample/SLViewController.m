/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SLViewController.h"
#import "SLAppDelegate.h"
#import "ModeViewController.h"

@interface SLViewController () 

@property (strong, nonatomic) IBOutlet UIButton *buttonLoginLogout;
@property (strong, nonatomic) IBOutlet UIButton *buttonForStart;
@property (strong, nonatomic) IBOutlet UILabel *TitleLable;
@property (strong, nonatomic) IBOutlet UILabel *logoutButton;


- (IBAction)buttonClickHandler:(id)sender;
- (IBAction)buttonStartClickHandler:(id)sender;
- (void)updateView;
- (void)getUserInfo;

@end

@implementation SLViewController

@synthesize buttonLoginLogout = _buttonLoginLogout;
@synthesize buttonForStart = _buttonForStart;
@synthesize TitleLable = _TitleLabel;

- (void)viewDidLoad {    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
	// Do any additional setup after loading the view, typically from a nib.
    
    self.logoutButton.userInteractionEnabled = YES;
    self.logoutButton.tag = 100;
    
    self.TitleLable.font = [UIFont fontWithName:@"HoboStd" size:45.0];
    self.TitleLable.textColor = [UIColor colorWithRed:0.349 green:0.31 blue:0.31 alpha:1.0];
    [self.buttonLoginLogout.titleLabel setFont:[UIFont fontWithName:@"HoboStd" size:25.0]];
    [self.buttonForStart.titleLabel setFont:[UIFont fontWithName:@"HoboStd" size:25.0]];


    
    //self.buttonForStart.enabled = NO;
    [self updateView];
    
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, 
                                                             FBSessionState status, 
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
}

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    
    NSLog(@"updateView");

    // get the app delegate, so that we can reference the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        //ログインしている場合
        NSLog(@"Log in");
        self.buttonLoginLogout.hidden = true;
        self.buttonForStart.hidden = false;
        self.logoutButton.hidden = false;


        // valid account UI is shown whenever the session is open
        [self getUserInfo];
        self.buttonForStart.enabled = YES;

        //[self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        
        //アクセストークンの取得の仕方です．元はSLviewcontroller_iphone.xibで表示させてましたが，コメントアウトしてます．
//        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
//                                 appDelegate.session.accessTokenData.accessToken]];
    } else {
        //ログインしていない場合
        NSLog(@"Not login");
        self.buttonForStart.hidden = true;
        self.buttonLoginLogout.hidden = false;
        self.logoutButton.hidden = true;



        // login-needed account UI is shown whenever the session is closed
        //[self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
//        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}

// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, 
                                                         FBSessionState status, 
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}

- (void)getUserInfo{
    NSLog(@"get user info in");
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        FBRequest *me = [[FBRequest alloc] initWithSession:appDelegate.session
                                                 graphPath:@"me"];
        [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                         // we expect a user as a result, and so are using FBGraphUser protocol
                                         // as our result type; in order to allow us to access first_name and
                                         // birthday with property syntax
                                         NSDictionary<FBGraphUser> *user,
                                         NSError *error) {
            /*
            if (me != self.pendingRequest) {
                return;
            }
            self.pendingRequest = nil;
            */
            if (error) {
                NSLog(@"Couldn't get info : %@", error.localizedDescription);
                return;
            }
            
            /*
            self.nameLabel.text = [NSString stringWithFormat:@"Hello, %@!", user.first_name];
            self.picView.profileID = user.id;
            if (user.birthday.length > 0) {
                self.birthdayLabel.text = [NSString stringWithFormat:@"Your birthday is: %@", user.birthday];
            } else {
                self.birthdayLabel.text = @"Your birthday isn't set.";
            }
            */
            NSLog(@"Hello, %@", user.name);
            NSLog(@"%@",user.id);
            appDelegate.FBID = user.id;
            
            NSLog(@"device_token:::::%@",[appDelegate Dev]);
            //self.profilePic.profileID = user.id;
            //self.nameLable.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
        }];

    }else{
        NSLog(@"active session none");
    }
}


- (IBAction)buttonStartClickHandler:(id)sender {
    NSLog(@"start");

    ModeViewController *modeView = [[ModeViewController alloc] initWithNibName:@"ModeViewController" bundle:nil];
    [self presentViewController:modeView animated:YES completion:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    UITouch *touch = [[event allTouches] anyObject];
    if ( touch.view.tag == self.logoutButton.tag )
        [appDelegate.session closeAndClearTokenInformation];
}

#pragma mark Template generated code

- (void)viewDidUnload
{
    self.buttonLoginLogout = nil;
//    self.textNoteOrLink = nil;
    self.buttonForStart = nil;
    //self.profilePic = nil;
    
    [self setButtonForStart:nil];
    //[self setProfilePic:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -

@end
