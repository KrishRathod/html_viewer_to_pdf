import 'package:flutter/material.dart';
import 'package:flutter_example1/render_screen.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML Rendering Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomizeScreen(),
    );
  }
}

class CustomizeScreen extends StatelessWidget {
  final String originalHtml = '''
    <html>
      <body>
        <h1>Hello, REPLACE_ME!</h1>
        <p>This is a dummy HTML.</p>
      </body>
    </html>
  ''';

  String getModifiedHtml(String name) {
    return originalHtml.replaceAll('REPLACE_ME', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Html(
              data: originalHtml,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final modifiedHtml = getModifiedHtml('KRISH');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RenderScreen(modifiedHtml)),
                );
              },
              child: Text('Customize Button'),
            ),
          ],
        ),
      ),
    );
  }
}
