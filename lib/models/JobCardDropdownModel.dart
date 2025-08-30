class JobCardDropdownModel {
  JobCardDropdownModel({
    List<Departments>? departments,
    List<Sections>? sections,
    List<Lines>? lines,
    List<Units>? units,
    List<Designations>? designations,
    List<Divisions>? divisions,
  }) {
    _departments = departments;
    _sections = sections;
    _lines = lines;
    _units = units;
    _designations = designations;
    _divisions = divisions;
  }

  JobCardDropdownModel.fromJson(dynamic json) {
    if (json['Departments'] != null) {
      _departments = [];
      json['Departments'].forEach((v) {
        _departments?.add(Departments.fromJson(v));
      });
    }
    if (json['Sections'] != null) {
      _sections = [];
      json['Sections'].forEach((v) {
        _sections?.add(Sections.fromJson(v));
      });
    }
    if (json['Lines'] != null) {
      _lines = [];
      json['Lines'].forEach((v) {
        _lines?.add(Lines.fromJson(v));
      });
    }
    if (json['Units'] != null) {
      _units = [];
      json['Units'].forEach((v) {
        _units?.add(Units.fromJson(v));
      });
    }
    if (json['Designations'] != null) {
      _designations = [];
      json['Designations'].forEach((v) {
        _designations?.add(Designations.fromJson(v));
      });
    }
    if (json['Divisions'] != null) {
      _divisions = [];
      json['Divisions'].forEach((v) {
        _divisions?.add(Divisions.fromJson(v));
      });
    }
  }
  List<Departments>? _departments;
  List<Sections>? _sections;
  List<Lines>? _lines;
  List<Units>? _units;
  List<Designations>? _designations;
  List<Divisions>? _divisions;
  JobCardDropdownModel copyWith({
    List<Departments>? departments,
    List<Sections>? sections,
    List<Lines>? lines,
    List<Units>? units,
    List<Designations>? designations,
    List<Divisions>? divisions,
  }) =>
      JobCardDropdownModel(
        departments: departments ?? _departments,
        sections: sections ?? _sections,
        lines: lines ?? _lines,
        units: units ?? _units,
        designations: designations ?? _designations,
        divisions: divisions ?? _divisions,
      );
  List<Departments>? get departments => _departments;
  List<Sections>? get sections => _sections;
  List<Lines>? get lines => _lines;
  List<Units>? get units => _units;
  List<Designations>? get designations => _designations;
  List<Divisions>? get divisions => _divisions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_departments != null) {
      map['Departments'] = _departments?.map((v) => v.toJson()).toList();
    }
    if (_sections != null) {
      map['Sections'] = _sections?.map((v) => v.toJson()).toList();
    }
    if (_lines != null) {
      map['Lines'] = _lines?.map((v) => v.toJson()).toList();
    }
    if (_units != null) {
      map['Units'] = _units?.map((v) => v.toJson()).toList();
    }
    if (_designations != null) {
      map['Designations'] = _designations?.map((v) => v.toJson()).toList();
    }
    if (_divisions != null) {
      map['Divisions'] = _divisions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Divisions {
  Divisions({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Divisions.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Divisions copyWith({
    num? id,
    String? name,
  }) =>
      Divisions(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}

class Designations {
  Designations({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Designations.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Designations copyWith({
    num? id,
    String? name,
  }) =>
      Designations(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}

class Units {
  Units({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Units.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Units copyWith({
    num? id,
    String? name,
  }) =>
      Units(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}

class Lines {
  Lines({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Lines.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Lines copyWith({
    num? id,
    String? name,
  }) =>
      Lines(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}

class Sections {
  Sections({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Sections.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Sections copyWith({
    num? id,
    String? name,
  }) =>
      Sections(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}

class Departments {
  Departments({
    num? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  Departments.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  num? _id;
  String? _name;
  Departments copyWith({
    num? id,
    String? name,
  }) =>
      Departments(
        id: id ?? _id,
        name: name ?? _name,
      );
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }
}
