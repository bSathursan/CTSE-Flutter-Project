import 'package:flutter/material.dart';
import 'package:quotes_app/components/favorite_management_components/view_person_details.dart';
import 'package:quotes_app/components/layout.dart';
import 'package:quotes_app/screens/favorite_management/view_single_quote.dart';

import '../../database_manager/quote_handler/database_handler.dart';

class ViewQuotesByPerson extends StatefulWidget {
  static String routeName = '/viewQuotesByPerson';
  final String? selectedPersonName;
  final String? userID;//Added by Sanjay - UserId as route param (BUG FIX)

  const ViewQuotesByPerson({
    Key? key,
    this.selectedPersonName,
    this.userID
  }) : super(key: key);

  @override
  State<ViewQuotesByPerson> createState() => _ViewQuotesByPersonState();
}

class _ViewQuotesByPersonState extends State<ViewQuotesByPerson> {

  List quotesList = [];
  List personDetail = [];
  String personName = '';
  String personImage = '';
  
  @override
  void initState() {
    super.initState();
    fetchQuotesList();
    fetchPersonDetail();
  }


  fetchPersonDetail() async {
    List result = await DatabaseHandler().getPersonDetails(widget.selectedPersonName.toString());

    if(result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error in retrieving details!!')
          )
      );
    }else{
      setState(() {
        personDetail = result;
      });

      for (var element in personDetail) {
        setState(() {
          personName = element['personName'].toString();
          personImage = element['personImage'].toString();
        });
      }
    }

  }

  fetchQuotesList() async {
    List result = await DatabaseHandler().getQuotesByPersonName(widget.selectedPersonName.toString());

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
        context: 'View Quotes By Person',
      widget: Column(
        children: [
          ViewPersonDetails(
              personImage: personImage,
              personName: personName
          ),
          const SizedBox(width: double.infinity, height: 15,),
          Flexible(
            child: quotesList.isNotEmpty ? ListView.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(quotesList[index]['quote'], overflow: TextOverflow.ellipsis, softWrap: false,),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Category : '+quotesList[index]['category'], style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => ViewSingleQuote(quote: quotesList[index]['quote'], UserId: widget.userID.toString(),)//Added by Sanjay - UserId as route param (BUG FIX)
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
                Text('No quotes available under selected person !'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
