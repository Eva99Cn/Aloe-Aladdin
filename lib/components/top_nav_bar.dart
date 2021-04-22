import 'package:aloe/screens/home/components/home_screen.dart';
import 'package:aloe/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TopNavBar extends StatefulWidget {
  @override
  _TopNavBarState createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    int badge = 0;
    List<Widget> widgetOptions = [HomeScreen(), HomeScreen(), SignUpScreen()];
    List<GButton> tabs = [];

    void _tabChanged(int index) {
      badge = badge + 1;
      setState(() {
        selectedIndex = index;
      });
      /*if (selectedIndex == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if (selectedIndex == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }*/
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: Colors.black.withOpacity(.20),
                  offset: Offset(0, 15),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
              child: GNav(
                gap: 10,
                color: Colors.grey[600],
                activeColor: Colors.white,
                rippleColor: Colors.grey[800],
                hoverColor: Colors.grey[700],
                iconSize: 20,
                textStyle: TextStyle(fontSize: 16, color: Colors.white),
                tabBackgroundColor: Colors.grey[900],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.5),
                duration: Duration(milliseconds: 800),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: _tabChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
