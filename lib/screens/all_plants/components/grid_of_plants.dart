import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class AllPlantsGrid extends StatefulWidget {
  @override
  _AllPlantsGridState createState() => _AllPlantsGridState();
}

class _AllPlantsGridState extends State<AllPlantsGrid> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('AllPlantes');
  List<dynamic> allPlants = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: databaseReference.onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                allPlants.clear();
                print("ok");
                List<dynamic> _values = snapshot.data.snapshot.value;
                print(_values);

                allPlants.addAll(_values);

                print(allPlants);

                return GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: allPlants.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          getProportionateScreenHeight(context, 300),
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing:
                          getProportionateScreenHeight(context, 0),
                      mainAxisSpacing: getProportionateScreenWidth(context, 10),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                //TODO: Vers page de plante
                                                
                                                ));*/
                          },
                          child: Column(
                            children: [
                              Flexible(
                                child: Card(
                                  elevation: 0,
                                  child: GridTile(
                                    child: Container(
                                      height: getProportionateScreenHeight(
                                          context, 200),
                                      width: getProportionateScreenWidth(
                                          context, 600),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Text(
                                          "Loading...",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        imageUrl: allPlants[index]["Photo"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text(
                                      allPlants[index]["Nom"],
                                      style: TextStyle(
                                        fontSize: getProportionateScreenHeight(
                                            context, 14),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return Container();
            }),
      ],
    );
  }
}
