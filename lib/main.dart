import 'package:easy_message/provider/bottom_navigationbar_provider.dart';
import 'package:easy_message/screens/call_log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Message',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) => BottomNavigationBarProvider(),
          child: const MyHomePage(title: 'Quick Message')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey bottomNavigationBarKey = GlobalKey();
  final List<Widget> _pages = const <Widget>[MainPage(), CallLogPage()];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text(widget.title),
      ),
      body: IndexedStack(children: _pages, index: prov.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        key: bottomNavigationBarKey,
        currentIndex: prov.selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Call Log')
        ],
        onTap: (index) async {
          if (index == 1) {
            setState(() {});
          }
          if (index == 1) {
            PermissionStatus status = await Permission.phone.status;
            if (!status.isGranted) {
              await Permission.phone.request();
              prov.changeIndex(index);
            }

            if (status.isGranted) {
              prov.changeIndex(index);
            }
          } else {
            prov.changeIndex(index);
          }
        },
      ),
    );
  }
}
