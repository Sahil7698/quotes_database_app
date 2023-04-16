import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../globals/global.dart';
import '../../helpers/db_helpers.dart';
import '../../models/quotes_model.dart';

class EditPage extends StatefulWidget {
  final List<Background> listBackground;
  final Uint8List img;
  const EditPage({Key? key, required this.listBackground, required this.img})
      : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Future<void> _copyToClicpboard({required String Story}) async {
    await Clipboard.setData(
      ClipboardData(
        text: Story,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied To Clipboard'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  late Future<List<Quotes>> getQuote;
  late Future<List<Fav>> getFav;

  Random random = Random();
  late int i;
  late int font;
  late MemoryImage mImg;

  void imageLoad() {
    mImg = MemoryImage(widget.img);
  }

  void changeBackground() {
    i = random.nextInt(widget.listBackground.length);
  }

  void changeFont() {
    font = random.nextInt(Globals.myFont.length);
  }

  @override
  void initState() {
    super.initState();
    imageLoad();
    changeBackground();
    changeFont();
    getQuote = DBHelper.dbHelper.fetchAllQuotes();
    getFav = DBHelper.dbHelper.fetchAllFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: mImg,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: FutureBuilder(
                    future: getQuote,
                    builder: (context, snapShot) {
                      if (snapShot.hasError) {
                        return Center(
                          child: Text("ERROR : ${snapShot.error}"),
                        );
                      } else if (snapShot.hasData) {
                        List<Quotes>? data = snapShot.data;

                        return (data == null || data.isEmpty)
                            ? const Center(
                                child: Text(
                                  "No Data Available....",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : Text(
                                data[random.nextInt(data.length)].Quotes_Text!,
                                style: TextStyle(
                                  fontFamily: Globals.myFont[font],
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 70,
        width: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.brown.shade200,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                Fav f1 = Fav(
                  Image: mImg,
                  Quotes_Text: "I am Happy For Chosen",
                  Family: Globals.myFont[font],
                );
                int Fav_Id = await DBHelper.dbHelper.insertFavorite(fav: f1);

                if (Fav_Id > 0) {
                  setState(() {
                    getFav = DBHelper.dbHelper.fetchAllFav();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No : $Fav_Id Favourite Inserted successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No : $Fav_Id Record Insertion Failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.favorite_border,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.text_fields,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  changeFont();
                });
              },
              icon: const Icon(
                Icons.text_format_sharp,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  changeBackground();
                  mImg = MemoryImage(widget.listBackground[i].Image!);
                });
              },
              icon: const Icon(
                Icons.image,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  Share.share("Quotes Share Successfully....");
                });
              },
              icon: const Icon(
                Icons.share_rounded,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
