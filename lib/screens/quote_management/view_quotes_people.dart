import 'package:flutter/material.dart';
import 'package:quotes_app/screens/quote_management/all_quotes_list.dart';
import 'package:quotes_app/screens/quote_management/personal_quotes_list.dart';

class ViewQuotesPeople extends StatefulWidget {
  static String routeName = '/ViewQuotesPeople';
  final String? userID;//Added by Sanjay - UserId as route param (BUG FIX)

  const ViewQuotesPeople({
    Key? key,
    this.userID
  }) : super(key: key);

  @override
  State<ViewQuotesPeople> createState() => _ViewQuotesPeopleState();
}

class _ViewQuotesPeopleState extends State<ViewQuotesPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Quotes by People'),
        ),
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
      ),
      body: Center(
        child: Column(
          children: [
            //Child 01
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("Enjoy your own life without comparing it with that of another",
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            const SizedBox(width: double.infinity, height: 50,),
            //Child 02
            Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/quotes_management/alll.jpg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: SizedBox(
                      width: 190,
                      child: ElevatedButton(
                          onPressed: () {
                            //Navigator.of(context).pushNamed(AllQuotesList.routeName);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => AllQuotesList(userID: widget.userID.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                            ));
                          },
                          child: const Text('All Quotes')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: double.infinity, height: 40,),
            Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/quotes_management/personall.jpg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: SizedBox(
                      width: 190,
                      child: ElevatedButton(
                          onPressed: () {
                            //Navigator.of(context).pushNamed(PersonalQuotesList.routeName);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => PersonalQuotesList(userID: widget.userID.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                            ));
                          },
                          child: const Text('Personal Quotes')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
