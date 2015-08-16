//
//  topAndBottomRefresh.h
//  上拉刷新与下拉刷新
//
//  Created by 边智峰 on 15/8/16.
//  Copyright (c) 2015年 边智峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface topAndBottomRefresh : NSObject
// 上拉刷新 */
// ** urlStr 网络请求的地址
// ** vc 显示数据的控制器
// ** dict 网络请求的参数
// ** clazz 存储网络请求数据的模型
// ** success 成功回调
// ** failure 失败回调
+ (void)topRefreshWithUrl:(NSString *)urlStr viewCtrl:(UITableViewController *)vc dict:(NSMutableDictionary *)dict clazz:(Class)clazz success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure;
// 下拉刷新 */
// ** urlStr 网络请求的地址
// ** scrollView 需要传递scrollViewDidScroll的scrollView参数
// ** vc 显示数据的控制器
// ** dict 网络请求的参数
// ** clazz 存储网络请求数据的模型
// ** success 成功回调
// ** failure 失败回调
+ (void)bottomRefreshWithUrl:(NSString *)urlStr scrollView:(UIScrollView *)scrollView viewCtrl:(UITableViewController *)vc dict:(NSMutableDictionary *)dict clazz:(Class)clazz success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure;

@end
