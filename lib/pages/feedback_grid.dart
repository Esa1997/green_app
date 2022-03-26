import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/feedback_item.dart';
import 'package:green_app/pages/add_feedback.dart';
import 'package:green_app/pages/edit_feedback.dart';
import '../components/feeback_card.dart';
import '../services/review_database.dart';
//import 'package:green_app/components/flower_card.dart';
//import 'package:green_app/models/flower_item.dart';
//import 'package:green_app/pages/add_flower_item.dart';


class FeedbackGrid extends StatefulWidget {
 // static const String routeName= '/FlowerGrid';


  @override
  State<FeedbackGrid> createState() => _FeedbackGridState();
}

class _FeedbackGridState extends State<FeedbackGrid> {
  List<FeedbackItem> itemList = [];
  List flowerItemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    final database = FeedbackDatabase();
    List<FeedbackItem>? results = await database.readData();

    if(results == null){
      Fluttertoast.showToast(msg: 'Unable to retrieve data!');
    } else{
      setState(() {
        itemList = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Feedback Gallery'),
        actions: [
        //  IconButton(onPressed: (){Navigator.of(context).pushNamed(Shop.routeName);}, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        //     itemCount: itemList.length,
        //     itemBuilder: (context, index) {
        //       return FeedbackCard(flower: itemList.elementAt(index));
        //     }),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context,index){
                    FeedbackItem item = itemList.elementAt(index);

                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.description),
                        trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.teal,),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFeedbackItem(item: item),
                                )
                            );

                          },
                        ),
                        leading: Image.network(item.url),
                      ),
                    );
                  }),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFeedback(),
              )
          );
        },
        child: const Icon(Icons.add),
      ),

    );

  }
}
