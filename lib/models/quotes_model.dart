import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Quotes {
  String? Quotes_Text;

  Quotes({
    this.Quotes_Text,
  });

  factory Quotes.fromMap({required Map<String, dynamic> data}) {
    return Quotes(
      Quotes_Text: data['Quotes'],
    );
  }
}

class Fav {
  late String Quotes_Text;
  late String Family;
  late MemoryImage Image;

  Fav({
    required this.Image,
    required this.Quotes_Text,
    required this.Family,
  });

  //Row data to Custom object (Map => Fav)
  factory Fav.fromMap({required Map<String, dynamic> data}) {
    return Fav(
      Image: data['Image'],
      Quotes_Text: data['Quote'],
      Family: data['Family'],
    );
  }
}

class Background {
  Uint8List? Image;

  Background({
    this.Image,
  });

  //Row data to Custom object (Map => Background)
  factory Background.fromMap({required Map<String, dynamic> data}) {
    return Background(
      Image: data['Image'],
    );
  }
}
