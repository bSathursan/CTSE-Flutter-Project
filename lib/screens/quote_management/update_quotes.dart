import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quotes_app/components/layout.dart';
import 'package:quotes_app/screens/quote_management/quotes_list_for_admin.dart';
import '../../database_manager/quote_handler/database_handler.dart';

class UpdateQuotes extends StatefulWidget {
  static String routeName = '/updateQuotes';
  final String? quote;

  const UpdateQuotes({
    Key? key,
    this.quote,
  }) : super(key: key);

  @override
  State<UpdateQuotes> createState() => _UpdateQuotesState();
}

class _UpdateQuotesState extends State<UpdateQuotes> {
  var selectedCategory;
  String imageURL = '';

  List quoteDetailList = [];

  String retrievedPersonName = '';
  String retrievedPersonImage = '';
  String retrievedQuote = '';
  String docID = '';

  @override
  void initState() {
    super.initState();
    fetchQuotesList();
  }


  fetchQuotesList() async {
    List result = await DatabaseHandler().getQuoteDetails(widget.quote.toString());

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

      for (var element in quoteDetailList) {
        setState(() {
          retrievedPersonName = element['personName'].toString();
          retrievedPersonImage = element['personImage'].toString();
          retrievedQuote = element['quote'].toString();
          selectedCategory = element['category'].toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    String? personName;
    String? quote;

    FirebaseStorage firebaseStorage =
        FirebaseStorage.instance;

    List<String> _categoryType = <String>[
      'Motivational',
      'Educational',
      'Religious',
      'Nature',
      'Sports',
      'Personal',
    ];


    Future uploadImage() async {
      final picker = ImagePicker();
      XFile? pickedImage;

      try {
        pickedImage = await picker.pickImage(source: ImageSource.gallery);

        final String imageName = path.basename(pickedImage!.path);
        File imageFile = File(pickedImage.path);

        Reference reference = firebaseStorage.ref().child(imageName);
        await reference.putFile(imageFile);

        String downloadURL = await reference.getDownloadURL();
        print('IMAGE URL : ' + downloadURL);

        if(downloadURL != ''){
          setState(() {
            retrievedPersonImage = downloadURL;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded Successfully'),)
          );
          print('Download Image URL : '+ retrievedPersonImage.toString());
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded Failed!'),)
          );
        }
      } catch (error) {
        print('Error Occurred : ' + error.toString());
      }
    }


    updateQuote () async {
      if(_formkey.currentState!.validate()){
        _formkey.currentState!.save();
        bool result = await DatabaseHandler().updateQuote(docID, personName, quote, selectedCategory, retrievedPersonImage);

        if(result){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quote Updated Successfully'),)
          );
          Navigator.of(context).pushNamed(AdminQuoteList.routeName);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong. Try again later!'),)
          );
        }
      }
    }

    return Layout(
      context: 'Update Quote',
      widget: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Form(
                  key: _formkey,
                  child: Container(
                    width: 400,
                    height: 715,
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
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: retrievedPersonImage.isNotEmpty ? Image.network(retrievedPersonImage, width: 150, height: 150,) : null,
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: uploadImage,
                              child: const Text(' Edit Image'),
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 5,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Category*'),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                hint: Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: _categoryType
                                    .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  value: value,
                                ))
                                    .toList(),
                                onChanged: (selectedCategoryType) {
                                  setState(() {
                                    selectedCategory = selectedCategoryType;
                                  });
                                },
                                value: selectedCategory,
                                elevation: 10,
                                alignment: Alignment.center,
                                style:const TextStyle(color:Colors.black, fontSize: 20),
                                icon: const Icon(Icons.arrow_drop_down_circle),
                                iconEnabledColor: Color.fromARGB(255, 69, 25, 171),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Person Name*'),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Person Name Field is required';
                                }
                                return null;
                              },
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              initialValue: retrievedPersonName,
                              onSaved: (String? value) {
                                if (value != null) {
                                  personName = value;
                                  print(personName);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Enter Quote*'),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: retrievedQuote,
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Quote Field is required';
                                }
                                return null;
                              },
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (String? value) {
                                if (value != null) {
                                  quote = value;
                                  print(quote);
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
                              onPressed: updateQuote,
                              child: const Text('Update Quote'),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 69, 25, 171),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 130, vertical: 15),
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
        ),
      ),
    );
  }
}
