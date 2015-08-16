//
//  topAndBottomRefresh.m
//  上拉刷新与下拉刷新
//
//  Created by 边智峰 on 15/8/16.
//  Copyright (c) 2015年 边智峰. All rights reserved.
//

#import "topAndBottomRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"

#define KSCREENH [UIScreen mainScreen].bounds.size.height

@implementation topAndBottomRefresh

+ (void)loadNewStatuses:(UIRefreshControl *)refreshControl url:(NSString *)urlString dict:(NSMutableDictionary *)dict viewCtrl:(UITableViewController *)vc success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure{
    
    
    //设置请求的url
    NSString *urlStr = urlString;
    
    //设置请求的字典属性
    NSMutableDictionary *parame = dict;
    
    //调用AFN 获取数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求数据成功的时候 停止下拉刷新
        [refreshControl endRefreshing];
        
        //如果请求成功，并且成功的block有值的话，把请求成功的数据通过block返回回去
        if (success) {
            success(responseObject);
        }
        
        //刷新数据
        [vc.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        //失败 也要停止下拉刷新
        [refreshControl endRefreshing];
        
    }];
    
}


+ (void)topRefreshWithUrl:(NSString *)urlStr viewCtrl:(UITableViewController *)vc dict:(NSMutableDictionary *)dict clazz:(Class)clazz success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure{

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    //设置下拉刷新显示文字的属性
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在玩命加载" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    //设置菊花的颜色
    refresh.tintColor = [UIColor yellowColor];
    
    
    //为下拉刷新添加方法 继承自UIControl 与UIButton一样
    [refresh addTarget:self action:@selector(loadNewStatuses:url:dict:viewCtrl:success:failure:) forControlEvents:UIControlEventValueChanged];
    
    //把下拉刷新添加
    [vc.view addSubview:refresh];
    
    //界面一旦显示 就显示下拉刷新
    [refresh beginRefreshing]; //执行此方法 不会为refresh添加的valuechange方法
    //所以需要调用请求网络数据的方法
    [self loadNewStatuses:refresh url:urlStr dict:dict viewCtrl:vc success:^(id responseObj) {
        
        //判断block是否有值，如果没有值没有必要字典转模型
        if (success) {
            //字典转模型
            id response = [clazz new];
            [response setKeyValues:responseObj];
            success(response);
        }
        
    } failure:^(NSError *error){
        
   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求出错" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        
    }];



}


+ (void)bottomRefreshWithUrl:(NSString *)urlStr scrollView:(UIScrollView *)scrollView viewCtrl:(UITableViewController *)vc dict:(NSMutableDictionary *)dict clazz:(Class)clazz success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure{
    
    //判断 如果没有数据 或者loadmore没有隐藏(也就是正在请求数据) 就直接return
//    if(self.dataFrameArr.count == 0 || (vc.tableView.tableFooterView.hidden == NO)){
//        
//        return;
//    }
    //偏移量
    CGFloat contenOffsetY = scrollView.contentOffset.y;
    //footerview的高度
    CGFloat bottomViewH = vc.tableView.tableFooterView.frame.size.height;
    //

    if ((scrollView.contentSize.height- KSCREENH)<(contenOffsetY-49+bottomViewH)){
        
        vc.tableView.tableFooterView.hidden = NO;
        
        [self loadMoreStatusesWithUrl:urlStr dict:dict viewCtrl:vc success:^(id responseObj) {
            //判断block是否有值，如果没有值没有必要字典转模型
            if (success) {
                //字典转模型
                id response = [clazz new];
                [response setKeyValues:responseObj];
                success(response);
            }
            
        } failure:^(NSError *error) {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求出错" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];

            
        }];
        
    };





}

+ (void)loadMoreStatusesWithUrl:(NSString *)urlString dict:(NSMutableDictionary *)dict viewCtrl:(UITableViewController *)vc success:(void(^)(id responseObj))success failure:(void(^)(NSError *))failure{
    //设置请求数据的url
    NSString *urlStr = urlString;
    
    
    //设置请求参数的字典
    NSMutableDictionary *parame = dict;
  
    
    //使用AFN 创建get网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"++++++%@",responseObject);
        //请求数据完成后 隐藏底部的footerview
        vc.tableView.tableFooterView.hidden = YES;
        //成功的话  把数据添加到数组中 只需要添加就可以 因为是旧的数据 所以添加在数组后面 微博模型数组
//        NSArray *tempArr = [BWBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        //如果请求成功，并且成功的block有值的话，把请求成功的数据通过block返回回去
        if (success) {
            success(responseObject);
        }

        
//        [self.dataFrameArr addObjectsFromArray:frameArr];
        [vc.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }

        vc.tableView.tableFooterView.hidden = YES;
        
    }];
    
    
    
    
}

@end
