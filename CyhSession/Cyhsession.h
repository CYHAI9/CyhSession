//
//  Cyhsession.h
//  NSURLSessiontest
//
//  Created by Macx on 16/7/27.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^sessionpost)(NSData *);
typedef void(^sessionfailpost)(NSError *);
typedef void(^sessionget)(NSData *);
typedef void(^sessionfailget)(NSError *);
typedef void(^sessiondown)(NSString *);
typedef void(^sessionupload)(NSData *);
typedef void(^sessionfailupload)(NSError *);

/**
 *  断点续传协议
 */
@protocol cyhDowndelegate <NSObject>
/**
 *  断点续传的进度
 *
 *  @param values 双浮点
 */
- (void)progress:(double)values;
/**
 *  是否完成下载
 *
 *  @param isfinish 完成返回YES
 */
- (void)finishDown:(BOOL)isfinish;

@end

@interface Cyhsession : NSObject

@property (nonatomic , strong) NSURLSession * downloadSession;
@property (nonatomic , strong) NSURLSessionDownloadTask *task;
@property (nonatomic , strong) NSData *resumeData;
/**
 *  状态为1时，是已经断点过，不为1时时重头开始下载
 */
@property (nonatomic , assign)NSInteger statusnum;
/**
 *  续传下载协议
 */
@property (nonatomic , weak)id<cyhDowndelegate> DWdelegate;

/**
 *  POST请求，包含body和请求头
 *
 *  @param url           http/https
 *  @param postPram      Body
 *  @param header        请求头
 *  @param responseobjct 请求回来的数据
 *  @param failerror     错误提示
 */
+(void)sessionPOST:(NSString *)url postPram:(id)postPram HTTPHeader:(NSDictionary *)header  Success:(sessionpost)responseobjct failer:
(sessionfailpost)failerror;
/**
 *  GET请求
 *
 *  @param url           http/https
 *  @param responseobjct 请求回来的数据
 *  @param failerror     错误提示
 */
+(void)sessionGET:(NSString *)url Success:(sessionget)responseobjct failer:(sessionfailget)failerror;
/**
 *  下载，非断点续传，普通下载
 *
 *  @param url      htt/https
 *  @param path     存放路径
 *  @param Savepath 成功返回路径
 */
+ (void)sessionDownload:(NSString *)url DownloadPath:(NSString *)path SuccessSavePath:(sessiondown)Savepath;
/**
 *  提交，向服务器提交数据或文件
 *
 *  @param url           htt/https
 *  @param header        请求头
 *  @param filename      文件名
 *  @param bodydata      Body
 *  @param responseobjct 成功的回复数据
 *  @param failerror     错误提示
 */
+ (void)sessionUpload:(NSString *)url HTTPHeader:(NSDictionary *)header fromFile:(NSURL *)filename fromData:(NSData *)bodydata  Success:(sessionupload)responseobjct failer:(sessionfailupload)failerror;

+ (Cyhsession *)download;
/**
 *  开始下载
 *
 *  @param url  http/https
 *  @param trag 协议对象
 *  @param path 存储路径
 */
- (void)startDownload:(NSString *)url trag:(id)trag DownPath:(NSString *)path;
/**
 *  继续下载
 */
- (void)resumeDownload;
/**
 *  取消下载
 */
- (void)pauseDownload;



@end
