//
//  SettingTableViewController.m
//  SwitchGamepad-iOS
//
//  Created by 郑冉 on 2021/1/1.
//


#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // rtmp://123.112.151.62/live/mystream
    // rtmp://rrabbit.xyz/live/mystream
    NSString *liveUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"liveUrl"];
    if (liveUrl == nil) {
        [self.urlText setText:@"rtmp://rrabbit.xyz/live/mystream"];
        [[NSUserDefaults standardUserDefaults] setObject:self.urlText.text forKey:@"liveUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.urlText setText:liveUrl];
    }
    // 123.116.87.42
    // 192.168.50.58
    NSString *serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverUrl"];
    if (serverUrl == nil) {
        [self.serverUrlText setText:@"rrabbit.xyz"];
        [[NSUserDefaults standardUserDefaults] setObject:self.serverUrlText.text forKey:@"serverUrl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.serverUrlText setText:serverUrl];
    }
    NSString *serverPort = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverPort"];
    if (serverPort == nil) {
        [self.serverPortText setText:@"7770"];
        [[NSUserDefaults standardUserDefaults] setObject:self.serverPortText.text forKey:@"serverPort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.serverPortText setText:serverPort];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.urlText resignFirstResponder];
    [self.serverUrlText resignFirstResponder];
    [self.serverPortText resignFirstResponder];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqual: @"Default"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure?" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.urlText setText:@"rtmp://rrabbit.xyz/live/mystream"];
            [[NSUserDefaults standardUserDefaults] setObject:self.urlText.text forKey:@"liveUrl"];
            [self.serverUrlText setText:@"rrabbit.xyz"];
            [[NSUserDefaults standardUserDefaults] setObject:self.serverUrlText.text forKey:@"serverUrl"];
            [self.serverPortText setText:@"7770"];
            [[NSUserDefaults standardUserDefaults] setObject:self.serverPortText.text forKey:@"serverPort"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (IBAction)urlEdtiEnd:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.urlText.text forKey:@"liveUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)serverUrlEdtiEnd:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.serverUrlText.text forKey:@"serverUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)serverPortEdtiEnd:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.serverPortText.text forKey:@"serverPort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

