//
//  ViewController.m
//  NSURLSessiontest
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ViewController.h"
#import <Cyhsession.h>
@interface ViewController ()<cyhDowndelegate>
@property (weak, nonatomic) IBOutlet UISwitch *downSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self testSession];
    
}
- (IBAction)Post:(UIButton *)sender {
    
    [[Cyhsession sessionManager] sessionPOST:@"http://192.168.6.106:8080/testpost" postPram:@{@"name":@"tom",@"age":@"12"} HTTPHeader:nil Success:^(NSData * responseobjct) {
        
        NSLog(@"POST:%@",[[NSString alloc] initWithData:responseobjct encoding:NSUTF8StringEncoding]);
        
    } failer:^(NSError * error) {
        
        NSLog(@"错误原因%@",error);
        
        
    }];
    
    
}

- (IBAction)Get:(id)sender {
    
    [[Cyhsession sessionManager] sessionGET:@"http://192.168.6.106:8080/fixui" Param:@{@"name":@"tom",@"age":@12} Success:^(NSData *data) {
   
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"GET：%@",dict);
        
    } failer:^(NSError * error) {
        
        NSLog(@"错误原因%@",error);
        
    }];
    
    
    
}

- (IBAction)Download:(id)sender {
    
    NSString *path = [@"/Users/Macx/Desktop" stringByAppendingPathComponent:@"/test.jpg"];
    
    [[Cyhsession sessionManager] sessionDownload:@"http://m.xinjunshi.com/uploads/allimg/160427/21-16042G03033.jpg" DownloadPath:path SuccessSavePath:^(NSString * path) {
        
        NSLog(@"存储路径：%@",path);
        
    }];
    
    
}

- (IBAction)Upload:(id)sender {
    
     //将请求参数字符串转成NSData类型
    [[Cyhsession sessionManager] sessionUpload:@"http://120.25.226.186:32812/login" HTTPHeader:nil fromFile:nil fromData:@{@"username":@"520",@"pwd":@"520it",@"type":@"JSON"} Success:^(NSData *data) {
    
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    } failer:^(NSError * error) {
        
        
        NSLog(@"错误的提示%@",error);
        
        
    }];
    
    
    
}

- (IBAction)downloa_on_off:(UISwitch *)sender {
    /**
     *  .statusnum 是用于判断是否是开始下载还是断点后在下载，为1的时候是断点后再下载，不等于1则是刚开始下载，看个人看法，也可以不这样使用，
     */
    
    if (self.downSwitch.isOn == YES && [Cyhsession sessionManager].statusnum != 1) {
        NSString *path = [@"/Users/Macx/Desktop" stringByAppendingPathComponent:@"/test.mp4"];
        /**
         *  下载url与下载存放的路径，path如果不传入(为nil)，则会下载存放到默认的路径 Cache下，并以原来的文件名命名
         */
        [[Cyhsession sessionManager] startDownload:@"http://video.jiefu.tv/img/attached/1/image/20160722/20160722111914_58.mp4" trag:self DownPath:path];
    }
    else if(self.downSwitch.isOn == YES && [Cyhsession sessionManager].statusnum == 1)
    {
        [[Cyhsession sessionManager]resumeDownload];
        
    }
    else
    {
        [[Cyhsession sessionManager] pauseDownload];
        
    }
    
}
/**
 *  断点续传的下载进度回调
 *
 *  @param values 双浮点
 */
- (void)progress:(double)values
{
    NSLog(@"下载进度%lf",values);
    
}
/**
 *  断点续传的下载是否完成
 *
 *  @param isfinish YES是完成，否则为空
 */
- (void)finishDown:(BOOL)isfinish
{
    if (isfinish == YES) {
        
        NSLog(@"下载完成");
    }
    
}

@end
