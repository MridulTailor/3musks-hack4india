import 'package:attendance_flutter_app/firebase_options.dart';
import 'package:attendance_flutter_app/screens/chat_page.dart';
import 'package:attendance_flutter_app/screens/home_page.dart';
import 'package:attendance_flutter_app/screens/login_page.dart';
import 'package:attendance_flutter_app/screens/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/chat': (context) => SafeArea(
              child: Material(
                child: HtmlWidget(
                  // the first parameter (`html`) is required
                  '''<html>
                      <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style>
                          body {
                background: #fff;
                font-family: sans-serif;
                font-size: 14px;
                          }
                          h1 {
                font-size: 1.2em;
                          }
                          p {
                font-size: 0.8em;
                          }
                          a {
                color: #2196F3;
                          }
                        </style>
                      </head>
                      <body>
                        <h1>Flutter Widget from HTML</h1>
                        <p>This <a href="https://pub.dev/packages/flutter_widget_from_html">package</a> helps to render HTML as Flutter widgets.</p>
                        <p>It uses <a href="https://pub.dev/packages/html/dom.dart">html/dom.dart</a> to parse HTML.</p>
                        <p>It supports custom styling, including Google Fonts.</p>
                        <a href='http://localhost:3000'>Click Me!</a>
                        <flowise-fullchatbot></flowise-fullchatbot>
                        <script type="module">
    import Chatbot from "https://cdn.jsdelivr.net/npm/flowise-embed/dist/web.js"
    Chatbot.initFull({
        chatflowid: "9af59a31-1eed-4a47-b5bf-0509076e0d66",
        apiHost: "http://localhost:3000",
    })
</script>
                      </body>
                      
                      </html>
                      ''',

                  // all other parameters are optional, a few notable params:
                  baseUrl: Uri.parse('http://localhost:3000'),
                  enableCaching: true,
                  // specify custom styling for an element
                  // see supported inline styling below

                  // these callbacks are called when a complicated element is loading
                  // or failed to render allowing the app to render progress indicator
                  // and fallback widget
                  onErrorBuilder: (context, element, error) =>
                      Text('$element error: $error'),
                  onLoadingBuilder: (context, element, loadingProgress) =>
                      CircularProgressIndicator(),

                  // this callback will be triggered when user taps a link
                  // select the render mode for HTML body
                  // by default, a simple `Column` is rendered
                  // consider using `ListView` or `SliverList` for better performance
                  renderMode: RenderMode.column,

                  // set the default styling for text
                  textStyle: TextStyle(fontSize: 14),

                  // turn on `webView` if you need IFRAME support (it's disabled by default)
                ),
              ),
            ),
      },
    );
  }
}
