import 'package:flutter/cupertino.dart';
import 'package:green_app/models/flower_item.dart';


class CartProvider extends ChangeNotifier{
  final List<FlowerItem> _items = [];
  List<FlowerItem> get items => _items;

  //total
  double get total => _items.fold(0.0, (previousValue, item) => previousValue + item.price);

  bool isItemAdded(FlowerItem item){
    return _items.contains(item);
  }

  void addItem(FlowerItem item){
    _items.add(item);
    notifyListeners();
  }

  void removeItem(FlowerItem item){
    _items.remove(item);
    notifyListeners();
  }

}