import 'package:flutter/material.dart';
import 'package:ruby_html/ruby_html.dart';

void main() {
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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RubyHtml('<ruby>日本語<rt>にほんご</rt></ruby>',),
            SizedBox(height: 16,),
            RubyHtml('<ruby>日本<rt>にほん</rt>はさむいです。</ruby>'),
            SizedBox(height: 16,),
            RubyHtml('さむいよ！<ruby>日本<rt>にほん</rt></ruby>'),
            SizedBox(height: 16,),
            RubyHtml('<ruby>日本<rt>にほん</rt></ruby>は<ruby>寒<rt>さむ</rt></ruby>いです。',
              mainStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue),
              rubyStyle: const TextStyle(color: Colors.green, fontSize: 12),
              style:  const TextStyle(fontSize: 22),
            ),
            SizedBox(height: 16,),
            RubyHtml(
              'ソフトウェア<ruby>開発<rt>かいはつ</rt></ruby>は、<ruby>創<rt>そう</rt>造<rt>ぞう</rt></ruby><ruby>的<rt>てき</rt></ruby>で<ruby>楽<rt>たの</rt>しい</ruby>です。',
            ),
          ],
        ),
      ),
    );
  }
}
