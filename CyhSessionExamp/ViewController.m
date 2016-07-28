//
//  ViewController.m
//  NSURLSessiontest
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ViewController.h"
#import "Cyhsession.h"
@interface ViewController ()<cyhDowndelegate>
@property (weak, nonatomic) IBOutlet UISwitch *downSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self testSession];
    
}
- (IBAction)Post:(UIButton *)sender {
    
    [Cyhsession sessionPOST:@"http://120.25.226.186:32812/login" postPram:@"username=520it&pwd=520it&type=JSON" HTTPHeader:nil Success:^(NSData * responseobjct) {
        
        NSLog(@"POST:%@",[[NSString alloc] initWithData:responseobjct encoding:NSUTF8StringEncoding]);
        
    } failer:^(NSError * error) {
        
        NSLog(@"错误原因%@",error);
        
        
    }];
    
    
}

- (IBAction)Get:(id)sender {
    
    [Cyhsession sessionGET:@"http://api.jiefu.tv/app2/api/article/list.html?mediaType=2&deviceCode=6EE4FB649FAF4D0EB99754F1E3F49DF0&token=&pageNum=2&pageSize=20" Success:^(NSData * responseobjct) {
        
        NSLog(@"GET：%@", [NSJSONSerialization JSONObjectWithData:responseobjct options:kNilOptions error:nil]);
        
    } failer:^(NSError * error) {
        
        NSLog(@"错误原因%@",error);
        
    }];
    
    
    
}

- (IBAction)Download:(id)sender {
    
    NSString *path = [@"/Users/Macx/Desktop" stringByAppendingPathComponent:@"/test.jpg"];
    
    [Cyhsession sessionDownload:@"http://m.xinjunshi.com/uploads/allimg/160427/21-16042G03033.jpg" DownloadPath:path SuccessSavePath:^(NSString * path) {
        
        NSLog(@"存储路径：%@",path);
        
    }];
    
    
}

- (IBAction)Upload:(id)sender {
    
    NSString * postPramstr = @"username=520it&pwd=520it&type=JSON";
    NSString * postString = postPramstr;
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    [Cyhsession sessionUpload:@"http://120.25.226.186:32812/login" HTTPHeader:nil fromFile:nil fromData:postData Success:^(NSData *responseobjct) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:responseobjct encoding:NSUTF8StringEncoding]);
        
    } failer:^(NSError * error) {
        
        
        NSLog(@"错误的提示%@",error);
        
        
    }];
    
    
    
}

- (IBAction)downloa_on_off:(UISwitch *)sender {
    /**
     *  .statusnum 是用于判断是否是开始下载还是断点后在下载，为1的时候是断点后在下载，不等于1则是刚开始下载，看个人看法，也可以不这样使用，
     */
    
    if (self.downSwitch.isOn == YES && [Cyhsession download].statusnum != 1) {
        NSString *path = [@"/Users/Macx/Desktop" stringByAppendingPathComponent:@"/test.mp4"];
        /**
         *  下载url与下载存放的路径，path如果不传入(为nil)，则会下载存放到默认的路径 Cache下，并以原来的文件名命名
         */
        [[Cyhsession download] startDownload:@"http://video.jiefu.tv/img/attached/1/image/20160722/20160722111914_58.mp4" trag:self DownPath:path];
    }
    else if(self.downSwitch.isOn == YES && [Cyhsession download].statusnum == 1)
    {
        [[Cyhsession download]resumeDownload];
        
    }
    else
    {
        [[Cyhsession download] pauseDownload];
        
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
