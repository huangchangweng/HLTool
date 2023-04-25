# HLTool

iOS开发工具类集合

##### 支持使用CocoaPods引入, Podfile文件中添加:

```objc
pod 'HLTool', '1.0.5'
```

如果想全局替换HLTool的图片资源，可以在工程中新建一个名字为`HLTool.bundle`的bundle，参照pod中`HLTool.bundle`为图片资源命名。HLCategorys会优先加载当前工程中的图片资源。

# GlobalSetting

如果您项目中多个地方使用到该组件，您可以全局设置样式，例在`AppDelegate`添加

```objc
// 全局设置UIScrollView+HLEmptyDataSet样式
[UIScrollView appearance].hl_noDataText = @"没有数据";
// 全局设置UIScrollView+HLRefresh样式
[UIScrollView appearance].hl_noMoreDataText= @"没有更多数据";
```

> 注意：`代码` > `appearance` > `interface builder`，所以appearance设置的会覆盖在xib或storyboard中设置的属性，当然`代码`会覆盖`appearance`设置

>  如果你想自定义下拉刷新gif，你可以参照HLTool demo中`CustomRefreshGifHeader`文件的设置

# Requirements

iOS 9.0 +, Xcode 7.0 +

# Dependency

- "MJRefresh", "3.7.5"
- "DZNEmptyDataSet", "1.8.1"
- "Toast", "4.0.0"
- "SPAlertController", "4.0.0"
- "MBProgressHUD", "1.2.0"
- "HXPhotoPicker", "3.2.1"
- "YBPopupMenu", "1.1.9"
- "YYCache", "1.0.4"
- "JHUD", "0.3.0"
- "AFNetworking", "4.0.1"

# Version

* 1.0.5:
  
  添加子目录

* 1.0.0:
  
  修改NSBundle问题

* 0.5.1:
  
  修改下拉刷新中还能上拉的问题

* 0.5.0:
  
  修改一进页面就展示空占位问题

* 0.4.0:
  
  修改全局类名

* 0.1.0 :
  
  完成HLTool基础搭建

# License

HLTool is available under the MIT license. See the LICENSE file for more info.
