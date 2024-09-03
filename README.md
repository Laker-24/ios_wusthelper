# iOS武科大助手文档



## 基础知识





#### 保持页面状态

因为底部导航栏的存在，每当我们点击其切换后，当前页面将被移出widget树并销毁，当返回时再重新创建并渲染，显然它将抹除掉原有的状态导致不良的用户体验，所以我们选择混入 AutomaticKeepAliveClientMixin 类，重写其中的 wantKeepAlive 方法，以在任何时候保存其状态，

哪个页面需要保持页面状态，就在这个页面进行混入。

不过使用这个 Mixin 是有几个先决条件的：

- 使用的页面必须是 StatefulWidget，如果是 StatelessWidget 是没办法办法使用的（很显然，毕竟是stateless，何谈state）。

- 其实只有两个前置组件才能保持页面状态：PageView 和 IndexedStack。

- 重写 wantKeepAlive 方法，如果不重写也是实现不了的（具体使用参考下附文章）。

  

FutureBuilder的解决方案：在initState中预先获取并保存所需的future，否则将在build时重新发送获取数据的请求将使该状态保持毫无意义（绝大多数情况）。



参考：https://www.shuzhiduo.com/A/xl56n1645r/  切换后页面状态的保持

​			https://www.jianshu.com/p/db7ed17a4273   AutomaticKeepAliveClientMixin 基本原理

​			https://juejin.cn/post/6934960833798045732 FutureBuilder如何避免不必要更新





#### 关于 SafeArea

不要滥用，有AppBar几乎可以不用（因其自带类似效果），因为AppBar的颜色与默认填充颜色不一致





#### 关于列表

GridView.builder  在 gridDelegate 属性中通过 SliverGridDelegateWithFixedCrossAxisCount  中的 crossAxisCount 指定每个横行的元素个数，他们会均分GridView所占用的宽度，此时他们的宽度已经固定，再通过 childAspectRatio 设置宽长比（宽/高）来确定它的高度。



 

## 网络请求



 **概览** ：网络层所有文件均在HTTP文件夹中，下简要介绍个别文件：



#### *core 为关键文件，但处于底层，日常使用时透明*

 ***hi_net.dart***

  - HiNet 为单例，当且仅当单例不存在时，创建
  - fire 方法：发送请求，处理网络请求结果，对非业务逻辑错误进行处理，如网络请求成果则返回response数据部分，如不成功返回异常数据部分

  * send 方法：调用**网络请求库适配***进行网络请求，并返回请求数据

*网络请求库适配：其意义在于与业务代码解耦，令网络请求库本身对上层应用透明，当更换新库时仅需为其创建一个新适配即可，无需修改业务代码

*注意：fire中仅解析Http状态码，即网络请求本身成果与否，而非业务状态码



***base_net_adapter.dart***

* 其中接口BaseNetAdepter定义了send方法，要求其子类必须实现
* BaseNetResponse定义了BaseNetAdepter即网络层返回格式



***mock***

所谓mock数据，主要应用于后台接口未完成时的前端测试，模拟网络请求的数据，在请求后使用mock数据进行返回。



***dio_adepter.dart***

继承自BaseNetAdepter，利用DIO库方法实现send方法，收到请求数据后构建BaseNetResponse进行返回



####  *request 定义了每个接口的请求信息*

***base_request.dart***

* 定义请求方法枚举类HttpMethod，用以未来进行判断
* 抽象类BaseRequest定义了请求格式及相关方法，其中代码注释较为详细，可自行查看代码
* 实现时需实现httpMethod、path、needLogin三个方法，其中path仅需填后续路径即可，领航域名已在authority方法中返回
* 每使用一个接口需要创建一个新request进行请求定义

 

#### *dao 为请求枢纽，进行请求分发和返回后数据处理*

* 枚举类RequestType用以在send函数中判断请求类型
* 在JwcDao中定义静态方法用以在外部使用
* 为保证代码复用性，在_send方法中对RequestType进行判断，创建对应请求进行发送
* 由于登陆的特殊性，单独对其进行判断并添加参数
* 因不再使用结合登陆，故选择在请求课表数据时进行学期的刷新
* 当登陆请求成功时，对token进行保存



**关于Token检查**：截至该文档撰写时，领航token的有效期为3天，故当进行需要登陆操作时，应先检查token有效性，若已失效则应重新登录。另出于安全考虑本不应明文保存用户账号密码，最好在后续版本中进行加密保存

## 课表



#### 时刻表与课表中GradView的使用

通过 flex 参数设置时刻表与课表的宽度比为1:10，故如希望高度相匹，childAspectRatio（详见基础知识） 中的比例应进行计算。

#### firstLoad 函数

该函数用于在页面渲染完成后，执行仅在应用启动后需要而无需在每次页面构建后都执行的操作（如弹出公告、更新信息）。控制变量位于Navigator根部（BaseRouteDelegate），用以判断是否为其传递所需操作。

##  进行flutter开发的建议
* 目前助手使用的flutter sdk是2.2.0（并未适配空安全），截止现在flutter sdk已经更新到3.3.0
考虑到以后使用插件时与flutter sdk适配冲突的问题，可以考虑升级一下，并给助手适配空安全
#### 在这里给一些建议：
* 如果需要使用占位组件，尽量用SizedBox来代替Container，使用if语句而不是三元运算符 举例：
isLoaded ? Container(): 你的组件 
if(isloaded) 你的组件
* 尽量避免在build方法中进行重复或者复杂的方法
* flutter sdk 2.5.0后，如果有些地方不加const会报蓝，在适当的地方加入const可以优化性能，可以把一些组件当作编译时常量(可以多使用const)
* 在不需要状态的组件，尽量使用statelesswidget
* 避免使用无用的container或者sizedbox
* provider不要滥用，简单的可以用回调函数或者传参实现 

## 版本改动

*3.6.0*
  改动：
物理实验课表高度变大
课表显示最新和提示
图表统计（成绩图表）
更改了page文件夹中的一些文件位置(分散开)
banner一张图时不动
把学分统计换成培养方案
给失物招领添加cookie
添加失物招领公告
支持ios侧滑返回页面
将学分统计改为培养方案
添加研究生适配
优化了加载时的进度图标
上线图书馆
设置培养方案和查询成绩的请求时间

## 报错汇总



##### iOS Validate App 报错

*error*： The server returned an invalid response. This may indicate that a network proxy is interfering with communication, or that Apple servers are having issues. Please try your request again later

*解决办法*：看看你app connect的登陆态是不是掉了


## 需求集合

*成绩图表   (进入测试)

*倒计时    (建议优化功能后再进行开发，倒计时当时也写了点，有参考价值的话可以看看)

*物理实验课表  (进入测试)

*解决SafeArea顶部出现白条   

*图书馆       （进入测试）

*研究生系统  （进入测试）

*培养方案导入 (进入测试)

*登录请求学号密码加密问题

*情侣课表



*可以给成绩按学期进行排序后显示

*培养方案的获取可能遇到教务处崩的情况，我们这边不好判断，所以要和后端的同学们商量好，不然用户只能重新登陆再次获取（或者等一个月0.0）


## 其他想法（不要紧，用户的一些小需求）

*适配深色主题 

*重构更新版本逻辑
中间数字更新时，可在 “我”图标处画一个红色圆点表示可更新，不从页面处提示更新，方便用户查看课表

*小组件添加背景

## bug汇总


## git相关

*mac电脑git的方法* 参见博客 https://blog.csdn.net/weixin_42280089/article/details/88937175

*强制推送覆盖指令* git push origin master --force

## Mac小知识

*截屏：按下键盘上的Shift + Command ⌘ + 5，然后选取捕捉整个屏幕、App窗口或者特定区域。

*免受通知打扰：打开“控制中心” ￼，点按“专注模式”，然后选取“勿扰模式”。稍后若要查看通知，请点按菜单栏中的日期和时间。

*整理桌面:将桌面上的文件按文件类型、日期或标签整齐分组。按下Control键并点按桌面，然后选取“使用叠放”。若要更改文件分组方式，请选取“叠放分组方式”。
*快速查看:若要在不打开文件的情况下查看其预览，请选择文件，然后按下空格键。

