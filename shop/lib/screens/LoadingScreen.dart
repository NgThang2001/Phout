import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 10, // Số lượng mục trong danh sách
          itemBuilder: (context, index) {
            if(index == 0){
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 200,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 30,
                        width: double.infinity,
                      ),
                      SizedBox(height: 10,),

                    ],
                  )
              );
            }
            return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width/2 - 15,
                    ),
                    SizedBox(width: 10, height: 160,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width/2 - 15,
                    )
                  ],
                )
            );
          },
        ),
      ),
    );
  }
}
