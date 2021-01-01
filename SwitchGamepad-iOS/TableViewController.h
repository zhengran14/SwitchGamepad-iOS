//
//  ViewController.h
//  SwitchGamepad-iOS
//
//  Created by rabbit on 2020/12/23.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface TableViewController : UITableViewController

//@property (atomic, strong) NSURL *url;
@property (atomic, retain) id <IJKMediaPlayback> player;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UILabel *runCell;
@property (weak, nonatomic) IBOutlet UILabel *scriptNameText;
@property (weak, nonatomic) IBOutlet UISwitch *gamepadSwitch;

@end

