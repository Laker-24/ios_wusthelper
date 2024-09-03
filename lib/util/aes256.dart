/*
 * ///[加密工具]
 * 将账号和密码加密后存入本地
 * 
 */

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';

var _KEY = "sdfg5468wwdfd542sd4asdf4sadfqd12";
var _IV = "0000000000000000";

class JhEncryptUtils {
  //AES加密
  static aesEncrypt(plainText) {
    try {
      final key = Key.fromUtf8(_KEY);
      final iv = IV.fromUtf8(_IV);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64;
    } catch (err) {
      LogUtil.e("aes encode error:$err");
      return plainText;
    }
  }

  //AES解密
  static dynamic aesDecrypt(encrypted) {
    try {
      final key = Key.fromUtf8(_KEY);
      final iv = IV.fromUtf8(_IV);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (err) {
      LogUtil.e("aes decode error:$err");
      return encrypted;
    }
  }
}

/*
 * 通过接口上传jwc密码时进行加密
 *  author  :  鑫爷  yyds
 * 
 */
class EncodeUtil {
  static final List<int> encodingTable = [
    ///大写字母
    utf8.encode('A')[0],
    utf8.encode('B')[0],
    utf8.encode('C')[0],
    utf8.encode('D')[0],
    utf8.encode('E')[0],
    utf8.encode('F')[0],
    utf8.encode('G')[0],
    utf8.encode('H')[0],
    utf8.encode('I')[0],
    utf8.encode('J')[0],
    utf8.encode('K')[0],
    utf8.encode('L')[0],
    utf8.encode('M')[0],
    utf8.encode('N')[0],
    utf8.encode('O')[0],
    utf8.encode('P')[0],
    utf8.encode('Q')[0],
    utf8.encode('R')[0],
    utf8.encode('S')[0],
    utf8.encode('T')[0],
    utf8.encode('U')[0],
    utf8.encode('V')[0],
    utf8.encode('W')[0],
    utf8.encode('X')[0],
    utf8.encode('Y')[0],
    utf8.encode('Z')[0],
    //小写字母
    utf8.encode('a')[0],
    utf8.encode('b')[0],
    utf8.encode('c')[0],
    utf8.encode('d')[0],
    utf8.encode('e')[0],
    utf8.encode('f')[0],
    utf8.encode('g')[0],
    utf8.encode('h')[0],
    utf8.encode('i')[0],
    utf8.encode('j')[0],
    utf8.encode('k')[0],
    utf8.encode('l')[0],
    utf8.encode('m')[0],
    utf8.encode('n')[0],
    utf8.encode('o')[0],
    utf8.encode('p')[0],
    utf8.encode('q')[0],
    utf8.encode('r')[0],
    utf8.encode('s')[0],
    utf8.encode('t')[0],
    utf8.encode('u')[0],
    utf8.encode('v')[0],
    utf8.encode('w')[0],
    utf8.encode('x')[0],
    utf8.encode('y')[0],
    utf8.encode('z')[0],
    //数字
    utf8.encode('1')[0],
    utf8.encode('2')[0],
    utf8.encode('3')[0],
    utf8.encode('4')[0],
    utf8.encode('5')[0],
    utf8.encode('6')[0],
    utf8.encode('7')[0],
    utf8.encode('8')[0],
    utf8.encode('9')[0],
    utf8.encode('+')[0],
    utf8.encode('/')[0],
  ];

  /// 密码加密
  static String getEncoode(String s) {
    String str = s + "JWC";
    // String a = "[50, 48, 48, 50, 52, 49, 54, 120, 74, 87, 67]";
    //将s1转为  字节数组并tostring    注：使用jsondecoder的方法会不一样，唉
    String s1 = utf8.encode(str).toString();
    //在将s1转为 字符数组并进行加密  仍然使用tostring
    String s2 = encode(utf8.encode(s1)).toString();
    //将s2转为单个字符串
    List<String> c = <String>[];
    for (int i = 0; i < s2.length; i++) {
      c.add(s2[i]);
    }
    // int b = int.parse("4e7b", radix: 16);
    // var Str = "4e7b";
    // String sa = String.fromCharCode(b);
    //进行异或后的结果
    List<String> a = [];
    for (int i = 0; i < c.length; i++) {
      a.add((utf8.encode(c[i])[0] ^ 20000).toString());
    }
    //将a中的数据先转换为16进制
    List<String> aTo16 = [];
    for (int i = 0; i < a.length; i++) {
      aTo16.add(int.parse(a[i]).toRadixString(16));
    }
    //  将数据转为 utf-16
    List<int> b = [];
    for (int i = 0; i < aTo16.length; i++) {
      b.add(int.parse(aTo16[i], radix: 16));
    }
    List<String> changeToUtf = [];
    for (int i = 0; i < b.length; i++) {
      changeToUtf.add(String.fromCharCode(b[i]));
    }
    String sta = changeToUtf.toString().replaceAll(',', '');
    return sta.replaceAll(' ', '');
  }

  ///加密
  static List<int> encode(List<int> data) {
    List<int> bytes;
    int modulus = data.length % 3;
    if (modulus == 0) {
      bytes = List.filled(((4 * data.length) / 3).round(), 0, growable: true);
    } else {
      bytes =
          List.filled((4 * ((data.length / 3) + 1)).round(), 0, growable: true);
    }
    int dataLength = (data.length - modulus);
    int a1;
    int a2;
    int a3;
    for (int i = 0, j = 0; i < dataLength; i += 3, j += 4) {
      a1 = data[i] & 0xff;
      a2 = data[i + 1] & 0xff;
      a3 = data[i + 2] & 0xff;
      bytes[j] = encodingTable[(a1 >> 2) & 0x3f];
      bytes[j + 1] = encodingTable[((a1 << 4) | (a2 >> 4)) & 0x3f];
      bytes[j + 2] = encodingTable[((a2 << 2) | (a3 >> 6)) & 0x3f];
      bytes[j + 3] = encodingTable[a3 & 0x3f];
    }
    int b1;
    int b2;
    int b3;
    int d1;
    int d2;
    switch (modulus) {
      case 0: /* nothing left to do */
        break;
      case 1:
        d1 = data[data.length - 1] & 0xff;
        b1 = (d1 >> 2) & 0x3f;
        b2 = (d1 << 4) & 0x3f;
        bytes[bytes.length - 4] = encodingTable[b1];
        bytes[bytes.length - 3] = encodingTable[b2];
        bytes[bytes.length - 2] = utf8.encode('=')[0];
        bytes[bytes.length - 1] = utf8.encode('=')[0];
        break;
      case 2:
        d1 = data[data.length - 2] & 0xff;
        d2 = data[data.length - 1] & 0xff;
        b1 = (d1 >> 2) & 0x3f;
        b2 = ((d1 << 4) | (d2 >> 4)) & 0x3f;
        b3 = (d2 << 2) & 0x3f;
        bytes[bytes.length - 4] = encodingTable[b1];
        bytes[bytes.length - 3] = encodingTable[b2];
        bytes[bytes.length - 2] = encodingTable[b3];
        bytes[bytes.length - 1] = utf8.encode('=')[0];
        break;
    }
    return bytes;
  }
}
