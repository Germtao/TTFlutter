# 脚手架应用

为了能够更好地体验，我们可以封装好这些一样的功能，开发出一个脚手架方式。前端同学会比较熟悉，将大部分初始化或者脚本化的功能统一封装成一个脚手架，通过脚手架执行项目的初始化。

## flutter-pro-cli

`flutter-pro-cli`，该工具可以轻松帮你完成项目框架结构的初始化，在安装完成上面的运行环境后，在命令运行窗口，运行下面的命令。

```
npm install -g flutter-pro-cli
```

安装完成后，运行如下命令查看具体包含的功能。

```
flutter-pro-cli -h
```

可以看到如下的窗口提示信息。

```
Usage: flutter-pro-cli [options] [command]
Options:
  -h, --help      display help for command
Commands:
  init|i          Generates new flutter project
  check|c         Check the project lib format
  run|r [check]   Check the project lib format and run
  sync-test|st    Generates new test path base on lib path
  help [command]  display help for command
```

- *init*：该操作会初始化好目录结构，包含`lib`和`test`目录下，其次会生成一个比较简单的`main.dart`和`router.dart`文件，并将我们需要的`check_format.sh`、`check_format.bat`以及`analysis_options.yaml`这三个文件放在项目根目录下。

- *check*：该操作执行`check_format.sh`或者`check_format.bat`文件来美化代码结构，并检查当前项目的代码是否符合我们规范。

- *run*：启动运行项目，可以带`check`参数执行`check_format.sh`先校验是否符合规范，符合则启动，否则不启动项目。这里的`run`要注意，需要优先打开手机模拟器，不然无法启动。

- *sync-test*：同步测试代码结构，为了减少大家写单元测试的时间，脚手架提供了方法，可以读取你项目代码文件，并且添加了一个最基础的测试，其他部分则需要自己补充。

我在实际项目开发过程中发现写测试用例确实挺麻烦，为了节省时间，可以针对性生成一些基础的测试代码用例，例如上面的`sync-test`会为我们创建好相应的目录结构，以及相应的测试代码文件。


# 实战初始化

现在我们使用以上脚手架来初始化一个`Flutter`项目。首先第一步是创建项目`flutter_pro_cli_test`，需要在 Android Studio 中创建好 Flutter 项目，项目创建完成后，在项目根目录打开命令行窗口，执行以下命令进行初始化。

```
flutter-pro-cli init
```

执行完该初始化成功后，打开手机模拟器运行下面的命令检查代码规范，并且启动项目。

```
flutter-pro-cli run check
```

为了尝试自动化生成测试代码，我们可以在项目中的`lib/pages/home_page/`目录下创建一个`index.dart`。然后再运行下面的命令。

```
flutter-pro-cli st
```

运行完后，在相应的`test/pages/home_page`目录下你将看到`index_test.dart`文件，里面将包含下面的测试代码。

```
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pro_cli_test/pages/home_page/index.dart';

// @todo
void main() {
  testWidgets('test flutter_pro_cli_test/pages/home_page/index.dart', (WidgetTester tester) async {
     final Widget testWidgets = HomePageIndex();
      await tester.pumpWidget(
          new MaterialApp(
              home: testWidgets
          )
      );

      expect(find.byWidget(testWidgets), findsOneWidget);
  });
}
```

以上就完成了一个项目的初始化，比较简单的三个步骤。后期开发过程中可以使用`run`和`st`命令来提升研发效率。