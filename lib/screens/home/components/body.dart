import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:test_app/screens/rooms/create_room.dart';
import 'package:test_app/screens/rooms/join_room.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var images = [
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%201.png?alt=media&token=e7abed07-3e39-4ae3-8553-f3dc9f678d7f",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%202.png?alt=media&token=1b4ade5d-58cf-4af5-8571-54a11b3a2f69",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%203.png?alt=media&token=3e80714d-f355-42f1-85a9-a176896bc98d",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%204.png?alt=media&token=4883f125-b13e-4091-a44c-13f6de3129bc",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%205.png?alt=media&token=e294f8b4-853b-45a4-a93c-6ca94fee4bd1",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%206.png?alt=media&token=faa7e7af-a4a1-4398-831a-2e9f1a9b42fb",
      "https://firebasestorage.googleapis.com/v0/b/gooned-14036.appspot.com/o/iPhone%208%20-%207.png?alt=media&token=23bb3b1b-e6ec-4e17-93b6-a9e60727da49"
    ];
    _howToPlay() {
      var baseDialog = AlertDialog(
        insetPadding: EdgeInsets.all(10),
        contentPadding: EdgeInsets.all(5.0),
        content: Container(
          height: size.height,
          width: size.width,
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return new ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.fill,
                  ));
            },
            loop: false,
            itemCount: images.length,
            control: new SwiperControl(),
            pagination: new SwiperPagination(),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        actions: <Widget>[
          new FlatButton(
            child: Text(
              "Okay",
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) => baseDialog,
          barrierDismissible: true);
    }

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                // Text(
                //   "Welcome to",
                //   style: new TextStyle(
                //       fontSize: 40.0,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black),
                //   textAlign: TextAlign.center,
                // ),
                Text(
                  "Wrekt.",
                  style: new TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ]),
              Column(children: [
                Container(
                    height: size.height * 0.085,
                    width: size.width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 5),
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.43),
                        ),
                      ],
                    ),
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: Text(
                        "Create a Room",
                        style:
                            new TextStyle(fontSize: 28.0, color: Colors.white),
                      ),
                      autofocus: false,
                      clipBehavior: Clip.none,
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRoom(),
                          ),
                        );
                      },
                    )),
                SizedBox(height: size.height * 0.04),
                Container(
                    height: size.height * 0.085,
                    width: size.width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 5),
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.43),
                        ),
                      ],
                    ),
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: Text(
                        "Join a Room",
                        style:
                            new TextStyle(fontSize: 30.0, color: Colors.white),
                      ),
                      autofocus: false,
                      color: Colors.lightBlueAccent,
                      clipBehavior: Clip.none,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinRoom(),
                          ),
                        );
                      },
                    )),
                SizedBox(height: size.height * 0.04),
                Container(
                    height: size.height * 0.07,
                    width: size.height * 0.25,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0)),
                      child: Text(
                        "How to Play",
                        style:
                            new TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                      autofocus: false,
                      clipBehavior: Clip.none,
                      color: Colors.grey,
                      onPressed: () {
                        _howToPlay();
                      },
                    )),
              ])
            ]));
  }
}
