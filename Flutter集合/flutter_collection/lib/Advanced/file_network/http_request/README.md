# 网络请求

## 通过HttpClient发起HTTP请求

`Dart IO`库中提供了用于发起`Http`请求的一些类，可以直接使用`HttpClient`来发起请求。使用`HttpClient`发起请求分为*五步*：

1. 创建一个`HttpClient`：

`HttpClient httpClient = HttpClient();`

2. 打开`Http`连接，设置请求头：

`HttpClientRequest request = await httpClient.getUrl(uri);`

这一步可以使用任意`Http Method`，如`httpClient.post(...)`、`httpClient.delete(...)`等。如果包含Query参数，可以在构建uri时添加，如：

```
Uri uri = Uri(scheme: 'https', host: 'flutterchina.club', queryParameters: {
    'xx':'xx',
    'yy':'dd'
  });
```

通过`HttpClientRequest`可以设置请求`header`，如：

`request.headers.add('user-agent', 'test');`

如果是`post`或`put`等可以携带请求体方法，可以通过`HttpClientRequest`对象发送`request body`，如：

```
String payload = '...';
request.add(utf8.encode(payload)); 
// request.addStream(_inputStream); // 可以直接添加输入流
```

3. 等待连接服务器：

```
HttpClientResponse response = await request.close();
```

这一步完成后，请求信息就已经发送给服务器了，返回一个`HttpClientResponse`对象，它包含*响应头(header)*和*响应流(响应体的Stream)*，接下来就可以通过读取响应流来获取响应内容。

4. 读取响应内容：

`String responseBody = await response.transform(utf8.decoder).join();`

通过读取响应流来获取服务器返回的数据，在读取时可以设置编码格式，这里是`utf8`。

5. 请求结束，关闭`HttpClient`：

`httpClient.close();`

关闭client后，通过该client发起的所有请求都会中止。

#### 示例

实现一个获取百度首页html的例子，示例效果如下图所示：

![获取百度首页html]()

点击*获取百度首页*按钮后，会请求百度首页，请求成功后，将返回内容显示出来并在控制台打印响应header，代码如下：

```
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class HttpClientTestRoute extends StatefulWidget {
  @override
  HttpClientTestRouteState createState() => HttpClientTestRouteState();
}

class HttpClientTestRouteState extends State<HttpClientTestRoute> {
  bool _loading = false;
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('网络请求'),
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('获取百度首页'),
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() {
                            _loading = true;
                            _text = '正在请求...';
                          });

                          try {
                            // 1. 创建一个HttpClient
                            HttpClient httpClient = HttpClient();
                            // 2. 打开Http连接
                            HttpClientRequest request = await httpClient
                                .getUrl(Uri.parse('https://www.baidu.com'));
                            // 使用iPhone的UA
                            request.headers.add(
                              'user-agent',
                              'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1',
                            );
                            // 3. 等待连接服务器(会将请求信息发送给服务器)
                            HttpClientResponse response = await request.close();
                            // 4. 读取响应内容
                            _text =
                                await response.transform(utf8.decoder).join();
                            // 输出响应头
                            print(response.headers);
                            // 5. 请求结束，关闭
                            httpClient.close();
                          } catch (e) {
                            _text = '请求失败: $e';
                          } finally {
                            setState(() {
                              _loading = false;
                            });
                          }
                        },
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  child: Text(_text.replaceAll(RegExp(r'\s'), '')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

控制台输出：

```
flutter: connection: keep-alive
cache-control: no-cache
set-cookie: BAIDUID=9970BA929045429EB351EEE7ADE22EAA:FG=1; max-age=31536000; expires=Sat, 19-Jun-21 08:12:33 GMT; domain=.baidu.com; path=/; version=1; comment=bd
set-cookie: H_WISE_SIDS=149010_147937_148229_142018_148412_149355_150076_147087_141744_148193_148867_148874_148435_147279_148823_149860_131861_148438_148754_147889_148524_149174_127969_149571_146549_149718_147024_146732_138426_143667_131423_100808_142207_147527_147913_125581_107312_146848_148567_148186_147717_149247_140312_149457_147989_144966_149279_145607_148661_148050_148749_147546_148868_148762_110085; path=/; expires=Sat, 19-Jun-21 08:12:33 GMT; domain=.baidu.com
set-cookie: bd_traffictrace=191612; expires=Thu, 08-Jan-1970 00:00:00 GMT
set-cookie: rsv_i=9a9aMQRKneY63xQkx2gHZZFxy1rFUES9KL%2BEe77UELsW%2FnAS2xT6naypLQRyrI8H%2BmnSQOrIb49NRJvvLFa9YYY07cQWgbQ; path=/; domain=.baidu.com
set-cookie: BDSVRTM=49; path=/
set-cookie: eqid=deleted; path=/; domain=.baidu.com; expires=Thu,<…>
```

