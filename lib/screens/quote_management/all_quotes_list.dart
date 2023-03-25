import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/quote_handler/database_handler.dart';
import 'package:quotes_app/screens/quote_management/view_quotes_person.dart';

class AllQuotesList extends StatefulWidget {
  static String routeName = '/AllQuotesList';
  final String? userID;//Added by Sanjay - UserId as route param (BUG FIX)

  const AllQuotesList({
    Key? key,
    this.userID
  }) : super(key: key);

  @override
  State<AllQuotesList> createState() => _AllQuotesListState();
}

class _AllQuotesListState extends State<AllQuotesList> {

  List allQuotesList = [];
  Icon cusIcon = const Icon(Icons.search);

  Widget cusSearchBar = const Center(child: Text("All Quotes"));

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }

  fetchQuotesList() async {
    List result = await DatabaseHandler().getAllQuotes();

    if(result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error in retrieving details!!')
          )
      );
    }else{
      setState(() {
        allQuotesList = result;
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
                      cusSearchBar = const Text("All Quotes");
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
              children: List.generate(allQuotesList.length, (index) {
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
                              IconButton(icon: Image.network(allQuotesList[index]['personImage']), iconSize: 130, onPressed: () {
                                //Navigator.of(context).pushNamed(ViewQuotesByPerson.routeName);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => ViewQuotesByPerson(selectedPersonName: allQuotesList[index]['personName'], userID: widget.userID.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                                ));
                              },),
                              Text(allQuotesList[index]['personName'], style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                      )),
                );
              }),
            ),
          ),
        ));
  }
}

