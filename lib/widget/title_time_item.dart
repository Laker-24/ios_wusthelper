import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/provider/title_time_provider.dart';

class TitleTimeItem extends StatelessWidget {
  const TitleTimeItem({
    Key key,
    // @required this.currentWeekdayIndex,
    @required this.weekdayList,
    // @required this.dateList,
    @required this.index,
  }) : super(key: key);

  // final int currentWeekdayIndex;
  final List<String> weekdayList;
  // final List<String> dateList;
  final int index;

  @override
  Widget build(BuildContext context) {
    //具体日期
    List dateList =
        context.select<TitleTimeProvider, List>((value) => value.titleTime);
    //当前日期
    int currentWeekdayIndex =
        context.select<TitleTimeProvider, int>((value) => value.currentWeekday);
    return Padding(
        padding: EdgeInsets.all(2),
        child: Consumer<TitleTimeProvider>(
          builder: (context, value, child) => Container(
            decoration: BoxDecoration(
                borderRadius: index == currentWeekdayIndex
                    ? BorderRadius.all(Radius.circular(10))
                    : null,
                color: index == currentWeekdayIndex
                    ? Color.fromRGBO(204, 204, 204, 0.4)
                    // : Colors.white,
                    : null),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('周' + weekdayList[index],
                      style: TextStyle(
                          fontSize: 14,
                          color: index == currentWeekdayIndex
                              ? Colors.lightBlue
                              : Colors.grey)),
                  Text(dateList[index],
                      style: TextStyle(
                          fontSize: 12,
                          //当前日期在TitleTime中突出显示
                          color: index == currentWeekdayIndex
                              ? Colors.lightBlue
                              : Colors.grey)),
                ],
              ),
            ),
          ),
        ));
  }
}
