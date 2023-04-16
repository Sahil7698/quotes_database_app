import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/db_helpers.dart';
import '../../models/quotes_model.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Background>> getBackground;

  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final TextEditingController quotesController = TextEditingController();

  int index = 0;
  String? quote;
  Uint8List? imageBytes;
  Random random = Random();

  getFromGallery() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    imageBytes = await xFile!.readAsBytes();
  }

  @override
  void initState() {
    super.initState();
    getBackground = DBHelper.dbHelper.fetchAllBg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Quotes App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Quotes\nCategory",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.pexels.com/photos/2583852/pexels-photo-2583852.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1584810359583-96fc3448beaa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("Recent View",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 200,
              width: double.infinity,
              child: FutureBuilder(
                future: getBackground,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Center(
                      child: Text("ERROR : ${snapShot.error}"),
                    );
                  } else if (snapShot.hasData) {
                    List<Background>? data = snapShot.data;

                    return (data == null || data.isEmpty)
                        ? const Center(
                            child: Text(
                              "No Data Available...",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 8,
                            children: List.generate(
                              data.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        listBackground: data,
                                        img: data[index].Image!,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100,
                                    image: DecorationImage(
                                      image: MemoryImage(data[index].Image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              insertQuotes();
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.brown.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.brown,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              insertImages();
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.brown.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.brown.shade100,
    );
  }

  void insertQuotes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Insert Quote"),
          ),
          content: Form(
            key: insertFormKey,
            child: TextFormField(
              controller: quotesController,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Enter Quotes first.....";
                }
                return null;
              },
              onSaved: (val) {
                quote = val;
              },
              decoration: InputDecoration(
                labelText: "Quote",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                quotesController.clear();
                setState(() {
                  quote = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () async {
                if (insertFormKey.currentState!.validate()) {
                  insertFormKey.currentState!.save();

                  Quotes q1 = Quotes(Quotes_Text: quote!);

                  int id_Q = await DBHelper.dbHelper.insertText(quotes: q1);

                  if (id_Q > 0) {
                    setState(() {
                      getBackground = DBHelper.dbHelper.fetchAllBg();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(" No : $id_Q Quote Inserted successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Record Insertion failed..."),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }

                quotesController.clear();

                setState(() {
                  quote = null;
                });

                Navigator.pop(context);
              },
              child: const Text("Insert"),
            ),
          ],
        );
      },
    );
  }

  void insertImages() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Insert Background"),
          ),
          content: Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                getFromGallery();
              },
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.brown.shade100,
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  imageBytes = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () async {
                Background b1 = Background(Image: imageBytes!);

                int id_B =
                    await DBHelper.dbHelper.insertBackground(background: b1);

                if (id_B > 0) {
                  setState(() {
                    getBackground = DBHelper.dbHelper.fetchAllBg();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No : $id_B Background Inserted successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Record Insertion failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                quotesController.clear();

                setState(() {
                  quote = null;
                  imageBytes = null;
                });

                Navigator.pop(context);
              },
              child: const Text("Insert"),
            ),
          ],
        );
      },
    );
  }

  Widget myQuotes({required String image, required String name}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
