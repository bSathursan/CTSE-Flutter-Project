class Quotes {
  final String personImage;
  final String quote;
  final String personName;
  final String category;
  const Quotes({
    required this.personImage,
    required this.quote,
    required this.personName,
    required this.category,
  });

  factory Quotes.fromJSON(Map<String, dynamic> data) {
    return Quotes(
        personImage: data['personImage'],
        quote: data['quote'],
        personName: data['personName'],
        category: data['category'],
    );
  }
}

const List<Quotes> quotesList = [
  Quotes(
    personImage: "assets/images/favorite_management/person1.jpg",
    quote: 'Early bird catches worm',
    personName: 'Charles David',
    category: 'Motivational',
  ),
  Quotes(
    personImage: "assets/images/favorite_management/person2.jfif",
    quote: 'Wait till the sun shines',
    personName: 'Robert Martin',
    category: 'Fun Facts',
  ),
  Quotes(
    personImage: "assets/images/favorite_management/person1.jpg",
    quote: 'Succes is not a destination its a journey',
    personName: 'Robert Downey',
    category: 'Motivational',
  ),
];