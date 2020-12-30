import 'dart:convert';

class CodeUtils {
  /// 解码 list result
  static List<dynamic> decodeListResult(String data) {
    return json.decode(data);
  }

  /// 解码 map result
  static Map<String, dynamic> decodeMapResult(String data) {
    return json.decode(data);
  }

  /// 编码 to string
  static String encodeToString(String data) {
    return json.encode(data);
  }
}
