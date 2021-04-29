import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nhrimages/constants/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  bool _refreshVisible = true;
  WebViewController _controller;
  Timer _timer;
  int _timeLeft = 5;
  bool _canGoBack = false;
  bool _canGoForward = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeLeft == 0) {
          setState(() {
            timer.cancel();
            _timeLeft = 5;
            enableRefresh();
          });
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeLeft = 5;
    super.dispose();
  }

  void refresh() {
    setState(() {
      _refreshVisible = false;
    });
    startTimer();
    context.loaderOverlay.show();
    var link = "https://www.nhentai.net/g/";

    link = link + getRandomNumber();
    _controller.loadUrl(link);
    debugPrint("Link: $link");
  }

  void enableRefresh() {
    setState(() {
      _refreshVisible = true;
    });
    context.loaderOverlay.hide();
    updateNavitationButtons();
  }

  String getRandomNumber() {
    var rnd = Random();
    var n1 = rnd.nextInt(10);
    var n2 = rnd.nextInt(10);
    var n3 = rnd.nextInt(10);
    var n4 = rnd.nextInt(10);
    var n5 = rnd.nextInt(10);
    return n1.toString() +
        n2.toString() +
        n3.toString() +
        n4.toString() +
        n5.toString();
  }

  void navigate(bool goBack) {
    if (goBack) {
      _controller.goBack();
    } else {
      _controller.goForward();
    }

    updateNavitationButtons();
  }

  void updateNavitationButtons() {
    setState(() async {
      _canGoForward = await _controller.canGoForward();
      _canGoBack = await _controller.canGoBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed:
                  _refreshVisible && _canGoBack ? () => navigate(true) : null),
          IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: _refreshVisible && _canGoForward
                  ? () => navigate(false)
                  : null),
          IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: _refreshVisible ? refresh : null),
        ],
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).accentColor,
            size: 50.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "https://www.nhentai.net/",
              onPageFinished: (url) => enableRefresh,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
            ),
          ),
        ),
      ),
      floatingActionButton: new Visibility(
        visible: _refreshVisible,
        child: FloatingActionButton(
          onPressed: refresh,
          tooltip: 'Refresh',
          child: Icon(Icons.refresh_rounded),
          backgroundColor: mainTheme.accentColor,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
