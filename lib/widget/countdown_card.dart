import 'package:flutter/material.dart';
import 'package:wust_helper_ios/util/countdown_util.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/toast.dart';

//添加倒计时后的卡片
class CountdownCard extends StatefulWidget {
  final String courseName; //课程名称
  final String timeData; //具体时间
  final String notes; //备注
  final String uuid;
  // Function
  CountdownCard(
      {this.courseName, this.notes, this.timeData, this.uuid, Key key})
      : super(key: key);

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      ///单击显示具体倒计时信息
      onTap: () {
        showCountdownCard(
          context,
          "修改倒计时",
          false,
          uuid: widget.uuid,
          courseNameContent: widget.courseName,
          examTimeContent: widget.timeData,
          notesContent: widget.notes,
        );
      },

      ///双击显示删除界面
      onLongPress: () async {
        bool isDel = await showSendDialog(context, " ", "确定删除此项倒计时") ?? false;
        if (isDel) {
          await delCountdownRequest(widget.uuid);
          showToast('删除成功~');
          setState(() {});
        }
      },
      child: Container(
        height: 120,
        width: 0.9 * screenWidth,
        margin:
            EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 25.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.courseName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
                child: Text(
                  widget.timeData,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
              ),
              Text(
                widget.notes,
                maxLines: 1, overflow: TextOverflow.ellipsis, //字体溢出部分
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  // overflow: TextOverflow.ellipsis //字体溢出部分
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
