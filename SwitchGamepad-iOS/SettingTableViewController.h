//
//  SettingTableViewController.h
//  SwitchGamepad-iOS
//
//  Created by 郑冉 on 2021/1/1.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *urlText;
@property (weak, nonatomic) IBOutlet UITextField *serverUrlText;
@property (weak, nonatomic) IBOutlet UITextField *serverPortText;
@end
