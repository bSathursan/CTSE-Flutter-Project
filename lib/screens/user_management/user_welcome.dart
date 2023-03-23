import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/model/user_model.dart';
import '../favorite_management/find_quotes.dart';
import '../feedback_management/add_feedback.dart';
import '../quote_management/add_quotes.dart';
import 'login_screen.dart';

class UserWelcome extends StatefulWidget {
  static String routeName = '/UserWelcome';

  const UserWelcome({Key? key}) : super(key: key);

  @override
  State<UserWelcome> createState() => _UserWelcomeState();
}

class _UserWelcomeState extends State<UserWelcome> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? userID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('user ID' + user.toString()!);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        print('Logged in user ID : '+loggedInUser.uid.toString());//Added By Sanjay - Get the current user ID
        userID = loggedInUser.uid.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Daily Quote App'),
        ),
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddFeedback(
                          userId: userID,
                        )));
              },
              icon: const Icon(Icons.feedback_sharp)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.login)),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/user_management/bgF.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(83.0),
              child: Text(
                'Daily Quotes',
                style: TextStyle(
                    fontSize: 48,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: SizedBox(
                width: 270,
                height: 140,
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
                    onPressed: () =>

                    {Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (_) => FindQuotes(UserId: loggedInUser.uid
                    )))},
                    child: const Text('Discover Your Quotes',
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
                    {Navigator.of(context).pushNamed(AddQuotes.routeName)},
                    child: const Text('Add Your Quotes',
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 140,
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

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
