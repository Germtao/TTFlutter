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

```