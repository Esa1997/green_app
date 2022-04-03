import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackItem{
  String id;
  String name;
  String description;
  String url;
  double rating;


  FeedbackItem({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.rating,

  });

//  FlowerItem.fromMap(Map<String, dynamic> data, {this.documentReference}){
//    name = data['name'];
//    description = data['description'];
//    url = data['url'];
//    price = data['price']
//  }
//
//  FlowerItem.fromSnapshot(DocumentSnapshot snapshot):
//      this.fromMap(snapshot.data, documentReference: snapshot.reference);
//
//  toJson(){
//    return {
//      'name': name,
//      'desdescription': description,
//      'url': url,
//      'price': price
//    };
//  }
}

List<FeedbackItem> feedbackList = [
  FeedbackItem(
      id: 'F1000',
      name: 'Blue Rose',
      description: 'Roses with blue petals',
      url: 'https://cdn.shopify.com/s/files/1/1807/9111/products/Royal-Blue-Everlasting-Rose-Dome.jpg?v=1611101136',
      rating: 1.0

  ),
  FeedbackItem(
      id: 'F1001',
      name: 'Tulips',
      description: 'Bouquet of tulips',
      url: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/close-up-of-tulips-blooming-in-field-royalty-free-image-1584131603.jpg',
      rating: 1.0
  ),
  FeedbackItem(
      id: 'F1002',
      name: 'Arch',
      description: 'Bouquet of tulips',
      url: 'https://media.istockphoto.com/photos/beautiful-flower-arches-with-walkway-picture-id469258214',
      rating: 1.0
  )
];