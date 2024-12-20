import 'package:babel/l10n/app_localizations.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/user.dart';
import 'package:babel/screens/login.dart';
import 'package:babel/screens/trips.dart';
import 'package:babel/services/auth_service.dart';
import 'package:babel/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:babel/screens/newsfeeds.dart';
import 'package:babel/constant.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void logoutUser() async {
    final ApiResponse response = await AuthService().logout();

    if (!mounted) return; // Ensure the widget is still mounted

    if (response.error == null) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(response.data as String? ?? "Logged out successfully")),
      );

      // Navigate the user to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  User? user;
  void getUser() async {
    final ApiResponse response = await AuthService().getUserDetails();

    if (!mounted) return;

    if (response.error == null) {
      setState(() {
        user = response.data as User;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  int selectedPage = 0;
  void navigateBottomBar(int index) {
    setState(() {
      // print(
      //     '${user?.id} - ${user?.name} -${user?.phoneNumber} -${user?.location}');
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // pages to display
  final List<Widget> _pages = [
    // trips page
    const Trips(),
    // newsfeed Page
    const Newsfeeds(),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme
    final localizations = AppLocalizations.of(context); // Access localization

    return Scaffold(
      // backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavBar((index) => navigateBottomBar(index),
          selectedPage, context), // nav bar
      appBar: appBar(context), // app bar
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Logo
                DrawerHeader(
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image1.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Text(
                  localizations.translate('babelStation'), // Localized text
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: theme.primaryColor, // Theme-based color
                  ),
                ),
                Divider(
                  height: 20.0,
                  thickness: 2.0,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: theme.dividerColor, // Theme-based divider color
                ),
                Switch(
                  activeColor: theme.primaryColor, // Theme-based switch color
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ), // User Info Card
                user != null
                    ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5.0,
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //userName phoneNumber location
                                '${localizations.translate('userName')} : ${user?.name}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${localizations.translate('phoneNumber')} : ${user?.phoneNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${localizations.translate('location')} : ${user?.location}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: theme.iconTheme.color, // Theme-based icon color
                ),
                title: Text(
                  localizations.translate('logout'), // Localized text
                  style: TextStyle(
                    color: theme
                        .textTheme.bodyLarge?.color, // Theme-based text color
                  ),
                ),
                onTap: logoutUser, // Call the logout function
              ),
            ),
          ],
        ),
      ), // drawer
      endDrawer: endDrawer(context),
      body: _pages[selectedPage], // body for pages to display
    );
  }
}
