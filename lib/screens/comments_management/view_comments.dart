import 'package:flutter/material.dart';
import 'package:quotes_app/database_manager/comments_handler/database_handler_comments.dart';
import 'package:quotes_app/screens/comments_management/add_comments.dart';
import '../../components/layout.dart';
import '../../model/user_model.dart';
import '../../screens/comments_management/edit_comments.dart';

class ViewComments extends StatefulWidget {
  static String routeName = '/ViewComments';
  //final String? QuoteID = 'D3onguNGLjHhaQ509Xz3';
  final String? quoteID;
  final String? quote;
  final String? docID;
  final String? userID;

  final String? URL = 'https://www.kindpng.com/imgv/ixJxxh_transparent-avatar-png-male-avatar-icon-transparent-png/';

  const ViewComments({
    Key? key,
    this.userID,
    this.quoteID,
    this.docID,
    this.quote,
  }) : super(key: key);

  @override
  State<ViewComments> createState() => _ViewCommentsState();
}


class _ViewCommentsState extends State<ViewComments> {

  List userDetailList = [];
  UserModel loggedInUser = UserModel();
  List comments = [];
  String? UserIDforDelete = '';
  List UsersList = [];
  String? Username = ' ';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentsList();
  }

  getCommentsList() async {
    List result = await DatabaseHandler().getCommentsbyQuoteID(widget.quoteID.toString());

    if(result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No comments yet!!')
          )
      );
    }else{
      setState(() {
        comments = result;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    List commentDetailList = [];
    String docID = '';
    String username ='';

    fetchCommentsDetails(commentToRetrieve) async {

      List result = await DatabaseHandler().getCommentDetails(commentToRetrieve);
      print( commentToRetrieve);
      print(result);
      if(result == null){
        print('Unable to retrieve!');
      }else {
        setState(() {
          commentDetailList = result;
        });

        print('DOC ID : ' + commentDetailList[1].toString());

        final iterableMap = commentDetailList
            .whereType<Map>()
            .first;
        print(iterableMap['UserId']);

        setState(() {
          docID = commentDetailList[1].toString();
          UserIDforDelete = iterableMap['UserId'];
        });

        print(UserIDforDelete);




      }
    }

    navigateToEdit(contentText) async {
      await fetchCommentsDetails(contentText);
          if (UserIDforDelete == widget.userID) {
            {Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => UpdateComments(quoteID: contentText, quote: widget.quote.toString(), userID: widget.userID.toString(),
                    )));
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('You can not edit this comment!')
                )
            );


      }

    }

    void deleteComment(String commentID) async {

        await fetchCommentsDetails(commentID).then((value) async {

          if (UserIDforDelete == widget.userID){
            bool result = await DatabaseHandler().deleteComments(docID);

            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Comment Deleted!')
                  )
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewComments(quoteID: widget.quoteID.toString(), quote: widget.quote.toString()
                      )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Something went wrong. Try again later!')
                  )
              );
            }

          }else{
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('You can not delete this comment!')
                )
            );
          }

        });

    }

      return Layout(
      context: "Comments",
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
          const SizedBox(width: double.infinity, height: 10,),
          Flexible(
            child: comments.isNotEmpty ?
             ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2, color: Color.fromARGB(255, 69, 25, 171)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 16,right: 16,top: 5,bottom: 5),
                    child: Row(
                      children:  [
                        Expanded(child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDLCMYvrwSI4UZ286J8ypqIvxrYQSglDGy5chXyDRCbZ62dyJGqy-S4-XtSqfqjLmiukc&usqp=CAU'),
                              maxRadius: 40,
                            ),
                            SizedBox(width: 20,),
                            Expanded(child: Container(

                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(' ', style: TextStyle(fontSize: 16), ),
                                  Text(comments[index]['Content'], style: TextStyle(fontSize: 16), ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [ (widget.userID == comments[index]['UserId'])
                                          ? Text('Added by you', style: TextStyle(fontSize: 13,color: Colors.grey.shade600,))
                                          : Text(username, style: TextStyle(fontSize: 13,color: Colors.grey.shade600,)),

                                      Spacer(),
                                      IconButton(onPressed: () {deleteComment(comments[index]['Content'].toString());}, icon: const Icon(Icons.delete_forever)),
                                      IconButton(onPressed: () {navigateToEdit(comments[index]['Content'].toString());}, icon: const Icon(Icons.edit)),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ))
                      ],
                    ),

                    );
                }

            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.hourglass_empty, size: 50.0,),
                SizedBox(width: double.infinity, height: 10.0,),
                Text('No comments yet !'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => (AddComments(quoteID: widget.quoteID.toString(), quote: widget.quote.toString(), UserId: widget.userID.toString())
                )));
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

}