import 'package:cloud_firestore/cloud_firestore.dart';

class FlowerItem{
  String id;
  String name;
  String description;
  String url;
  double price;

  FlowerItem({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.price
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

List<FlowerItem> flowerList = [
  FlowerItem(
      id: 'F1000',
      name: 'Blue Rose',
      description: 'Roses with blue petals',
      url: 'https://cdn.shopify.com/s/files/1/1807/9111/products/Royal-Blue-Everlasting-Rose-Dome.jpg?v=1611101136',
      price: 1000.00
  ),
  FlowerItem(
      id: 'F1001',
      name: 'Tulips',
      description: 'Bouquet of tulips',
      url: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/close-up-of-tulips-blooming-in-field-royalty-free-image-1584131603.jpg',
      price: 1000.00
  ),
  FlowerItem(
      id: 'F1002',
      name: 'Arch',
      description: 'Bouquet of tulips',
      url: 'https://media.istockphoto.com/photos/beautiful-flower-arches-with-walkway-picture-id469258214',
      price: 1000.00
  )
];