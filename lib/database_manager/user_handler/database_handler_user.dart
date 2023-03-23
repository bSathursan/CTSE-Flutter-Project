import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandlerUser{

  final CollectionReference userList = FirebaseFirestore.instance.collection('users');

  List userListToReturn = [];
  List userDetailListToReturn = [];

  Future getAllUsers() async {
    try{
      List allUsersLocal = [];

      await userList.where('category', isEqualTo: 'User').get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          allUsersLocal.add(element.data());
        }
        userListToReturn = allUsersLocal;
      });
      return userListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieving Quotes '+ error.toString());
      return null;
    }
  }

  Future getUserDetails(String userId) async {
    try{

      List userDetaillocal = [];

      await userList.where('uid', isEqualTo: userId).get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          userDetaillocal.add(element.data());
        }
        userDetailListToReturn = userDetaillocal;
      });
      return userDetailListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
    }
  }

  Future updateUser (String? docID, String? newFirstName, String? newSecondName, String? newEmail) async {
    try{
      bool successStatus = false;

      await userList.doc(docID).update({
        'firstname': newFirstName,
        'secondname': newSecondName,
        'email': newEmail
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