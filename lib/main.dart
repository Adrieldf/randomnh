import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nhrimages/constants/theme.dart';
import 'package:nhrimages/nh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RandomNH',
      theme: mainTheme,
      home: MyHomePage(title: 'RandomNH'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_rounded),
              onPressed: () => SystemNavigator.pop())
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome to RandomNH!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "This app just generates random links to a specific website."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enjoy! :)"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NH(
                                loadRandom: false,
                              )),
                    ),
                    child: Text("Frontpage"),
                    style: ElevatedButton.styleFrom(
                        primary: mainTheme.accentColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NH(
                                loadRandom: true,
                              )),
                    ),
                    child: Text("Random"),
                    style: ElevatedButton.styleFrom(
                        primary: mainTheme.accentColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tip: You can always click refresh for a new one!"),
            ),
          ],
        ),
      ),
    );
  }
}
