import 'package:flutter/material.dart';

Widget _buildAnimal(index) {
  return Padding(
    //padding: const EdgeInsets.all(8.0),
    padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
    child: Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/p-01.jpg',
                    // width: 600.0,
                    // height: 240.0,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 70, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "Черен Щъркел",
                        style: TextStyle(
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    ),
  );
}

class Animals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            //padding: EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: SafeArea(
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      "Защитени видове",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                    child: Text(
                      "Птици",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SFNSText',
                          //fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return _buildAnimal(index);
                    },
                  ),

                  //_buildAnimal(0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
