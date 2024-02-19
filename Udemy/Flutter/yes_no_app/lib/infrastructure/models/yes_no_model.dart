import 'dart:convert';

import 'package:yes_no_app/domain/entities/message.dart';

// No se necesita, ua que dio ya hizo este paso.
//YesNoModel yesNoModelFromJson(String str) => YesNoModel.fromJson(json.decode(str));

// No se necesita. Teniendo la instancia del modelo crea un string, lo cual se usa para madnar peticiones HTTP.
//String yesNoModelToJson(YesNoModel data) => json.encode(data.toJson());

class YesNoModel {
  final String answer;
  final bool forced;
  final String image;

  YesNoModel({
    required this.answer,
    required this.forced,
    required this.image,
  });

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
        answer: json["answer"],
        forced: json["forced"],
        image: json["image"],
      );

// Es el proceso opuesto, en donde se genera el mapa a partir de la instancia.
// No se ocupa en la app.
  Map<String, dynamic> toJson() => {
        "answer": answer,
        "forced": forced,
        "image": image,
      };

  // Mapper
  Message toMessageEntity() => Message(
        text: answer == 'yes' ? 'Si' : 'No',
        fromWho: FromWho.hers,
        imageUrl: image,
      );
}
