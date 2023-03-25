import 'package:flutter/material.dart';
import 'package:quotes_app/screens/admin_management/view_users.dart';
import '../../screens/quote_management/quotes_list_for_admin.dart';
import 'login_screen.dart';

class AdminDashboard extends StatelessWidget {
  static String routeName = '/dashboard';

  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Admin Dashboard'),
        ),
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/user_management/admindd.jpg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(83.0),
              child: Text(
                'Daily Quotes',
                style: TextStyle(fontSize: 48, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: SizedBox(
                width: 270,
                height: 1040,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1.0,
                      primary: Color.fromARGB(255, 69, 25, 171).withOpacity(0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                          side: BorderSide(color: Colors.white)),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushNamed(ViewUsers.routeName)
                    },
                    child: const Text('Manage User Profiles',
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 20,
            ),
            Flexible(
              child: SizedBox(
                width: 270,
                height: 140,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1.0,
                      primary: Colors.red.withOpacity(0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                          side: BorderSide(color: Colors.white)),
                    ),
                    onPressed: () =>
                    {Navigator.of(context).pushNamed(AdminQuoteList.routeName)},
                    child: const Text('Manage Quotes',
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 170,
            ),
            const Center(
              child: Text(
                'Powered by Alpha Wolves',
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
