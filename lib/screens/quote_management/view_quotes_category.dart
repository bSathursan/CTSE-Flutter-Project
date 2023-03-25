import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/quote_handler/database_handler.dart';
import 'package:quotes_app/screens/quote_management/view_quotes.dart';

class ViewQuotesCategory extends StatefulWidget {
  static String routeName = '/ViewQuotesCategory';
  final String? userId;

  const ViewQuotesCategory({Key? key, this.userId}) : super(key: key);

  @override
  State<ViewQuotesCategory> createState() => _ViewQuotesCategoryState();
}

class _ViewQuotesCategoryState extends State<ViewQuotesCategory> {

  List allQuotesList = [];//Get all the quotes with all details
  List categories = [];//Get the categories from the list of quotes
  Set<String> uniqueCategories = {};//Using a map to pick only the unique categories
  List uniqueCategoriesList = [];//Adding the unique categories to a new list

  Icon cusIcon = const Icon(Icons.search);

  Widget cusSearchBar = const Center(child: Text("Quotes by Category"));

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

      for (var element in allQuotesList) {
        categories.add(element['category'].toString());
      }

      uniqueCategories = Set.from(categories);
      uniqueCategoriesList = uniqueCategories.toList();
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
                  cusSearchBar = const Center(child: Text("Quotes by Category"));
                }
              });
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
      ),
      body: uniqueCategoriesList.isNotEmpty ? ListView.builder(
          itemCount: uniqueCategoriesList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: 100,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 69, 25, 171),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 52, vertical: 10),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ViewQuotes(selectedCategory: uniqueCategoriesList[index].toString(), UserId: widget.userId.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                    ));
                  },
                  child: Text(
                    uniqueCategoriesList[index],
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
              ),
            );
          }
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.hourglass_empty, size: 50.0,),
          SizedBox(width: double.infinity, height: 10.0,),
          Text('Categories unavailable!'),
        ],
      ),
    );
  }
}
