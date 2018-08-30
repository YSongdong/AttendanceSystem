//
//  KRMainNetTool.m
//  Dntrench
//
//  Created by kupurui on 16/10/19.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRMainNetTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "SDLoginController.h"
#import "SDRootNavigationController.h"

#define baseURL @"这里写基础的url"

@implementation KRMainNetTool
singleton_implementation(KRMainNetTool)
//上传文件的接口方法
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array complateHandle:(void (^)(id, NSString *))complet {
    [self upLoadData:url params:param andData:array waitView:nil complateHandle:complet];
}
//需要显示加载动画的接口方法 不上传文件
- (void)postRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    
 //   NSLog(@"-----url--%@----",url);
    
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil) {
        //如果view不为空就添加到view上
        dispatch_async(dispatch_get_main_queue(), ^{
             HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
             HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
             HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
   [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
       
       //判断返回的状态，200即为服务器查询成功，1服务器查询失败
       NSNumber  *code = responseObject[@"code"];
       
       if ([code integerValue]  == 200) {
           
           if (model == nil) {
               
               if (responseObject[@"data"]) {
                   
                   complet(responseObject[@"data"],nil);
                   
               } else {
                   
                   complet(responseObject[@"msg"],nil);
               }
           } else {
               
               complet([self getModelArrayWith:responseObject[@"data"] andModel:model],nil);
           }
       } else  if ([code integerValue]  == 501) {
           
           [self showPromptView];
           
       }else{
            complet(nil,responseObject[@"msg"]);
       }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];

}
// get  需要显示加载动画的接口方法
- (void)getRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet{
    
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil) {
        //如果view不为空就添加到view上
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];
        });
        //判断返回的状态，200即为服务器查询成功，1服务器查询失败
        NSNumber  *code = responseObject[@"code"];
        
        if ([code integerValue]  == 200) {
            
            if (model == nil) {
                
                if (responseObject[@"data"]) {
                    
                    complet(responseObject[@"data"],nil);
                    
                } else {
                    
                    complet(responseObject[@"msg"],nil);
                }
            } else {
                
                complet([self getModelArrayWith:responseObject[@"data"] andModel:model],nil);
            }
        } else {
            
            complet(nil,responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
    
}

//需要显示加载动画的接口方法 上传文件
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    //拼接网络请求url
 //   NSLog(@"-------%@-----",url);
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (waitView != nil) {
        //如果view不为空就添加到view上
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD = [MBProgressHUD showHUDAddedTo:waitView animated:YES];
            HUD.bezelView.color =[UIColor colorWithWhite:0 alpha:0.7];
            HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
        });
    }
    //开始上传数据并网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //返回结果支持的类型 方法一
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/xml", nil];
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 10;
    //开始网络请求
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //通过遍历传过来的上传数据的数组，把每一个数据拼接到formData对象上
        for (int i = 0; i < array.count; i++) {

            UIImage *image = array[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
           // NSData *imageData = [self imageCompressToData:image];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功，隐藏HUD并销毁
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        NSNumber *num = responseObject[@"code"];
        //判断返回的状态，200即为服务器查询成功，500服务器查询失败
        if ([num longLongValue] == 200) {
            complet(responseObject[@"data"],nil);
        } else {
            complet(nil,responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
        });
        complet(nil,@"网络错误");
    }];
}
//显示
-(void) showPromptView{
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //删除
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"登录已过期,请重新登录!" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //退出的时候删除别名
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                NSLog(@"删除别名成功");
            }
        } seq:1];
        
        //删除本地用户信息
        [SDUserInfo delUserInfo];
        
        SDRootNavigationController *loginVC = [[SDRootNavigationController alloc]initWithRootViewController:[SDLoginController new]];
        appdel.window.rootViewController = loginVC;
    }]];
    [appdel.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
///压缩图片
- (NSData *)imageCompressToData:(UIImage *)image{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    if (data.length>300*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>300*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}
//把模型数据传入返回模型数据的数组
- (NSArray *)getModelArrayWith:(NSArray *)array
                      andModel:(Class)modelClass {
    NSMutableArray *mut = [NSMutableArray array];
    //遍历模型数据 用KVC给创建每个模型类的对象并赋值过后放进数组
    for (NSDictionary *dic in array) {
        id model = [modelClass new];
        [model setValuesForKeysWithDictionary:dic];
        [mut addObject:model];
    }
    return [mut copy];
}
+ (void)ysy_hasNetwork:(void(^)(NSString *net))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                hasNet(@"NO");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(@"NO");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                hasNet(@"GPRS");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(@"WIFI");
                break;
        }
    }];
    //结束监听
    [manager stopMonitoring];
}








@end
