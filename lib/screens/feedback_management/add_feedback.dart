import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quotes_app/components/layout.dart';

import 'package:quotes_app/database_manager/feedback_handler/database_handler_feedback.dart';

class AddFeedback extends StatefulWidget {
  static String routeName = '/addFeedback';

  final String? userId;//User ID passed from the HomePage

  const AddFeedback({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    double? ratingInput = 3.0;//Default rating set to 3
    String? comments;

    saveFeedback () async {
      if(_formkey.currentState!.validate()){
        _formkey.currentState!.save();
        bool result = await DatabaseHandler().saveFeedback(widget.userId.toString(), ratingInput, comments);

        if(result){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feedback Saved Successfully'),)
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong. Try again later!'),)
          );
        }
      }
    }

    return Layout(
      context: 'Add Your Feedback',
      widget: SingleChildScrollView(
        child: Column(
          children: [
            //Child 01
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("Enjoy your own life without comparing it with that of another",
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            const SizedBox(width: double.infinity, height: 10,),
            Image.asset('assets/images/favorite_management/feedbackk.jpg', width: 250, height: 250,),
            const SizedBox(width: double.infinity, height: 10,),
            Card(
              child: Form(
                key: _formkey,
                  child: SizedBox(
                    width: 350,
                    height: 330,
                    child: Card(
                      elevation: 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Rate your experience'),
                          ),
                          const SizedBox(width: double.infinity, height: 10,),
                          Center(
                            child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 69, 25, 171),
                                ),
                                onRatingUpdate: (rating) {
                                  ratingInput = rating;
                                }
                            ),
                          ),
                          const SizedBox(width: double.infinity, height: 10,),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Add Comments'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if(value==null || value.isEmpty){
                                  return 'Comments Field is required';
                                }
                                return null;
                              },
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (String? value) {
                                if(value!=null){
                                  comments = value;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: double.infinity, height: 10,),
                          Center(
                            child: ElevatedButton(
                                onPressed: saveFeedback,
                                child: const Text('Add Feedback')
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
