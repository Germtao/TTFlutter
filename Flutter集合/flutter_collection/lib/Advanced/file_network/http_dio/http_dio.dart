import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HttpDioTestRoute extends StatefulWidget {
  @override
  _HttpDioTestRouteState createState() => _HttpDioTestRouteState();
}

class _HttpDioTestRouteState extends State<HttpDioTestRoute> {
  Dio _dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Http Dio"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: FutureBuilder(
            future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // 请求完成
              if (snapshot.connectionState == ConnectionState.done) {
                Response response = snapshot.data;
                // 发生错误
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                // 请求成功，通过项目信息构建用于显示项目名称的ListView
                return ListView(
                  children: response.data.map<Widget>((e) => 
                    ListTile(title: Text(e["full_name"]))
                  ).toList(),
                );
              }
              // 请求未完成弹出loading
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}