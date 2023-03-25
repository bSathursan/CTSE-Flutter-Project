import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/quote_handler/database_handler.dart';
import 'package:quotes_app/screens/quote_management/view_quotes_person.dart';

class PersonalQuotesList extends StatefulWidget {
  static String routeName = '/PersonalQuotesList';
  final String? userID;//Added by Sanjay - UserId as route param (BUG FIX)

  const PersonalQuotesList({
    Key? key,
    this.userID
  }) : super(key: key);

  @override
  State<PersonalQuotesList> createState() => _PersonalQuotesListState();
}

class _PersonalQuotesListState extends State<PersonalQuotesList> {

  List quotesList = [];
  String selectedCategory = 'Personal';
  Icon cusIcon = const Icon(Icons.search);

  Widget cusSearchBar = const Center(child: Text("Personal Quotes"));

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }


  fetchQuotesList() async {
    List result = await DatabaseHandler().getQuotesByCategory(selectedCategory);

    if(result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error in retrieving details!!')
          )
      );
    }else{
      setState(() {
        quotesList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: cusSearchBar,
          actions: [
            IconButton(
              icon: cusIcon,
              onPressed: (){
                setState(() {
                  if(cusIcon.icon == Icons.search){
                    cusIcon = const Icon(Icons.cancel);
                    cusSearchBar = const TextField(
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here",
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    );
                  }
                  else{
                    cusIcon = const Icon(Icons.search);
                    cusSearchBar = const Text("Personal Quotes");
                  }
                });
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 22, 17, 36),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: List.generate(quotesList.length, (index) {
                return Center(
                  child: Card(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                width: double.infinity,
                                height: 10,
                              ),
                              IconButton(icon: Image.network(quotesList[index]['personImage']), iconSize: 130, onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => ViewQuotesByPerson(selectedPersonName: quotesList[index]['personName'], userID: widget.userID.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                                ));
                              },),
                              Text(quotesList[index]['personName'], style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                      )),
                );
              }),
            ),
          ),
        ));
  }
}

