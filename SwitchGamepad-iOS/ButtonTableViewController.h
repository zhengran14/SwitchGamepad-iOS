//
//  ButtonTableViewController.h
//  SwitchGamepad-iOS
//
//  Created by 郑冉 on 2021/1/1.
//

#import <UIKit/UIKit.h>

@protocol ButtonTableViewControllerDelegate <NSObject>

- (void) selectedScriptName:(NSString *)str;

@end

@interface ButtonTableViewController : UITableViewController

@property(nonatomic,weak) NSArray *scripts;
@property (nonatomic,weak) id<ButtonTableViewControllerDelegate> delegate;

@end
