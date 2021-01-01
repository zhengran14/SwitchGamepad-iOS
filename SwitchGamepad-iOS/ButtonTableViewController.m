//
//  ButtonTableViewController.m
//  SwitchGamepad-iOS
//
//  Created by 郑冉 on 2021/1/1.
//

#import "ButtonTableViewController.h"

@interface ButtonTableViewController ()

@end

@implementation ButtonTableViewController

@synthesize scripts;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@", self.scripts);
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
       // back button was pressed.  We know this is true because self is no longer
       // in the navigation stack.
//        [self.delegate selectedScriptName:@"123123123"];
    }
    [super viewWillDisappear:animated];
}

//配置每个section(段）有多少row（行） cell
//默认只有一个section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scripts.count;
}
//每行显示什么东西
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //给每个cell设置ID号（重复利用时使用）
//    static NSString *cellID = @"cellID";
    NSString *cellID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];

    //从tableView的一个队列里获取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    //判断队列里面是否有这个cell 没有自己创建，有直接使用
    if (cell == nil) {
        //没有,创建一个
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    }

    //使用cell
    cell.textLabel.text = self.scripts[indexPath.row];
    return cell;
}

//某个cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.delegate selectedScriptName:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
