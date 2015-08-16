# topAndBottomRefreshing
测试 实现上下拉刷新

上拉刷新 字典中需要的参数 为网络请求的参数  根据自己的需求而设置 但是切记 下拉刷新 需要你从当前显示的数据中取出最后一条数据 来设置比取出的数据更早的数据 
举例来说 如果取出数据的参数是根据max_id来取 记得把max_id减1 防止重复加载最后一条数据 
需要在scrollView的代理方法  scrollViewDidScroll 中调用该方法

另外 上拉刷新之前 需要判断: 如果没有数据 或者tableView的footerView没有隐藏(也就是正在请求数据) 就直接return 否则 会造成请求数据次数过多 而被拒绝访问

下拉刷新 的参数 需要提醒的与上拉刷新相同 需要取到当前显示数据的第一条数据 然后根据文档的取最新数据的参数来设置 需不需要加1视具体情况而定

调用方法后 需要在返回成功的回调中 做 根据传递的网络请求返回值取出对应的数据数组 然后调用   
把得到的数据赋值给懒加载的数组
这个方法的翻译是把下拉刷新返回的数据添加到数据最前面 因为下拉刷新是得到最新的数据
[self.dataFrameArr insertObjects:frameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
如果是上拉刷新 直接添加到数组中即可 根据实际情况 是否需要reloadData  

本代码纯粹经验之谈 如有任何疑问 欢迎交流 如有错误希望能及时与我联系 我们共同探讨解决方案

