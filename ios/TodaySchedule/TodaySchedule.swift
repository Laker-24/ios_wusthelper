//
//  TodaySchedule.swift
//  TodaySchedule
//
//  Created by 纪宇琛 on 2021/10/14.
//

import WidgetKit
import SwiftUI

//星期
let week = ["Mon.","Tues.","Wed.","Thur.","Fri.","Sat.","Sun."]

let lakeTime = [
    "08:20",
    "10:00",
    "10:15",
    "11:55",
    "14:00",
    "15:40",
    "15:55",
    "17:35",
    "19:00",
    "20:40",
    "20:50",
    "22:30"
  ]
let mountainTime = [
    "08:00",
    "09:40",
    "10:10",
    "11:50",
    "14:00",
    "15:40",
    "15:55",
    "17:35",
    "19:00",
    "20:40",
    "20:50",
    "22:30"
]

struct Provider: TimelineProvider {
    
    let initCourses = [["className": "概率论与数理统计A",
                       "teachClass": "教学班0853",
                       "teacher": "张婷",
                       "startWeek": 1,
                       "endWeek": 15,
                       "section": 1,
                       "weekDay": 3,
                       "classroom": "恒大楼三区103"]]
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),_curWeek: 1 ,_isTomorrow: false,_isLake: true,_weekday:week[2] ,courses:initCourses,colors: ["#fd999a"] )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),_curWeek: 1,_isTomorrow: false,_isLake: true,_weekday:week[2] ,courses:initCourses,colors: ["#fd999a"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let user = UserDefaults(suiteName: "group.lh.wusthelper")
        // 计算当前周所需数据
        let  anchorPoint:Int = user!.integer(forKey: "anchorPoint")
        let  anchorPointWeek:Int = user!.integer(forKey: "anchorPointWeek")
        //计算当前周
        let  toBeProcessedNum:Int = Int(Date().timeIntervalSince1970) * 1000 - anchorPoint
        
        //助手中设置周一为第一天
//        if(isMonday){
            
            // 当待加工数字为负数时意味当前为假期中，统一返回 ：-1，否则计算周数
        let _currentWeek:Int  = Int(toBeProcessedNum < 0  ? -1 : Int(floor(Double(toBeProcessedNum / (1000 * 60 * 60 * 24 * 7)))) + anchorPointWeek)
//        }else{
//            let currentWeek:Int = (toBeProcessedNum / (1000*60*60*24*6))+anchorPointWeek
//            if(toBeProcessedNum<0){
//                let _currentWeek:Int = -1
//            }else if(currentWeek == 2){
//                let _currentWeek:Int = currentWeek;
//            }else {
////                toBeProcessedNum = Date().timeIntervalSince1970 -Date().
//            }
//
//        }
        
        let _isLake = user!.bool(forKey: "isLake")
        let _comps = Calendar(identifier: .gregorian).dateComponents([.weekday,.hour], from: Date())
        var coursesList:[Dictionary<String,Any>] = createCourses(user: user,currentWeek: _currentWeek,comps: _comps)
        let courseColors:[String] = getCourseColor(user: user, courses: coursesList)
        
        // 按节次为课程排序
        coursesList.sort{(s1,s2)->Bool in
            return (s1["section"] as! Int) < (s2["section"] as! Int )
        }
        
        let _weekDay = _comps.weekday! - 1
        let _isTomorrow = _comps.hour! >= 20
        
        // 第一次刷新应立刻进行，第二次从第一个整点开始生成时间线
        // iOS小组件刷新机制： https://cloud.tencent.com/developer/article/1823484
        entries.append(SimpleEntry(date: Date(),_curWeek:_currentWeek,_isTomorrow: _isTomorrow,_isLake: _isLake,_weekday: week[(_weekDay+7-1)%7],courses: coursesList,colors: courseColors))
        // 从第一个小时开始，每1小时刷新一次
        for hourOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Provider.getFirstHourEntryDate())!
            let entry = SimpleEntry(date: entryDate,_curWeek:_currentWeek,_isTomorrow: _isTomorrow,_isLake: _isLake,_weekday: week[(_weekDay+7-1)%7],courses: coursesList,colors: courseColors)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    // 获取第一个小时时间点所处的时间点
    static func getFirstHourEntryDate() -> Date {
        var currentDate = Date()
        let passMinute = Calendar.current.component(.minute, from: currentDate)
        let offsetMinute: TimeInterval = TimeInterval(60 - passMinute)*60
        currentDate += offsetMinute
        return currentDate
    }
}

func getCourseColor(user:UserDefaults?,courses:[Dictionary<String,Any>]) -> [String] {
    let courseAndColors = user!.dictionary(forKey: "colors") as? Dictionary<String,String>
    var colors:[String] = []
    for course in courses {
        colors.append(courseAndColors?[course["className"] as! String] ?? "")
    }
    return colors
}


func createCourses(user:UserDefaults?,currentWeek:Int,comps:DateComponents) -> [Dictionary<String,Any>] {
    let courses = user!.array(forKey: "courses") as! [Dictionary<String,Any>]
    var curWeek = currentWeek
    // 获取当前时间（24小时制）
    var apTime = comps.hour!
    // 减一后为正确工作日数
    var weekDay = comps.weekday! - 1
    var _coursesList:[Dictionary<String,Any>] = []
    
    for item in courses {

        let isTomorrow:Bool = apTime >= 20
       
        // 显示规则：分为早中晚三部分，共6节大课，每个部分最多显示两节
        // 当十一点以后（即第二节课进行一部分后），开始显示下午课表。同理下午即晚上课表遵循此规律，晚8点后开始显示第二天课表
        if isTomorrow {
            // 天数+1
            weekDay = (weekDay + 1) % 7
            // 处理第二天的周数发生变化的情况，周日为一周的第一天，周数应加1，周一为实际周数变化日期，也应加1
            if weekDay == 1 || weekDay == 0 {
                curWeek += 1
            }
            // 将时间定为早晨进行判断
            apTime = 7
        }
        let isAmClass:Bool = apTime < 11 && (item["section"] as! Int) < 3
        let isPmClass:Bool = apTime >= 11 && apTime < 17 &&
                            (item["section"] as! Int) > 2 && (item["section"] as! Int) < 5
        let isNightClass:Bool = apTime >= 17 && apTime < 20 && (item["section"] as! Int) >= 5
        let isTodayClass = weekDay == (item["weekDay"] as! Int) % 7
        let isCurrentWeek = curWeek >= (item["startWeek"] as! Int) && curWeek <= (item["endWeek"] as! Int)
        
        
        if isTodayClass && isCurrentWeek && (isAmClass || isPmClass || isNightClass) {
            _coursesList.append(item)
        }
    }
    return _coursesList
}


// 关于视图部分：学过 flutter 的话应该会对swiftUI中 stack布局较为理解，V、H为垂直和水平，Z即flutter中的stack布局
// 绝大多数 swiftUI 默认为紧凑布局（即仅占用自身所需大小），故需用spacer在其所在容器将其撑开，较为类似flutter中extended的用法（一个在里一个在外）
struct TodayScheduleEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader{geo in
            HStack{
                VStack(alignment: .leading){
                    Spacer()
                    HStack(alignment: .firstTextBaseline){
                        Text("\(entry._weekday)")
                            .font(.system(size:entry.courses.count == 1 ? 25 : 20, weight: .bold))
                        entry._curWeek == -1
                        ? Text("假期中").font(.system(size:15, weight: .light))
                        // : Text("第\(entry._curWeek)周").font(.system(size:5, weight: .light))
                        : Text(" ")
                       Spacer()
                    }.padding(EdgeInsets(top:12, leading: 20, bottom:entry.courses.count > 1 ? -8 : 0, trailing: 0))
                    
                   
                    Text("\(entry._isTomorrow ?"明日":"今日")").font(.system(size: 12, weight: .light)).padding(EdgeInsets(top: 8, leading: 22, bottom:-10, trailing: 0))
                    
                    HStack(alignment: .center){
                        Spacer()
                        VStack(alignment:.center, spacing: 2){
                            Spacer()
                            getCourse()
                            Spacer()
                        }.frame(height: 100)
                         .padding(EdgeInsets(top: 0, leading: 0, bottom:10, trailing: 0))
                        Spacer()
                    }
                    
                
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                
            }
            
            
        }
    }
    
    
    
    func getCourse() -> some View {
        if entry.courses.count == 0{
            
            let calendar:Calendar = Calendar(identifier: .gregorian)
            var comps:DateComponents = DateComponents()
            comps = calendar.dateComponents([.hour], from: Date())
            let apTime = comps.hour!
            var sectionTime:String = ""
            
            if apTime < 11 {
                sectionTime = "上午"
            }else if apTime >= 11 && apTime < 17 {
                sectionTime = "下午"
            }else if apTime >= 17 && apTime < 20 {
                sectionTime = "今晚"
            }else{
                sectionTime = "明早"
            }
            
            return  AnyView(
                    Text("\(sectionTime)没有课哟～")
                                .font(.system(size:18, weight: .light))
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    
            )
        }
        return AnyView(ForEach(0..<entry.courses.count){index in
            return GeometryReader{geo in
                HStack(alignment: .center){
                    VStack{
                        Text("\(entry._isLake ? lakeTime[entry.courses[index]["section"] as! Int * 2 - 2] : mountainTime[entry.courses[index]["section"] as! Int * 2 - 2] )")
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("\(entry._isLake ? lakeTime[entry.courses[index]["section"] as! Int * 2 - 1] : mountainTime[entry.courses[index]["section"] as! Int * 2 - 1])")
                            .multilineTextAlignment(.center)
                    }.font(.system(size:10, weight: .light))
                    .frame(width: 38, height: 45, alignment: .leading)
                     
                    
                    Spacer().frame(width:10,height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("")
                        .frame(width: 4, height: 33, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(Color(hex: "\(entry.colors[index] == "" ? "#fd999a" : entry.colors[index])"
                        )))
                        .background(Color(hex:
                           "\( entry.colors[index] == "" ? "#fd999a" : entry.colors[index])"
                        ))
                        .cornerRadius(6)
                    
                    Spacer().frame(width:10,height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    VStack(alignment: .leading, spacing: 2){
                        
                        Text(entry.courses[index]["className"] as! String)
                            .font(.system(size:13, weight: .bold))
                            
                       
                        Text("\(entry.courses[index]["teacher"] as! String == "" ? "未知" : entry.courses[index]["teacher"] as! String )｜\(entry.courses[index]["classroom"] as! String == "" ? "未知" : entry.courses[index]["classroom"] as! String) ")
                            .font(.system(size:10, weight: .light))
                    }
                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 2, trailing: 0))
                    .frame( height:45 , alignment: .leading)
                }
                .padding(EdgeInsets(top:entry.courses.count == 1 ? 8 : 0, leading: 13, bottom: 0, trailing: 0))
                
            }
        })
    }
}

@main
struct TodaySchedule: Widget {
    let kind: String = "TodaySchedule"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodayScheduleEntryView(entry: entry)
        }
        .configurationDisplayName("课程表小组件")
        .description("@领航工作室")
        // 在这设置支持小组件的大小
        .supportedFamilies([.systemMedium])
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let _curWeek: Int
    let _isTomorrow:Bool
    let _isLake:Bool
    let _weekday:String
    var courses: [Dictionary<String,Any>]
    var colors: [String]
    
}


struct CoursesModel {
    let className:String
    let teachClass:String
    let teacher:String
    let startWeek: Int
    let endWeek: Int
    let section: Int
    let weekDay: Int
    let classroom: String
}

struct TodaySchedule_Previews: PreviewProvider {
    static var previews: some View {
        TodayScheduleEntryView(entry: SimpleEntry(date: Date(), _curWeek: 1, _isTomorrow: false,_isLake: true, _weekday: "Wed.", courses: [
//                                                              ["className": "概率论与数理统计A",
//
//                                                               "teachClass": "教学班0853",
//
//                                                               "teacher": "张婷",
//
//                                                               "startWeek": 4,
//
//                                                               "endWeek": 15,
//
//                                                               "section": 2,
//
//                                                               "weekDay": 3,
//
//                                                               "classroom": "恒大楼三区103"]
//
//                                                             ,
            ["className": "概率论与数理统计A",
                                                                                              
                                                               "teachClass": "教学班0853",
                                                                                                 
                                                               "teacher": "张婷",
                                                                                               
                                                               "startWeek": 4,
                                                                                                  
                                                               "endWeek": 15,
                                                                                                  
                                                               "section": 1,
                                                                                                  
                                                               "weekDay": 3,
                                                                                                 
                                                               "classroom": "恒大楼三区103"]
        ],colors: ["","","",""])).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// 扩展Color使支持16进制字符串，使用方法：Color(hex:"")
// 参考：https://juejin.cn/post/6948250295549820942
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
