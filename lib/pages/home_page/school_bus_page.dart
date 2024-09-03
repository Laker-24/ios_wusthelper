/*
 * 
 * 
 * 
 *   校车时刻表
 * 
 * 
 * 
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';

class SchoolBusPage extends StatefulWidget {
  @override
  _SchoolBusPageState createState() => _SchoolBusPageState();
}

class _SchoolBusPageState extends State<SchoolBusPage> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('校车时刻表'),
          elevation: 0,
          // backgroundColor: appBarColor,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
            showHtml();
          },
        ));
  }

  showHtml() {
    _controller.loadUrl(Uri.dataFromString(htmlcontent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

String htmlcontent = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>武汉科技大学校车表</title>
    <style>
        /* body{
            background:'#f4f5f7';
            text-align: center
        } */
        *{
            margin: 0;
            padding: 0;
            border:0;
        }
        .header{
            width: 100%;
            height: 90px;
        }
        .header_title{
            width: 100%;
            font-size: 20px;
            font-weight: '500';
            text-align: center;
            line-height: 80px;
            height: 60px;
            color:#6fafff
        }
        .header_time{
            width: 100%;
            font-size: 30;
            text-align: center;
            line-height: 20px;
            height: 30px;
            color:rgb(150,150,150);
        }
    </style>
</head>
<body>

    <div class = "header">
        <div class = "header_title">武科大校车运行表</div>
        <div class = "header_time">执行时间：2017年9月11日起</div>
    </div>




    <table style = "width: 100%;border:1px solid #6fafff;" cellpadding="0" cellspacing="0">



        <tr style = "width: 100%;height: 50px;">
            <td style = "width: 33.3333333333%;border-bottom:1px solid #6fafff;border-right:1px solid #6fafff; text-align: center;color:rgb(100,100,100)">运行时间</td>
            <td style = "width: 33.3333333333%;border-bottom:1px solid #6fafff;border-right:1px solid #6fafff; text-align: center;color:rgb(100,100,100)">始发站</td>
            <td style = "width: 33.3333333333%;border-bottom:1px solid #6fafff;text-align: center;color:rgb(100,100,100)">终到站</td>
        </tr>



        <tr style = "width: 100%;">
            <td style = "text-align: center;border-right:1px solid #6fafff;color:rgb(80,80,80);">周一到周五</td>
            <td colspan="2">
                    <table id = "time_data" style = "width: 100%;" cellpadding="0" cellspacing="0">
                           
                    </table>
            </td>
        </tr>


        <tr style = "width: 100%;">
            <td style = "text-align: center;border-right:1px solid #6fafff;border-top:1px solid #6fafff;color:#6fafff">周末</td>
            <td colspan="2">
                    <table id = "time_data_1" style = "width: 100%;" cellpadding="0" cellspacing="0">
                           
                    </table>
            </td>
        </tr>



        <!-- <tr></tr> -->



    </table>
    <div style = "height: 50px;"></div>
    <th></th>
    <tr></tr>   
</body>

<script>
    console.log('111')
        let weekday = [
            {
                start:'青山校区',
                end:'黄家湖校区',
                time:['6:30','6:50','8:30','12:50','14:20','17:30']
            },
            {
                start:'黄家湖校区',
                end:'青山校区',
                time:['6:40','10:15','12:10','16:10','17:00','17:55','20:50']
            },
            {
                start:'洪山校区',
                end:'黄家湖校区',
                time:['6:30','6:40','6:50 ','8:50','13:00']
            },
            {
                start:'黄家湖校区',
                end:'洪山校区',
                time:['10:15','12:10','16:10 ','17:00','17:55']
            },
            {
                start:'青山校区',
                end:'洪山校区',
                time:['7:00','12:00','16:10 ','17:20']
            },
            {
                start:'洪山校区',
                end:'青山校区',
                time:['7:00','9:10','13:10 ','17:20']
            }
        ]
        let weekend = [
            {
                start:'青山校区',
                end:'黄家湖校区',
                time:['6:50']
            },
            {
                start:'黄家湖校区',
                end:'青山校区',
                time:['17:00']
            },
        ]



        var weekdayDoc = document.getElementById('time_data')
        var weekendDoc = document.getElementById('time_data_1')




        for(let i in weekday){
            var tbody1 = document.createElement('tbody')
            weekdayDoc.appendChild(tbody1)
            tbody1.insertRow(0)
            tbody1.insertRow(0)
            tbody1.insertRow(0)
            tbody1.rows[0].insertCell(0)
            tbody1.rows[0].insertCell(0)
            tbody1.rows[1].insertCell(0)
            tbody1.rows[0].cells[0].appendChild(document.createTextNode(weekday[i].start))
            tbody1.rows[0].cells[1].appendChild(document.createTextNode(weekday[i].end))
            tbody1.rows[1].cells[0].appendChild(document.createTextNode('发车时间'))
            tbody1.rows[0].cells[0].style = 'text-align:center;border-bottom:1px solid #6fafff;border-right:1px solid #6fafff;border-top:1px solid #6fafff;color:#71b14f'
            tbody1.rows[0].cells[1].style = 'text-align:center;border-bottom:1px solid #6fafff;border-top:1px solid #6fafff;color:#d31b08'
            tbody1.rows[1].cells[0].style = 'text-align:center;'
            tbody1.rows[1].cells[0].colSpan = '2'
            tbody1.rows[0].style = 'height:40px;'
            tbody1.rows[1].style = 'height:40px;'

            tbody1.rows[2].insertCell(0)
            tbody1.rows[2].cells[0].style = 'width:100%;height:30px;border-top:1px solid #6fafff;color:rgb(80,80,80)'
            tbody1.rows[2].cells[0].colSpan = '2'



            for(var j in weekday[i].time){
                var divDoc = document.createElement('div')
                tbody1.rows[2].cells[0].appendChild(divDoc)
                divDoc.appendChild(document.createTextNode(weekday[i].time[j]))
                divDoc.style = 'float:left;width:25%;text-align:center;height:40px;line-height:40px;color:rgb(80,80,80)'
            }
        }



        for(let i in weekend){
            let tbody1 = document.createElement('tbody')
            weekendDoc.appendChild(tbody1)
            tbody1.insertRow(0)
            tbody1.insertRow(0)
            tbody1.insertRow(0)
            tbody1.rows[0].insertCell(0)
            tbody1.rows[0].insertCell(0)
            tbody1.rows[1].insertCell(0)
            tbody1.rows[0].cells[0].appendChild(document.createTextNode(weekend[i].start))
            tbody1.rows[0].cells[1].appendChild(document.createTextNode(weekend[i].end))
            tbody1.rows[1].cells[0].appendChild(document.createTextNode('发车时间'))
            tbody1.rows[0].cells[0].style = 'text-align:center;border-bottom:1px solid #6fafff;border-right:1px solid #6fafff;border-top:1px solid #6fafff;color:#71b14f'
            tbody1.rows[0].cells[1].style = 'text-align:center;border-bottom:1px solid #6fafff;border-top:1px solid #6fafff;color:#d31b08'
            tbody1.rows[1].cells[0].style = 'text-align:center;'
            tbody1.rows[1].cells[0].colSpan = '2'
            tbody1.rows[0].style = 'height:40px;'
            tbody1.rows[1].style = 'height:40px;'

            tbody1.rows[2].insertCell(0)
            tbody1.rows[2].cells[0].style = 'width:100%;height:30px;border-top:1px solid #6fafff;color:rgb(80,80,80)'
            tbody1.rows[2].cells[0].colSpan = '2'



            for(var j in weekend[i].time){
                var divDoc = document.createElement('div')
                tbody1.rows[2].cells[0].appendChild(divDoc)
                divDoc.appendChild(document.createTextNode(weekend[i].time[j]))
                divDoc.style = 'float:left;width:25%;text-align:center;height:40px;line-height:40px;'
            }
        }
</script>
</html>
''';
