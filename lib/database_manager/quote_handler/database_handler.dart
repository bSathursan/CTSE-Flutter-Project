import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler {
  final CollectionReference quoteslist = FirebaseFirestore.instance.collection('Quotes');

  List quotesListToReturn = [];
  List personQuotesListToReturn = [];
  List personDetailListToReturn = [];
  List quoteDetailListToReturn = [];
  List allQuoteListToReturn = [];


  Future getQuotesByCategory(String selectedCategory) async {
    try{

      List quotesListlocal = [];
      
      await quoteslist.where('category', isEqualTo: selectedCategory).get().then((querysnapshot) {
        querysnapshot.docs.forEach((element) {
          quotesListlocal.add(element.data());
        });
        quotesListToReturn = quotesListlocal;
      });
      return quotesListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
    }
  }

  Future getQuotesByPersonName(String personName) async {
    try{

      List quotesListlocal = [];

      await quoteslist.where('personName', isEqualTo: personName).get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          quotesListlocal.add(element.data());
        }
        personQuotesListToReturn = quotesListlocal;
      });
      return personQuotesListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
    }
  }


  Future getPersonDetails(String personName) async {
    try{

      List personDetaillocal = [];

      await quoteslist.where('personName', isEqualTo: personName).get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          personDetaillocal.add(element.data());
        }
        personDetailListToReturn = personDetaillocal;
      });
      return personDetailListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieve '+ error.toString());
      return null;
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

  Future saveQuote (String? personName, String? quote, String? selectedCategory, String? imageURL) async {
    try{
      bool successStatus = false;

      await quoteslist.add({
        'personName': personName,
        'quote': quote,
        'category': selectedCategory,
        'personImage': imageURL
      }).then((value){
        successStatus = true;
      });
      return successStatus;
    }catch(error) {
      print('Error Occurred in Adding Quote '+ error.toString());
      return false;
    }
  }


  Future getAllQuotes() async {
    try{
      List allQuoteDetailLocal = [];

      await quoteslist.get().then((querysnapshot) {
        for (var element in querysnapshot.docs) {
          allQuoteDetailLocal.add(element.data());
        }
        allQuoteListToReturn = allQuoteDetailLocal;
      });
      return allQuoteListToReturn;
    }catch(error) {
      print('Error Occurred in Retrieving Quotes '+ error.toString());
      return null;
    }
  }


  Future updateQuote (String? docID, String? newPersonName, String? newQuote, String? newSelectedCategory, String? newImageURL) async {
    try{
      bool successStatus = false;

      await quoteslist.doc(docID).update({
        'personName': newPersonName,
        'quote': newQuote,
        'category': newSelectedCategory,
        'personImage': newImageURL
      }).then((value){
        successStatus = true;
      });
      return successStatus;
    }catch(error) {
      print('Error Occurred in Updating Quote '+ error.toString());
      return false;
    }
  }


  Future removeQuote (String docId) async {
    try{
      bool successStatus = false;

      await quoteslist.doc(docId)
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
}