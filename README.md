# confuse
代码混淆工具

### 1.打开工程main.m
### 2.将main.m的路径改为自己工程的路径（里面的那个，和pod同级的）

## 修改类名
3.设置NSInteger step = 1
4.在case 1里面修改工程工程前缀，其中ignoreArray是可以添加为不修改的类
5.运行工程，一会就修改成功了

## 混淆代码
6.设置NSInteger step = 2，此时是混淆代码
.methods.plist 的路径修改为自己电脑上这个工程methods.plist的路径
运行工程，这个需要点时间，下面有log日志

NSInteger step = 2 类似
