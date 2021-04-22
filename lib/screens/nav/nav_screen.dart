import 'package:aloe/screens/home/components/home_screen.dart';
import 'package:aloe/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  @override
  int selectedIndex = 0;

  Widget build(BuildContext context) {
    int badge = 0;
    List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      HomeScreen(),
      SignInScreen()
    ];
    Widget currentWidget = widgetOptions.elementAt(selectedIndex);

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 60,
                        color: Colors.green.withOpacity(.20),
                        offset: Offset(0, 15),
                      )
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 22),
                      child: GNav(
                        gap: 10,
                        color: Colors.grey[600],
                        activeColor: Colors.white,
                        rippleColor: Colors.grey[800],
                        hoverColor: Colors.grey[700],
                        iconSize: 20,
                        textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        tabBackgroundColor: Colors.grey[900],
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16.5),
                        duration: Duration(milliseconds: 800),
                        tabs: [
                          GButton(
                            icon: Icons.home,
                            text: 'Accueil',
                            onPressed: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.search,
                            text: 'Recherche',
                            onPressed: () {
                              setState(() {
                                selectedIndex = 1;
                                print("sdsd");
                              });
                            },
                          ),
                          GButton(
                            icon: Icons.account_circle,
                            text: 'Profil',
                            onPressed: () {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ))),
              widgetOptions.elementAt(selectedIndex),
            ],
          ),
        ),
      )),
    );
  }
}
