import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
//    这个方法只有在App第一次运行的时候被执行过一次，每次App从后台激活时都不会再执行该方法。
//    https://www.hangge.com/blog/cache/detail_795.html
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller:FlutterViewController = window?.rootViewController as! FlutterViewController
    
    let userDefaults = UserDefaults.init(suiteName: "group.lh.wusthelper")

//    userDefaults!.setValue([["className": "算法设计与分析",
//                            "teachClass": "教学班1316",
//                            "teacher": "陈黎",
//                            "startWeek": 7,
//                            "endWeek": 16,
//                            "section": 1,
//                            "weekDay": 1,
//                            "classroom": "恒大楼三区103"]], forKey: "courses")
//    userDefaults!.setValue(1 , forKey:"curWeek" )
//    userDefaults!.setValue(true , forKey:"isLake" )
//    userDefaults!.setValue(["算法设计与分析":"#fd999a"] , forKey:"colors" )
    
    // 此处会返回init结果（因并不打算利用返回值故意义不大）
    WidgetMenthod.init(messger: controller.binaryMessenger)
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


class WidgetMenthod{
    init(messger:FlutterBinaryMessenger){
        let channel = FlutterMethodChannel(name: "com.linghangstudio.wusthelper.TodaySchedule", binaryMessenger: messger)

        channel.setMethodCallHandler{(call:FlutterMethodCall, result: @escaping FlutterResult) in
            // 当flutter channel方法调用时检测 方法名（即下文的call.method）
            if(call.method == "updateWidgetData"){
                if let dict = call.arguments as? Dictionary<String,Any>{
                    // 提取数据
                    let courses = dict["courses"] as? [Dictionary<String,Any>] ?? [["className":"meiyou"]]
                    let anchorPointWeek = dict["anchorPointWeek"] as? Int
                    let anchorPoint = dict["anchorPoint"] as? Int
                    let colors = dict["colors"] as? Dictionary<String,String> ?? [:]
                    let isLake = dict["isLake"] as? Bool ?? true
                    // let isMonday = dict["isMonday"] as?Bool ??true;
                    
                    // 保存数据
                    let userDefaults = UserDefaults.init(suiteName: "group.lh.wusthelper")
                    userDefaults!.setValue(courses, forKey: "courses")
                    userDefaults!.setValue(anchorPointWeek, forKey: "anchorPointWeek")
                    userDefaults!.setValue(anchorPoint, forKey: "anchorPoint")
                    userDefaults!.setValue(colors, forKey: "colors")
                    userDefaults!.setValue(isLake, forKey: "isLake")
                    // userDefaults!.setValue(isMonday,forKey:"isMonday")
                    
                    if #available(iOS 14.0, *) {
                        // 数据更新后，刷新所有小组件
                        WidgetCenter.shared.reloadAllTimelines()
                        result(["code":1,"msg":"success"])
                    } else {
                        // Fallback on earlier versions
                        result(["code":0,"msg":"系统版本过低"])
                    }
                }else{
                    // 参数类型错误
                    result(["code":0,"msg":"参数异常"])
                }
            }
        }
        
    }
}

