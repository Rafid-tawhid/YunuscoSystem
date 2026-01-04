class AppVersion {
  AppVersion({
      num? id, 
      String? link, 
      String? version, 
      String? newVersion, 
      String? appName, 
      String? appId, 
      String? minimumOSVersion, 
      String? newFeatures, 
      String? description, 
      String? releaseDate, 
      String? buildNumber, 
      bool? isAvailable, 
      bool? isMandatory, 
      String? createdDate, 
      String? updatedDate,}){
    _id = id;
    _link = link;
    _version = version;
    _newVersion = newVersion;
    _appName = appName;
    _appId = appId;
    _minimumOSVersion = minimumOSVersion;
    _newFeatures = newFeatures;
    _description = description;
    _releaseDate = releaseDate;
    _buildNumber = buildNumber;
    _isAvailable = isAvailable;
    _isMandatory = isMandatory;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
}

  AppVersion.fromJson(dynamic json) {
    _id = json['Id'];
    _link = json['Link'];
    _version = json['Version'];
    _newVersion = json['NewVersion'];
    _appName = json['AppName'];
    _appId = json['AppId'];
    _minimumOSVersion = json['MinimumOSVersion'];
    _newFeatures = json['NewFeatures'];
    _description = json['Description'];
    _releaseDate = json['ReleaseDate'];
    _buildNumber = json['BuildNumber'];
    _isAvailable = json['IsAvailable'];
    _isMandatory = json['IsMandatory'];
    _createdDate = json['CreatedDate'];
    _updatedDate = json['UpdatedDate'];
  }
  num? _id;
  String? _link;
  String? _version;
  String? _newVersion;
  String? _appName;
  String? _appId;
  String? _minimumOSVersion;
  String? _newFeatures;
  String? _description;
  String? _releaseDate;
  String? _buildNumber;
  bool? _isAvailable;
  bool? _isMandatory;
  String? _createdDate;
  String? _updatedDate;
AppVersion copyWith({  num? id,
  String? link,
  String? version,
  String? newVersion,
  String? appName,
  String? appId,
  String? minimumOSVersion,
  String? newFeatures,
  String? description,
  String? releaseDate,
  String? buildNumber,
  bool? isAvailable,
  bool? isMandatory,
  String? createdDate,
  String? updatedDate,
}) => AppVersion(  id: id ?? _id,
  link: link ?? _link,
  version: version ?? _version,
  newVersion: newVersion ?? _newVersion,
  appName: appName ?? _appName,
  appId: appId ?? _appId,
  minimumOSVersion: minimumOSVersion ?? _minimumOSVersion,
  newFeatures: newFeatures ?? _newFeatures,
  description: description ?? _description,
  releaseDate: releaseDate ?? _releaseDate,
  buildNumber: buildNumber ?? _buildNumber,
  isAvailable: isAvailable ?? _isAvailable,
  isMandatory: isMandatory ?? _isMandatory,
  createdDate: createdDate ?? _createdDate,
  updatedDate: updatedDate ?? _updatedDate,
);
  num? get id => _id;
  String? get link => _link;
  String? get version => _version;
  String? get newVersion => _newVersion;
  String? get appName => _appName;
  String? get appId => _appId;
  String? get minimumOSVersion => _minimumOSVersion;
  String? get newFeatures => _newFeatures;
  String? get description => _description;
  String? get releaseDate => _releaseDate;
  String? get buildNumber => _buildNumber;
  bool? get isAvailable => _isAvailable;
  bool? get isMandatory => _isMandatory;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Link'] = _link;
    map['Version'] = _version;
    map['NewVersion'] = _newVersion;
    map['AppName'] = _appName;
    map['AppId'] = _appId;
    map['MinimumOSVersion'] = _minimumOSVersion;
    map['NewFeatures'] = _newFeatures;
    map['Description'] = _description;
    map['ReleaseDate'] = _releaseDate;
    map['BuildNumber'] = _buildNumber;
    map['IsAvailable'] = _isAvailable;
    map['IsMandatory'] = _isMandatory;
    map['CreatedDate'] = _createdDate;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }

}