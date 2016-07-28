//
//  Cyhsession.m
//  NSURLSessiontest
//
//  Created by Macx on 16/7/27.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "Cyhsession.h"

@interface Cyhsession ()<NSURLSessionDownloadDelegate>
/**
 *  下载的存放路径，为空时，下载文件存放在默认路径
 */
@property (nonatomic , copy)NSString * downPath;

@end

static Cyhsession * cyhmanager;
@implementation Cyhsession

+(void)sessionPOST:(NSString *)url postPram:(id)postPram HTTPHeader:(NSDictionary *)header  Success:(sessionpost)responseobjct failer:
(sessionfailpost)failerror
{
    NSString * postPramstr =[NSString stringWithFormat:@"%@",postPram];
    NSString * URLString = url;
    NSURL * URL = [NSURL URLWithString:URLString];
    
    NSString * postString = postPramstr;
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"POST"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    [request setTimeoutInterval:30];
    [request setCachePolicy:1];
    if (header) {
        for (NSString * key in [header allKeys]) {
            [request setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            //            NSLog(@"data:%@",data);
            
            responseobjct(data);
        }
        else
        {
            failerror(error);
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

+(void)sessionGET:(NSString *)url Success:(sessionget)responseobjct failer:(sessionfailget)failerror
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSString * URLString = url;
    NSURL * URL = [NSURL URLWithString:URLString];
    //    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    //    NSString * postPramstr =[NSString stringWithFormat:@"%@",postPram];
    //    NSString * postString = postPramstr;
    //    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setURL:URL]; //设置请求的地址
    //    [request setHTTPBody:postData];  //设置请求的参数
    //    [request setTimeoutInterval:30];
    //    [request setCachePolicy:1];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionTask * task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
  
            responseobjct(data);
        }
        else
        {
            failerror(error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    
    
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

+ (void)sessionDownload:(NSString *)url DownloadPath:(NSString *)path SuccessSavePath:(sessiondown)Savepath
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL * URL = [NSURL URLWithString:url] ;
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件挪到需要的地方
        
        if (path == nil) {
            
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            // 剪切文件
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
            Savepath(path);
        }
        else
        {
            
            // 剪切文件
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
            Savepath(path);
        }
        
        
    }];
    // 启动任务
    [task resume];
}

+ (void)sessionUpload:(NSString *)url HTTPHeader:(NSDictionary *)header fromFile:(NSURL *)filename fromData:(NSData *)bodydata  Success:(sessionupload)responseobjct failer:(sessionfailupload)failerror
{
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    NSString * URLString = url;
    NSURL * URL = [NSURL URLWithString:URLString];
    [request setURL:URL]; //设置请求的地址
    //    [request setHTTPBody:postData];  //设置请求的参数
    [request setTimeoutInterval:30];
    [request setCachePolicy:1];
    if (header) {
        for (NSString * key in [header allKeys]) {
            [request setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    if (bodydata != nil) {
        [request setHTTPMethod:@"POST"]; //指定请求方式
        NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:bodydata completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data) {
                
                responseobjct(data);
            }
            else
            {
                failerror(error);
            }
            
            
        }];
        [task resume];
    }
    else if(filename != nil){
        
        NSURLSessionUploadTask *task =
        [session uploadTaskWithRequest:request fromFile:filename completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                
                NSLog(@"data:%@",data);
                
                responseobjct(data);
            }
            else
            {
                failerror(error);
            }
            
        }];
        
        [task resume];
        
    }
}

+ (Cyhsession *)download
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        cyhmanager = [Cyhsession new];
    });
    
    return cyhmanager;
    
}


- (NSURLSession *)downloadSession
{
    if (!_downloadSession) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.downloadSession = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _downloadSession;
}

- (void)startDownload:(NSString *)url trag:(id)trag DownPath:(NSString *)path
{
    self.downPath = path;
    self.DWdelegate = trag;
    NSURL * URL = [NSURL URLWithString:url];
    self.task = [self.downloadSession downloadTaskWithURL:URL];
    [self.task resume];
    self.statusnum = 1;
}

- (void)resumeDownload
{
    // 传入上次暂停下载返回的数据，就可以恢复下载
    self.task = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
    
    // 继续
    [self.task resume];
    // 清空
    self.resumeData = nil;
    
}

- (void)pauseDownload
{
    __weak typeof(self) vc = self;
    [self.task cancelByProducingResumeData:^(NSData *resumeData) {
        vc.resumeData = resumeData;
        vc.task = nil;
    }];
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    if (session == self.downloadSession) {
        //        NSLog(@"下载停止");
        [self.DWdelegate finishDown:YES];
        self.statusnum = 2;
        
        if (self.downPath) {
            
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:self.downPath error:nil];
        }
        else{
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // response.suggestedFilename 建议使用本身文件的名字命名
            NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
            // AtPath : 剪切前的文件路径
            // ToPath : 剪切后的文件路径
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:file error:nil];
        }
        
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (session == self.downloadSession) {
        
        
        //    NSLog(@"获得下载进度--%@", [NSThread currentThread]);
        // 获得下载进度
        double  down_To = (double)totalBytesWritten / totalBytesExpectedToWrite;

        [self.DWdelegate progress:down_To];
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}



@end
