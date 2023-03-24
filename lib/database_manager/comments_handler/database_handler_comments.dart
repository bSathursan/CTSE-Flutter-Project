import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler {
  final CollectionReference commentlist = FirebaseFirestore.instance.collection(
      'UserComments');
  final CollectionReference quoteslist = FirebaseFirestore.instance.collection(
      'Quotes');

  List commentListToReturn = [];
  List quoteDetailListToReturn = [];
  List commentListToReturnToDelete = [];
  List userDetailListToReturn = [];
  List userListToReturn = [];


  Future getCommentsbyQuoteID(String quoteId) async {
    try {
      List commentsList = [];

      await commentlist.where('QuoteId', isEqualTo: quoteId).get().then((
          querysnapshot) {
        for (var element in querysnapshot.docs) {
          commentsList.add(element.data());
        }
        commentListToReturn = commentsList;
      });
      return commentListToReturn;
    } catch (error) {
      print('Error Occurred in Retrieve ' + error.toString());
      return null;
    }
  }


  Future saveComment(String? QuoteId, String? UserId, String? content, DateTime? time) async {
    try {
      bool successStatus = false;

      await commentlist.add({
        'Content': content,
        'QuoteId': QuoteId,
        'UserId': UserId,
        'Time': time
      }).then((value) {
        successStatus = true;
      });
      return successStatus;
    } catch (error) {
      print('Error Occurred in Adding Comments ' + error.toString());
      return false;
    }
  }


  Future getQuoteDetails(String quote) async {
    try{

      List quoteDetaillocal = [];
      String docID = '';

      await quoteslist.where('quote', isEqualTo: quote).get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          docID = element.id.toString();
          quoteDetaillocal.add(element.data());
        }
        quoteDetaillocal.add(docID);
        quoteDetailListToReturn = quoteDetaillocal;
      });
      return quoteDetailListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
    }
  }


  Future getCommentDetails(String content) async {
    try{

      List commentDetaillocal = [];
      String docID = '';

      await commentlist.where('Content', isEqualTo: content).get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          docID = element.id.toString();
          commentDetaillocal.add(element.data());
        }
        commentDetaillocal.add(docID);
        commentListToReturnToDelete = commentDetaillocal;
      });
      return commentListToReturnToDelete;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
    }
  }


  Future deleteComments(String commentId) async {

    try{
      bool successStatus = false;

      await commentlist.doc(commentId)
          .delete()
          .then((value) {
        successStatus = true;
      });
      return successStatus;
    }catch(error) {
      print('Error Occurred in Removing Quote'+ error.toString());
      return false;
    }
  }


  Future updateComment (String? docID, String? content) async {
    try{
      bool successStatus = false;
      print('dssd' + docID!);

      await commentlist.doc(docID).update({
        'Content': content,
      }).then((value){
        successStatus = true;
      });
      return successStatus;
    }catch(error) {
      print('Error Occurred in Updating Quote '+ error.toString());
      return false;
    }
  }
}