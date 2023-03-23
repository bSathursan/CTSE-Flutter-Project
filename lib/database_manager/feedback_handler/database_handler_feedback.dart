import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler{
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('UserFeedback');

  Future saveFeedback(String userId, double? ratingInput, String? comments) async{

    try{
      bool successStatus = false;

      await collectionReference.add({
        'userId': userId,
        'rating': ratingInput,
        'comments': comments,
      }).then((value){
        successStatus = true;
      });
      return successStatus;
    }catch(error) {
      print('Error Occurred in Add Feedback '+ error.toString());
      return false;
    }

  }
}