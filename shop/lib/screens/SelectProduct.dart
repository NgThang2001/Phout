import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../API.dart';

class SelectProdct extends StatelessWidget {
  @override
  Future<List> getData() async {
    Data data = Get.put(Data());
    List<dynamic> result = await data.getDATA();
    return result;
  }
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          elevation: 0.1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Row(
            children: [
              SizedBox(width: 30,),
              Expanded(
                child: Text(
                  'Danh mục',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black,size: 20,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          automaticallyImplyLeading: false, // Ẩn nút back trên Appbar
        ),
        FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    int newID = index*3;
                    if(newID>snapshot.data!.length/2){
                      return null;
                    }
                    String top = snapshot.data![newID]['name_product'];
                    String bot = snapshot.data![newID+1]['name_product'];
                    return Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 80,
                              // height: 80,
                              child: TextButton(
                                onPressed: () {  },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/mon1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    Text(top),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Container(
                              width: 80,
                              // height: 80,
                              child: TextButton(
                                onPressed: () {  },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/mon1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    Text(bot),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );

                  },
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }

}