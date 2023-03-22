import 'package:flutter/material.dart';

class ViewPersonDetails extends StatelessWidget {
  final String personImage;
  final String personName;

  const ViewPersonDetails({
    Key? key,
    required this.personImage,
    required this.personName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ClipRRect(
              child: personImage.isNotEmpty ? Image.network(personImage, width: 120, height: 120,) : null,
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        const SizedBox(width: double.infinity, height: 10,),
        Text(personName, style: Theme.of(context).textTheme.bodyMedium,)
      ],
    );
  }
}
