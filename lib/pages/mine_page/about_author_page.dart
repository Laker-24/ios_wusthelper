import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';

///   [作者介绍页面]

// ignore: must_be_immutable
class AboutAuthorPage extends StatelessWidget {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作者介绍'),
        // backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebView(
        initialUrl: 'http://lh.wuster.vip/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
          showHtml();
        },
      ),
    );
  }

  showHtml() {
    _controller.loadUrl(Uri.dataFromString(aboutAuthorHtml,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

String aboutAuthorHtml = '''
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
        content="initial-scale=0,maximum-scale=0, minimum-scale=0,width=device-width,height=device-height">
    <title>关于我们</title>
    <style>
        html,
        body,
        div,
        span,
        applet,
        object,
        iframe,
        h1,
        h2,
        h3,
        h4,
        h5,
        h6,
        p,
        blockquote,
        pre,
        a,
        abbr,
        acronym,
        address,
        big,
        cite,
        code,
        del,
        dfn,
        em,
        font,
        img,
        ins,
        kbd,
        q,
        s,
        samp,
        small,
        strike,
        strong,
        sub,
        sup,
        tt,
        var,
        b,
        u,
        i,
        center,
        dl,
        dt,
        dd,
        ol,
        ul,
        li,
        fieldset,
        form,
        label,
        legend,
        table,
        caption,
        tbody,
        tfoot,
        thead,
        tr,
        th,
        td {
            margin: 0;
            padding: 0;
            border: 0;
            outline: 0;
            font-size: 100%;
            vertical-align: baseline;
            background: transparent;
        }

        body {
            line-height: 1;
        }

        ol,
        ul {
            list-style: none;
        }

        blockquote,
        q {
            quotes: none;
        }

        blockquote:before,
        blockquote:after,
        q:before,
        q:after {
            content: "";
            content: none;
        }

        /* remember to define focus styles! */

        :focus {
            outline: 0;
        }

        /* remember to highlight inserts somehow! */

        ins {
            text-decoration: none;
        }

        del {
            text-decoration: line-through;
        }

        /* tables still need "cellspacing="0"" in the markup */

        table {
            border-collapse: collapse;
            border-spacing: 0;
        }

        body {
            background-color: #fff;
        }

        header,
        section,
        footer,
        aside,
        nav,
        article,
        figure {
            display: block;
        }

        header {
            position: fixed;
            top: 0;
            height: 50px;
            width: 100%;
            border-bottom: solid 1px black;
            background-color: #fafafa;
            /* #f9f9f9 */
        }

        .head {
            height: 30px;
            text-align: center;
            vertical-align: middle;
            padding-top: 15px;
            overflow: hidden;
        }

        .head>a,
        .head>h2 {
            display: block;
            float: left;
        }

        .head>a {
            width: 50px;
        }

        .head>h2 {
            width: 80px;
            font-weight: lighter;
        }

        .main {
            margin: 0;
            padding: 20px;
        }

        .desc>img {
            width: 100%;
            margin-bottom: 10px;
        }

        .desc>.name {
            text-align: center;
            color: #99c5ff;
            font-size: large;
        }

        .develop_team {
            overflow: hidden;
        }

        .develop_team_name {
            text-align: center;
            height: 30px;
            line-height: 30px;
            background-color: #7bb8ff;
            color: white;
            width: 80%;
            border-radius: 15px;
            margin: 20px auto;
        }

        .develop_team_name>p {
            vertical-align: middle;
        }

        .develop_team_member {
            color: #3c95ee;
            padding-left: 3px;
            margin-bottom: 20px;
        }

        .develop_team_member>h2 {
            font-weight: 500;
            font-size: 18px;
            padding-bottom: 5px;
        }

        .develop_team_member>p {
            text-indent: 2rem;
            font-size: 15px;
            line-height: 25px;
        }

        .develop_process {
            position: relative;
            overflow: hidden;
            padding: 4px 10px;
        }

        .develop_process>.time_line {
            height: 800px;
            border-right: solid #ccff99 2px;
            border-radius: 2px;
            position: absolute;
            top: 0px;
            left: 14px;
        }

        .develop_event {
            margin-left: 20px;
            font-size: large;
            color: #3c95ee;
        }

        .develop_event>li {
            display: block;
            margin-top: 20px;
            font-size: 18px;
            font-weight: lighter;
            overflow: hidden;
        }

        .develop_event .version {
            color: #000;
        }

        .develop_event_time {
            float: left;
            font-size: 12px;
            margin-left: 10px;
            width: 50px;
            padding-top: 10px;
            color: gray;
        }

        .develop_event_time::before {
            content: "\\02022";
            color: #f66;
            position: absolute;
            margin-left: -30px;
            margin-top: -10px;
            font-size: 30px;
        }

        .develop_event>li>div {
            margin-left: 80px;
            font-size: 15px;
        }
    </style>
</head>

<body>
    <!-- <header>
         <div class = "head">
        <a><i><-</i></a>
        <h2>作者介绍</h2>
    </div>
      </header> -->
    <article class="main">
        <div class="desc">
            <img
                src="data:image/jpg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAIMA/EDASIAAhEBAxEB/8QAHQABAAEFAQEBAAAAAAAAAAAAAAQCAwUGBwEICf/EAFEQAAEDAwMBBQUDCQUGAwcDBQEAAgMEBREGEiExBxNBUWEiMnGBkRRSoRUjMzRCscHR8CRicnPhCBY2Q8LxNTdTJURjdIKSshcmsydFg5Py/8QAGwEBAAMBAQEBAAAAAAAAAAAAAAECAwQFBgf/xAA1EQACAgEDAwIDBwQDAAMBAAAAAQIRAwQhMRJBUQUTImGRFDJxgaHR8CNCscEz4fEGFVJy/9oADAMBAAIRAxEAPwD6LREW5yhERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEUO43OitsJluFXDTxjnMjw1aBqbtctNsjpnW6CavbUPLI5W+zGcEA4J6qUrFHS0VuB/ewRyEY3NDsfEK4oAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAERQrldKC1wOmuNZT0sQ6ulkDR+KAmrwkAZPAXI9SduVkoS6Oy089ykHR5HdR/UjP4Ljure0XUGpnPZU1RgpHdKeHhvz8SrKDYPo/VHaNprTmWVdeyepH/Ip/wA47544HzK5jde3N9XVNhoaR1FRk4dOfzkoHmG8D6rl2ntGah1Ed1rtk8sXjM8bIx8XOwFCorBda+4yUNvoairqY3ljmwML+QcHp4cK6jEknXnVVbczcG1chq/tLhsln5dG0HjA6AnxWHoXvkrKSNxe9jZGhrAfN3QLfKTsxfQRtqda3qgsFMee6e8S1Dv8Mbf5/JancobZFqdsVinqKu3iVgjkkZse/kZwOcc9FZNdg0+59n0X6nB/lt/cr6sUX6nB/lt/cr6wIfIREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREARFp/ajqqbSOmXXClgbNMZBG0OPDc+JRbg257msaXPcGtHUk4C0zU/aZprT73xT1zaipb1ip/bIPqRwvmrUmudQahkca+4zCI9IY3FrB8grGm9IXzUjXS2uidJA0kPqHuDY2nxy4/HwVpKMF1TdIlJt0jf9Wdtt0r3PiscDaKnPG9/tPP8lzJ7rrqCu3u+13CqecZO6R3J6ei6Np/QVmhqQyrq579Wj/3S1RGRgd5Ok93HzC2Sx0MmiaWpju17oLEyWV0/wBmp/z1W1mPcO3O39yrDNGV9CZd42uTSrV2UXV0DKjUFZR2SBwyG1L/AM6f/oHK6DpbSVltTDNabO64Ob//AHG74gpx/ha7r8cKll8porfBcLRS0lJRS5LbtfJQ6WbDiCWR8uODnwWoX/XNsMjn1E9TqOsPG6oBjpmeW1nj+CtcpDZGzXC719w1a+jrTPf7UyDiC1kxwtf90u4BA8yrd51V+TKVtJJcaLT1G1vs0FqAlnPPVzhw0+mVz6mq9XaymFHZaaqNNnAgpGFkTB6noPmVnKTszorRM060vUEM5G77BRZnncM85DeiOKXITb4NH1bcqG6XPv7dBPHHtw507975HfeKxdvGa+mGN2ZWjGcZ5C3XVemaI1r6m2N/Jdpjia1n2xw7yRwzk4B8VpVFhtdBkbmiRvHnytITjJfCMmKeNrrVWfcVF+pwf5bf3K+otrkbNbaSVmdr4mOGfIgKUsTN8hERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREARFWyMuGSQ1vTJQFCKuaMxP2uweMghUIAiIgCIiALmn+0AP8A+n83+axdLXPe3T/y/rfl+9THkI4doGh+0aW1LUCzUdY6Gmk/tVRK1pgGw8saeS7ywsVqG71VHqq7U5kkfQMuc0jqXeQx/wCcOQQPPAWW0HRsqNJallNoirHxQPIqJpQ1sA2HkA9XeS1jWP8AxdfP/np//wCRy0SuTstdI6ZV9ogq7Ywur47XQkHZbrY0teB02ucDz88LTbhq3vo5qWyW5sLJmljpHDdK7Pw8efVQtBWalvV7bBcGVjqYNJIpYy9xPgF2ent7dP047intmlqUdamtc2SqI8SByQuXJ8MulRcn89l/39GdcM8lD4aj+HL/AG/KkcbtGkbjX3ant9ymjtO+n+0tfcCY2tj3EZ9MnK6rpHRGnaOMSUFvqdVVTTh1Q9vc0bD6Ofw4LD3vXGlLZUOnt1E/UV35/t1wBLG85Aa08YyTjAWsV941pr5xZH9rkogdoii9iBg8j0HHqt11yXxbHN8Kexsd31/UfaK2iuVYLbTUkphZb7UMNkAx1eMbh1HOFqFZrGXJhsFEykaeN+0Pkf15Prz6/FZC06Lt1LIBfK41dXkYt9sHfSH0c4cNW1gmxxsNNFbNJwHpLORLWO+XJGRkcYVXjg3vv/j6f+m8dRkhHph8PzXP17flSOT3yhu9M6CovUFVG+qaXxuqAQXgeIz4cqDSAishBGDvb+9dCuur7JRz97bqOS9XLA3V9zJfz47WHjHxC0aeumuV5FXVFpmllDnbWho6+AHAW8fwOaW7uz7R0/8A+A23/wCWj/8AxCyCx+n/APwG2/8Ay0f/AOIWQXOirCIikBERAERYu7X+1WlpNwroIXZA2F2XEnoAOqAyiLke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jD2ztA6O4P1V1FDVllJouR3OEnbMHRO/vDj6qa1zXjLSCPMFY1zQ4YcAR6qOKYxO3U0joj5DkH5KriXWRdzNosYyvmhAFRDvbn34+ePgpkFXBNwyRu77p4P0VaounZzrtM1bqS31klp05pueuMkX605uYySPADrjPotF7Mey/VtDqK33u51MVJHHK2WSF8hc97eMjA4B8OfJfQyKym4qkVcFJ2z5g7aIG6e1nUvlbllZtmjDB4A8/wBcL6SsbzJZqF7iHF0LDkfALj3bp2fag1Xf6Css0cU0DYu6cHSbSw56n0XXdN0U1tsFvoql4fNBAyN7h0JA5V8mTqikzHDpoYZylHuZFERYnSEREARFTJIyNu6RzWt8ycIDyeGOojMczGyMPVrhkFURUlPC3EUMbB14aFGlucZyKZjpnDjjgfVRZftVSMTSCOM9Ws8fmpSbIbS5MjUVsFOPbkGfBreSfkokldPLxBD3Y6b5D/BW4aeOEew3nzPJV1WUTN5PBHNMZHbqiR0p8jwPor7WhrQGgADoAvUVkqKNt8hERSQEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAUSRskbtkaHDyKtRxzU/6tNho6MeMhSEUVZKk1wetuRYcVMLm/3m8hTYaiKcZika4ehUFWJKWN5LgCx/3m8FVcS6yeTMrx7dzHNzjIwsVFPV04AO2dg8zhylRXKne7a9xif5SDCq00aJp8Gv1ForGPcRHvbnqDyV5S2etkLO8Y1n3iT0K2syxgZL2gYznKhy3KIHbA107v7g4+qWSTWDaxo8hhWp6qGD9LI1p8s8rHSSVdRnc4Qs8m8lUxU0cZJA3OPVzuSpUWUc0i/JcJJOKaE4++/gY+CjvhkqOaqUu/ut4apCKyikUc2yljGxt2saGjyCqRFYoEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBWpYIpf0jAT5+Kuoguiww1dNxDIJYx+zIefgCpTLnEMCpY+B3T2hlufQhULwgOBDgCD4FVcUXWR9zJMc17QWODgfEFerCmlDXboHuhd1yw8H5K7FW1MPFRH3rc+8zr9FVxZoppmVRQ2XOkcMmYNPk7gq3NcgfZpY3Snz6AfNVLGQUeorIIDh7wX/dbyfosa5tTUEGolLG5z3cZx9SrkMMcLcRsDQrKLKOaRVLWVM52wR9yz77+v0VhtKC8STvdNJ95x/gpKK6ikZubZ4AB0XqIpKhERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAVL2Ne0h7Q4HwKqRARhRU4cT3Y58PBSGtDWgNAAHQBeogbb5CIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiIAiIgCIiAIiICksYTktaT6hejgcL1EAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQBERAEREAREQH//Z">
            <div class="name">@领航工作室</div>
        </div>
        <div class="develop_team">
            <div>
                <div class="develop_team_name">
                    <p>iOS</p>
                </div>
                <div class="develop_team_member">
                    <h2>前端开发组 江洪</h2>
                    <p>负责iOS端2.0版本的重构与功能开发</p>
                </div>
            </div>
            <div>
                <div class="develop_team_member">
                    <h2>前端开发组 涂安龙</h2>
                    <p>负责iOS端2.0版本的重构与功能开发</p>
                </div>
            </div>
            <div>
                <div class="develop_team_member">
                    <h2>前端开发组 张晓辉</h2>
                    <p>负责iOS端2.0版本的重构与功能开发</p>
                </div>
            </div>
            <div>
                <div class="develop_team_member">
                    <h2>前端开发组 褚江江</h2>
                    <p>负责iOS端各项功能的开发。</p>
                </div>
            </div>
            <div>
                <div class="develop_team_member">
                    <h2>安卓开发组 纪宇琛</h2>
                    <p>负责iOS端应用的重新开发。</p>
                </div>
            </div>
        </div>
        <div class="develop_process">
            <div class="time_line "></div>
            <ul class="develop_event">
                <li>
                    <span class="develop_event_time">
                        2019-01
                    </span>
                    <div>1.0版本正式上线 作者褚江江</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2019-02
                    </span>
                    <div>1.0.3版本上线，修复图书馆借阅记录超时不友好显示的问题。修复学分统计不准确的问题。改进部分ui。作者褚江江。</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2019-03
                    </span>
                    <div>1.0.4版本上线，优化和改进课程表部分，改进ui。作者褚江江</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2020-04
                    </span>
                    <div>2.0版本正式上线，重构了应用代码，重写大部分UI界面，改进了交互。修改成绩与学分统计算法，修复老版本课程表存在的bug，更新图书馆模块，新增校历、考试提醒、工时查询功能。作者张晓辉
                    </div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2020-07
                    </span>
                    <div>修复绩点页面、图书馆页面、校历页面的问题。完善工时查询的功能。作者江洪</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2021-06
                    </span>
                    <div>3.0版本上线。在保留Ui风格的基础上，抛弃原有代码，使用纯flutter对iOS端进行了重新设计与开发。作者纪宇琛。
                    </div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2021-06
                    </span>
                    <div>3.3版本上线。新增iOS桌面小组件，作者纪宇琛。</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2022-05
                    </span>
                    <div>3.4版本上线，修复了部分绩点和课程显示错误的bug，新增物理实验课表，添加自定义背景模块。作者高新宇。</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2022-08
                    </span>
                    <div>3.6版本上线，新增研究生登录、成绩图表、培养方案模块，更新图书馆、失物招领、校园模块，优化了部分ui。作者高新宇。</div>
                </li>
                <li>
                    <span class="develop_event_time">
                        2023-05
                    </span>
                    <div>3.7版本上线，新增情侣课表，深色模式，更新志愿者模块，修复周数显示bug，优化了部分ui。作者刘新武。</div>
                </li>
                                <li>
                    <span class="develop_event_time">
                        2023-05
                    </span>
                    <div>3.7.1版本上线，成绩刮刮乐。作者刘新武。</div>
                </li>
            </ul>
        </div>
    </article>
    <footer>
    
    </footer>
</body>

</html>
''';
