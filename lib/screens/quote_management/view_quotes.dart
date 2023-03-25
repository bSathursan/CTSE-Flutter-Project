import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/quote_handler/database_handler.dart';
import '../../components/layout.dart';
import '../favorite_management/view_single_quote.dart';

class ViewQuotes extends StatefulWidget {
  static String routeName = '/viewQuotes';
  final String? selectedCategory;
  final String? UserId;

  const ViewQuotes({
    Key? key,
    this.selectedCategory,
    this.UserId,
  }) : super(key: key);

  @override
  State<ViewQuotes> createState() => _ViewQuotesState();
}

class _ViewQuotesState extends State<ViewQuotes> {

  List quotesList = [];

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }


  fetchQuotesList() async {
    List result = await DatabaseHandler().getQuotesByCategory(widget.selectedCategory.toString());

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

    return Layout(
        context: "List of Quotes",
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text("Enjoy your own life without comparing it with that of another",
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            Center(child: Text('Selected Category : '+widget.selectedCategory.toString())),
            const SizedBox(width: double.infinity, height: 10,),
            Flexible(
              child: quotesList.isNotEmpty ? ListView.builder(
                  itemCount: quotesList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: quotesList[index]['personImage'].toString().isNotEmpty ? Image.network(quotesList[index]['personImage']) : null,
                        ),
                        title: Text(quotesList[index]['quote'], overflow: TextOverflow.ellipsis, softWrap: false,),
                        subtitle: Text(quotesList[index]['personName']),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ViewSingleQuote(quote: quotesList[index]['quote'], UserId: widget.UserId.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
                          ));
                        },
                      ),
                    );
                  }
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.hourglass_empty, size: 50.0,),
                  SizedBox(width: double.infinity, height: 10.0,),
                  Text('No quotes available under selected category !'),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
