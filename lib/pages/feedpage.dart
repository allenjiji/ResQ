import 'package:flutter/material.dart';
import '../custom_widgets.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(

      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_box,color: Colors.red,size: h/20,),
            title: Text(
              "Want to Post something important?\nപോസ്റ്റ് ചെയ്യുക",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.arrow_forward_ios,color:Colors.red),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return FeedBox(
                  genre: "request",
                  feedId: 45,
                  isVoted: true,
                  votes: 5,
                  description:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  imgLink:
                      'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg',
                  name: "Anandhan",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
