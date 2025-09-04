import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homelink_pendant_app/widgets/generic_placeholder_widget.dart';
import 'package:homelink_pendant_app/pages/live_alerts_page.dart';
import 'package:homelink_pendant_app/widgets/bottom_nav_bar.dart';
import 'package:homelink_pendant_app/widgets/top_bar.dart';
import 'package:fvp/fvp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerWith();
  await Firebase.initializeApp();
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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LiveAlertsPage(),
    GenericPlaceholderWidget(description: 'Summary Page Coming Soon!'),
  ];

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD1E2F7), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              TopBar(),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomNavBar(
        selectedIndex: _selectedIndex,
        onButtonTapped: _onButtonTapped,
      ),
    );
  }
}
