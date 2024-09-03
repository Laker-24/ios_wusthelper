int transformColor(String alpha, String colorStr) {
  return int.parse(alpha + colorStr.toUpperCase().replaceAll('#', ''),
      radix: 16);
}

// 初始化颜色数据
// Future<Map> initColors() async {
//   Map courseAndColors = JsonDecoder()
//       .convert(await BaseCache.getInstence().get('courseAndColor'));
//   List colors = await BaseCache.getInstence().get('colors');
//   // 若颜色不足则重新使用一遍颜色
//   if (colors == []) {
//     coursesColors.forEach((element) {
//       colors.add(element);
//     });
//   }
//   Map colorsData = {'courseAndColor': courseAndColors, 'colors': colors};
//   return colorsData;
// }
