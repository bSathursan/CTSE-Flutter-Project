import 'package:flutter/material.dart';
import 'package:quotes_app/components/layout.dart';
import '../../database_manager/comments_handler/database_handler_comments.dart';
import '../../screens/comments_management/view_comments.dart';

class AddComments extends StatefulWidget {
  static String routeName = '/addComment';
  final String? quote;
  final String? quoteID;
  final String? UserId;

  const AddComments({
    Key? key,
    this.quoteID,
    this.quote,
    this.UserId,
  }) : super(key: key);

  @override
  State<AddComments> createState() => _AddCommentsState();
}

class _AddCommentsState extends State<AddComments> {

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }

  final _formkey = GlobalKey<FormState>();

  List quoteDetailList = [];

  String quoteText = '';
  String personImage = '';
  String personName = '';
  String docId = '';
  String? content;
  DateTime? time = DateTime.now();

  fetchQuotesList() async {
    List result = await DatabaseHandler().getQuoteDetails(
        widget.quote.toString());

    if (result == null) {
      print('Unable to retrieve!');
    } else {
      setState(() {
        quoteDetailList = result;
      });

      setState(() {
        docId = quoteDetailList[1].toString();
      });

      for (var element in quoteDetailList) {
        setState(() {
          personName = element['personName'].toString();
          personImage = element['personImage'].toString();
          quoteText = element['quote'].toString();
          //category = element['category'].toString();
        });
      }
    }
  }


  saveComment () async {
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
      bool result = await DatabaseHandler().saveComment(widget.quoteID.toString(),widget.UserId.toString(), content, time);

      if(result){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment Added Successfully'),)
        );
        {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewComments(quoteID: widget.quoteID.toString(), quote: widget.quote.toString(),
                  userID: widget.UserId.toString(),
                )));}
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong. Try again later!'),)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Layout(
      context: 'Add Comment',
        widget: Column(
          children: [
            Flexible(
              //flex: 7,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text("Enjoy your own life without comparing it with that of another",
                          style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 40,),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: personImage.isNotEmpty ? Image.network(personImage, width: 200, height: 200,) : null,
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 40,),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('"'+ quoteText +'"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Text('By: '+ personName,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 40,),
                ],
              ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Card(
                            child: Form(
                                key: _formkey,
                                child: Container(
                                  width: 400,
                                  height: 315,
                                  child: Card(
                                    elevation: 40,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: double.infinity,
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Enter Comment*'),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: TextFormField(
                                            validator: (value) {
                                              if(value==null || value.isEmpty){
                                                return 'Comment Field is required';
                                              }
                                              return null;
                                            },
                                            maxLines: 4,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              if (value != null) {
                                                content = value;
                                                print(content);
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: double.infinity,
                                          height: 25,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: saveComment,
                                            child: const Text('Add Comment'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 69, 25, 171),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 138, vertical: 15),
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                    ),)
                    ],
                    ),
            );

  }
}