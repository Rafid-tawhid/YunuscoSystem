// models/dhu_model.dart
class DHUResponse {
  final Data data;

  DHUResponse({required this.data});

  factory DHUResponse.fromJson(Map<String, dynamic> json) {
    return DHUResponse(
      data: Data.fromJson(json['Data']),
    );
  }
}

class Data {
  final List<SectionDHU> sectionWiseDHU;
  final List<LineDHU> lineWiseDHU;
  final TotalDHU totalDHU;

  Data({
    required this.sectionWiseDHU,
    required this.lineWiseDHU,
    required this.totalDHU,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      sectionWiseDHU: (json['SectionWiseDHU'] as List)
          .map((item) => SectionDHU.fromJson(item))
          .toList(),
      lineWiseDHU: (json['LineWiseDHU'] as List)
          .map((item) => LineDHU.fromJson(item))
          .toList(),
      totalDHU: TotalDHU.fromJson(json['TotalDHU']),
    );
  }
}

class SectionDHU {
  final String sectionName;
  final double sectionDHU;

  SectionDHU({
    required this.sectionName,
    required this.sectionDHU,
  });

  factory SectionDHU.fromJson(Map<String, dynamic> json) {
    return SectionDHU(
      sectionName: json['SectionName'],
      sectionDHU: (json['SectionDHU'] as num).toDouble(),
    );
  }
}

class LineDHU {
  final String lineName;
  final double lineDHU;

  LineDHU({
    required this.lineName,
    required this.lineDHU,
  });

  factory LineDHU.fromJson(Map<String, dynamic> json) {
    return LineDHU(
      lineName: json['LineName'],
      lineDHU: (json['LineDHU'] as num).toDouble(),
    );
  }
}

class TotalDHU {
  final double totalDHU;

  TotalDHU({required this.totalDHU});

  factory TotalDHU.fromJson(Map<String, dynamic> json) {
    return TotalDHU(
      totalDHU: (json['TotalDHU'] as num).toDouble(),
    );
  }
}