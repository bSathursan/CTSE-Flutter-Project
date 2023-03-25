import 'package:flutter/material.dart';
import 'package:quotes_app/screens/favorite_management/view_favorites.dart';
import 'package:quotes_app/screens/quote_management/view_quotes_category.dart';

import '../quote_management/view_quotes_people.dart';

class FindQuotes extends StatefulWidget {
  static String routeName = '/findQuotes';
  final String? UserId;

  const FindQuotes({
    Key? key,
    this.UserId
  }) : super(key: key);

  @override
  State<FindQuotes> createState() => _FindQuotesState();
}

class _FindQuotesState extends State<FindQuotes> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Discover Your Quotes'),
        ),
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
        actions: [IconButton(onPressed: () {
          widget.UserId != null ? Navigator.push(context, MaterialPageRoute(
              builder: (_) => ViewFavorites(userID: widget.UserId.toString())//Removed Hard coded - US001
          )) : ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No related user ID for logged in User!!')
              )
          );
          },
            icon: const Icon(Icons.favorite_sharp))],
      ),
      body: Card(
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
            const SizedBox(width: double.infinity, height: 10,),
            //Child 02
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
              margin: const EdgeInsets.all(8.0),
              elevation: 35,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/images/favorite_management/people.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () {
                            print('SEND USER :'+widget.UserId.toString());
                            widget.UserId != null ? Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ViewQuotesPeople(userID: widget.UserId.toString(),)
                            )) : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Issues with logged in User!!')
                                )
                            );
                          },
                          child: const Text('Discover Quotes by People')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: double.infinity, height: 40,),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.all(8.0),
              elevation: 25,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/images/favorite_management/category.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.UserId != null ? Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ViewQuotesCategory(userId: widget.UserId.toString(),)
                            )): ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Issues with logged in User!!')
                                )
                            );
                          },
                          child: const Text('Discover Quotes by Category')),
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
