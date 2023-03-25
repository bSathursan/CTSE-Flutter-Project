import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/quote_handler/database_handler.dart';
import 'package:quotes_app/screens/quote_management/update_quotes.dart';
import '../../components/layout.dart';
import '../favorite_management/view_single_quote.dart';

class AdminQuoteList extends StatefulWidget {
  static String routeName = '/AdminQuoteList';

  final String? docID;
  final String? quote;

  const AdminQuoteList({Key? key, this.docID, this.quote}) : super(key: key);

  @override
  State<AdminQuoteList> createState() => _AdminQuoteListState();
}

class _AdminQuoteListState extends State<AdminQuoteList> {
  List quotesList = [];

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }

  fetchQuotesList() async {
    List result = await DatabaseHandler().getAllQuotes();

    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error in retrieving details!!')));
    } else {
      setState(() {
        quotesList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    List quoteDetailList = [];
    String docID = '';


    fetchQuotesDetails(quoteToRetrieve) async {
      List result = await DatabaseHandler().getQuoteDetails(quoteToRetrieve);

      if(result == null){
        print('Unable to retrieve!');
      }else{
        setState(() {
          quoteDetailList = result;
        });

        print('DOC ID : '+quoteDetailList[1].toString());
        setState(() {
          docID = quoteDetailList[1].toString();
        });
      }
    }


    void deleteQuote(String quoteToDelete) async {

      await fetchQuotesDetails(quoteToDelete).then((value) async {
        bool result = await DatabaseHandler().removeQuote(docID);

        if(result){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Quote Removed from Database!')
              )
          );
          Navigator.of(context).pushNamed(AdminQuoteList.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Something went wrong. Try again later!')
              )
          );
        }
      });
    }

    return Layout(
      context: "All Quotes List",
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(1.0),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: quotesList[index]['personImage'].toString().isNotEmpty ? Image.network(quotesList[index]['personImage']) : null,
                      ),
                      title: Text(
                        quotesList[index]['quote'],
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      subtitle: Text(quotesList[index]['personName']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ViewSingleQuote(
                                    quote: quotesList[index]['quote'])));
                      },
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          List<String> newValues = value.toString().split(':');

                          if(newValues[0].toString().contains('Edit')){
                            //print(quotesList[index]['quote']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UpdateQuotes(
                                      quote: newValues[1].toString(),
                                    )));

                          }
                          if(newValues[0].toString().contains('Remove')){
                            deleteQuote(quotesList[index]['quote'].toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AdminQuoteList()));
                            print(newValues[1].toString());
                            //print('Move to Remove UI');
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            child: const Text("Remove"),
                            value: 'Remove :'+ quotesList[index]['quote'].toString(),
                          ),
                          PopupMenuItem(
                            child: const Text("Edit"),
                            value: 'Edit :'+ quotesList[index]['quote'].toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
