//
//  ViewController.m
//  SwitchGamepad-iOS
//
//  Created by rabbit on 2020/12/23.
//

#import "TableViewController.h"
#import "GCDAsyncSocket.h"
#import "ButtonTableViewController.h"

@interface TableViewController () <ButtonTableViewControllerDelegate>
//客户端socket
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSArray *scripts;

@end


@implementation TableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [self.scriptNameText setText:@""];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    [self.view setBackgroundColor:[UIColor redColor]];
    
//    self.url = [NSURL URLWithString:@"rtmp://58.200.131.2:1935/livetv/cctv1"];
//    [self installMovieNotificationObservers];
//    [self.player prepareToPlay];
//    [self.player play];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqual: @"Connect"]) {
        cell.textLabel.text = @"Disconnect";
        
        self.scripts = nil;
        [self.scriptNameText setText:@""];
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        BOOL result = [self.clientSocket connectToHost:[[NSUserDefaults standardUserDefaults] objectForKey:@"serverUrl"] onPort:[[[NSUserDefaults standardUserDefaults] objectForKey:@"serverPort"] integerValue] error:nil];
        if (result) {
            NSLog(@"链接成功");
        }
        else {
            NSLog(@"链接失败");
        }
        
        
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"liveUrl"]];
        self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
        UIView *ijkPlayerView = [self.player view];
        ijkPlayerView.backgroundColor = [UIColor blackColor];
        ijkPlayerView.frame = self.playerView.bounds;
        ijkPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.player setScalingMode:IJKMPMovieScalingModeAspectFill];
        [self.playerView insertSubview:ijkPlayerView atIndex:1];
        [self.player prepareToPlay];
        [self.player play];
    }
    else if ([cell.textLabel.text isEqual: @"Disconnect"]) {
        cell.textLabel.text = @"Connect";
        
        [self.clientSocket disconnect];
        self.clientSocket = nil;
        self.scripts = nil;
        [self.scriptNameText setText:@""];
        
        [self.player stop];
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        self.player = nil;
    }
    else if ([cell.textLabel.text isEqual: @"Run"]) {
        if (self.clientSocket == nil || self.scriptNameText.text == nil || [self.scriptNameText.text isEqual:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You need to connect or choose a script" preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
        if (self.clientSocket) {
            NSString *json = [NSString stringWithFormat:@"{\"message\":\"Run script name: %@\",\"status\":true,\"operation\":8,\"data\":{\"scriptName\":\"%@\"}}", self.scriptNameText.text, self.scriptNameText.text];
            [self.clientSocket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            cell.textLabel.text = @"Stop";
        }
    }
    else if ([cell.textLabel.text isEqual: @"Stop"]) {
        if (self.clientSocket) {
            [self.clientSocket writeData:[@"{\"message\":\"Stop run script\",\"status\":true,\"operation\":2,\"data\":{}}" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            cell.textLabel.text = @"Run";
        }
    }

}

//客户端链接服务器成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%@",[NSString stringWithFormat:@"链接成功服务器：%@",host]);
    [self.clientSocket writeData:[@"{\"message\":\"iPhone connected!\",\"status\":true,\"operation\":6,\"data\":{}}" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
//成功读取服务端发过来的消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"读取服务端发过来的消息 = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)jsonObject;
            NSInteger operation = [[dict valueForKey:@"operation"] integerValue];
            BOOL status = [[dict valueForKey:@"status"] boolValue];
            if (status) {
                if ([[dict valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *data = [dict valueForKey:@"data"];
                    switch (operation) {
                        case 7: {
                            if ([[data valueForKey:@"scripts"] isKindOfClass:[NSArray class]]) {
                                self.scripts = nil;
                                [self.scriptNameText setText:@""];
                                self.scripts = (NSArray *)[data valueForKey:@"scripts"];
//                                NSString *text = @"";
//                                for (int i = 0; i < self.scripts.count; i++) {
//                                    text = [NSString stringWithFormat:@"%@\n%d.%@", text, i, self.scripts[i]];
//                                }
                            }
                            break;
                        }
                        case 4: {
                            self.runCell.text = @"Run";
                            break;
                        }
                    }
                }
            }
            
        } else {
            NSLog(@"An error happened while deserializing the JSON data.");
        }
    }
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier  isEqual: @"ChooseSegue"]) {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:self.scripts forKey:@"scripts"];
        ButtonTableViewController *btvc = segue.destinationViewController;
        btvc.delegate = self;
    }
}

- (void) selectedScriptName:(NSString *)str {
//    NSLog(@"%@", str);
    [self.scriptNameText setText:str];
}

- (IBAction)gamepadBtnDown:(id)sender {
    if (self.gamepadSwitch.isOn && self.clientSocket != nil) {
        UIButton *button = (UIButton *)sender;
        NSString *json = [NSString stringWithFormat:@"{\"message\":\"Receive key: %@\",\"status\":true,\"operation\":5,\"data\":{\"data\":\"%@\"}}", button.accessibilityHint, button.accessibilityHint];
        [self.clientSocket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
}

- (IBAction)gamepadBtnClick:(id)sender {
    if (self.gamepadSwitch.isOn && self.clientSocket != nil) {
        UIButton *button = (UIButton *)sender;
        NSString *json = [NSString stringWithFormat:@"{\"message\":\"Receive key: RELEASE\",\"status\":true,\"operation\":5,\"data\":{\"data\":\"RELEASE\"}}"];
        [self.clientSocket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
}


@end
