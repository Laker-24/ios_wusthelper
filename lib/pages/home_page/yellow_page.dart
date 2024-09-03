import 'package:flutter/material.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/common.dart';

class YellowPage extends StatefulWidget {
  @override
  _YellowPageState createState() => _YellowPageState();
}

class _YellowPageState extends State<YellowPage> {
  // ignore: non_constant_identifier_names
  final DEPARTMENT_NAME_AND_TEL = {
    '学生常用': [
      '保卫处1',
      '68893272',
      '保卫处2',
      '68893392',
      '黄家湖校区综合办公室',
      '68893276',
      '洪山校区综合办公室',
      '51012586',
      '教务处',
      '68862468',
      '后勤集团',
      '68862221',
      '校医院',
      '68893271'
    ],
    '党政部门': [
      '学校办公室',
      '68862478',
      '黄家湖校区综合办公室',
      '68893276',
      '洪山校区综合办公室',
      '51012586',
      '纪委（监察处）',
      '68862473',
      '党委组织部（机关党委）',
      '68862793',
      '党委统战部',
      '68862589',
      '党委学生会工作部（武装部、学生工作处）',
      '68862673',
      '工会（妇女委员会、教代会）',
      '68863508',
      '团委',
      '68862339'
    ],
    '行政部门': [
      '研究生学位与学科建设科',
      '68862026',
      '研究生培养教育处',
      '68862116',
      '研究生招生就业处',
      '68862830',
      '人事处',
      '68862406',
      '教务处',
      '68862468',
      '教学质量监控与评估处',
      '68862055',
      '发展规划处（高等教育研究所）',
      '68862410',
      '财务处',
      '68862458',
      '审计处',
      '68862466',
      '国有资产与实验室管理处',
      '68862205',
      '基建与后勤管理处',
      '68862819',
      '国际交流合作处',
      '68862606',
      '离退休工作处（离退休党委）',
      '68864266',
      '保卫处（党委保卫处）',
      '68862246',
      '教职工住宅建设与改革领导小组办公室',
      '68862967',
      '采购与招标管理办公室',
      '68862385'
    ],
    '直属单位': [
      '工程训练中心',
      '68893669',
      '现代教育信息中心',
      '68862211',
      '图书馆',
      '68862220',
      '档案馆',
      '68862017',
      '学报编辑部',
      '68862317',
      '后勤集团',
      '68862221',
      '资产经营有限公司（科技园有限公司）',
      '68863373',
      '校医院',
      '68893271',
      '耐火材料与冶金省部共建国家重点实验室',
      '68862085',
      '国际钢铁研究院',
      '68862772',
      '绿色制造与节能减排中心',
      '68862815',
      '继续教育学院（职业技术学院）',
      '51012585',
      '附属天佑医院',
      '87896186'
    ]
  };
  // ignore: non_constant_identifier_names
  final Map DEPARTMENT_IMAGE = {
    '学生常用': 'assets/images/student.png',
    '党政部门': 'assets/images/government.png',
    '行政部门': 'assets/images/administration.png',
    '直属单位': 'assets/images/department.png'
  };

  // ignore: non_constant_identifier_names
  final Map<String, List<Color>> DEPARTMENT_COLOR = {
    '学生常用': [
      Color.fromRGBO(26, 178, 168, 0.3),
      Color.fromRGBO(26, 178, 168, 0.2),
    ],
    '党政部门': [
      Color.fromRGBO(216, 30, 6, 0.3),
      Color.fromRGBO(216, 30, 6, 0.2),
    ],
    '行政部门': [
      Color.fromRGBO(124, 186, 89, 0.3),
      Color.fromRGBO(124, 186, 89, 0.2),
    ],
    '直属单位': [
      Color.fromRGBO(239, 179, 54, 0.3),
      Color.fromRGBO(239, 179, 54, 0.2),
    ]
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('黄页'),
          elevation: 0,
          // backgroundColor: appBarColor,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(children: _buildTile()));
  }

  List<Widget> _buildTile() {
    List<Widget> _items = [];
    DEPARTMENT_NAME_AND_TEL.keys.forEach((key) {
      _items.add(item(key, DEPARTMENT_NAME_AND_TEL[key]));
    });
    return _items;
  }

  Widget item(String key, List<String> list) {
    return ExpansionTile(
        title: Text(key),
        leading: Stack(alignment: Alignment.center, children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    width: 2,
                    color: DEPARTMENT_COLOR[key][0],
                    style: BorderStyle.solid)),
          ),
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    width: 2,
                    color: DEPARTMENT_COLOR[key][1],
                    style: BorderStyle.solid)),
          ),
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset(DEPARTMENT_IMAGE[key]),
          )
        ]),
        textColor: Colors.green[400],
        children: list.asMap().keys.map((index) {
          if (index % 2 == 0) {
            return _buildItem(key, index);
          } else
            return Container();
        }).toList());
  }

  Widget _buildItem(String key, int index) {
    return FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
            padding: EdgeInsets.only(left: 30, right: 50),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  child: Image.asset('assets/images/phone.png'),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black26))),
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            DEPARTMENT_NAME_AND_TEL[key][index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Text(
                          '027-' + DEPARTMENT_NAME_AND_TEL[key][index + 1],
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ))
              ],
            )));
  }
}
