import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
/**
 *    通过图片路径将图片转换成Base64字符串
 */

import 'package:flutter/material.dart';

class CodeUtil {
  static Future imageBase64(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  //通过Base64字符串的图片转换成图片
  static Image base642Image(String base64Txt,
      {BoxFit fit, double height, double width}) {
    Uint8List decodeTxt = convert.base64.decode(base64Txt);
    return Image.memory(
      decodeTxt,
      fit: fit,
      height: height,
      width: width,
      gaplessPlayback: true,
    );
  }
}


