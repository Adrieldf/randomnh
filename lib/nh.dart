import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nhrimages/constants/emojis.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constants/theme.dart';

class NH extends StatefulWidget {
  final bool loadRandom;
  NH({Key key, @required this.loadRandom}) : super(key: key);

  @override
  _NHState createState() => _NHState();
}

class _NHState extends State<NH> {
  bool _refreshVisible = true;
  WebViewController _controller;
  Timer _timer;
  int _timeLeft = 5;
  bool _canGoBack = false;
  bool _canGoForward = false;
  var _randonNumber = new Random().nextInt(14);

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
    //onPageFinishedLoading("");
  }

  Future<String> getCurrentURL() {
    return _controller.currentUrl();
  }

  String getRandomNumber() {
    var rnd = Random();
    var n1 = rnd.nextInt(10);
    var n2 = rnd.nextInt(10);
    var n3 = rnd.nextInt(10);
    var n4 = rnd.nextInt(10);
    var n5 = rnd.nextInt(10);
    //6 digit to be implemented, i need to know the max value
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

  Future<void> updateNavitationButtons() async {
    _canGoForward = await _controller.canGoForward();
    _canGoBack = await _controller.canGoBack();
    setState(() {});
  }

  Future<void> onPageFinishedLoading(url) async {
    if (url == null || url == "") {
      url = await getCurrentURL();
    }
    debugPrint("FINISHED LOADING URL: $url");
    if (url.toString().endsWith('404')) {
      refresh();
      return;
    }
    enableRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: Text(
            emojis[_randonNumber],
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Made with ♥ by Adrieldf")))
          },
        ),
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
          /*IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: _refreshVisible ? refresh : null),*/
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
              onPageFinished: (url) => onPageFinishedLoading(url),
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                if (widget.loadRandom) {
                  refresh();
                }
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
