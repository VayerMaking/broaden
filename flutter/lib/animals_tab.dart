import 'package:flutter/material.dart';

var names = [
  "Скален орел",
  "Червен ангъч",
  "Ловен соколо",
  "Ливаден дървадец",
  "Белогръб кълвач",
  "Египетски лешояд",
  "Гълъб хралупар",
  "Белошипа ветрушка",
  "Сокол орко",
  "Малък креслив орел",
  "Черен щъркел",
  "Осояд",
  "Голям ястреб",
  "Орел змияр",
  "Черен кълвач",
];
var names_latino = [
  "(Aquila chrysaetos)",
  "(Tadorna)",
  "(Falco cherrug)",
  "(Crex crex)",
  "(Dendrocopos leucotos)",
  "(Dendrocopos leucotos)",
  "(Neophron percnopterus)",
  "(Columba oenas)",
  "(Falco naumanni)",
  "(Falco subbuteo)",
  "(Clanga pomarina)",
  "(Ciconia nigra)",
  "(Pernis apivorus)",
  "(Accipiter gentilis)",
  "(Circaetus gallicus)",
  "(Dryocopus martius)",
];
var names_v = [
  "Алпийски тритон",
  "Сирийска чесновица",
  "Вдълбнаточел смок",
  "Смок мишкар",
  "Змиегущер",
  "Леопардов смок",
  "Шипоопашата кост.",
  "Шипобедрена кост.",
];
var names_v_latino = [
  "(Ichthyosaura alpestris)",
  "(Pelobates syriacus)",
  "(Malpolon monspessulanus)",
  "(Zamenis longissimus)",
  "(Pseudopus apodus)",
  "(Zamenis situla)",
  "(Testudo hermanni)",
  "(Testudo graeca)",
];

Widget _buildAnimal(index, type, list, list_lat) {
  return Padding(
    //padding: const EdgeInsets.all(8.0),
    padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
    child: Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(blurRadius: 2.0, color: Colors.black),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "http://192.168.88.244:5000/app_image/$type$index.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      Text(
                        list[index],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        list_lat[index],
                        style: TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
            padding: const EdgeInsets.fromLTRB(15, 16, 8, 16),
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
                          fontSize: 25),
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
                          fontSize: 25),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return _buildAnimal(index, "pt", names, names_latino);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                    child: Text(
                      "Земноводни и влечуги",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'SFNSText',
                          //fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return _buildAnimal(index, "v", names_v, names_v_latino);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
