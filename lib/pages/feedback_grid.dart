import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_app/models/feedback_item.dart';
import 'package:green_app/pages/add_feedback.dart';
import 'package:green_app/pages/edit_feedback.dart';
import '../components/feeback_card.dart';
import '../models/flower_item.dart';
import '../services/review_database.dart';


class FeedbackGrid extends StatefulWidget {
  String item_id;
  FeedbackGrid({Key? key, required this.item_id}) : super(key: key);
  @override
  State<FeedbackGrid> createState() => _FeedbackGridState();
}

class _FeedbackGridState extends State<FeedbackGrid> {
  List<FeedbackItem> itemList = [];
  List feedItemList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    final database = FeedbackDatabase();
    List<FeedbackItem>? results = await database.readData(widget.item_id);

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
                        title: Text(item.description),
                        subtitle: Text("Rating :"+ item.rating.toString()),


                        trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.teal,),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFeedbackItem(item: item, item_id: widget.item_id),
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
                builder: (context) => AddFeedback(item_id: widget.item_id),
              )
          );
        },
        child: const Icon(Icons.add),
      ),

    );

  }
}
