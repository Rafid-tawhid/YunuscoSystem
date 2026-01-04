class MisAssetModel {
  MisAssetModel({
    num? misAssetId,
    String? assetNo,
    String? assetDetailID,
    String? assetType,
    String? hostName,
    String? ipAddress,
    String? ipAddress2,
    String? iaGroup,
    String? status,
    String? employeeName,
    String? department,
    String? section,
    String? location,
    String? userName,
    String? designation,
    String? adName,
    String? unit,
    String? serialNoOrMac,
    String? manufacturer,
    String? model,
    String? mBoard,
    String? processor,
    String? processorGeneration,
    num? purchasePrice,
    String? officeLicense,
    String? removedSoftware,
    String? speed,
    String? hdd,
    String? ram,
    String? dateOfPurchase,
    String? supplier,
    String? warranty,
    String? installedOs,
    String? licenseOs,
    String? serialNoOfOs,
    String? antivirusLicense,
    String? installedSoftware,
    dynamic transferDate,
    String? remarks,
    String? businessUnitName,
    String? employeeIdcardNo,
    String? frontPhotoPath,
    String? backPhotoPath,
    String? keyPhotoPath,
    String? screenPhotoPath,
  }) {
    _misAssetId = misAssetId;
    _assetNo = assetNo;
    _assetDetailID = assetDetailID;
    _assetType = assetType;
    _hostName = hostName;
    _ipAddress = ipAddress;
    _ipAddress2 = ipAddress2;
    _iaGroup = iaGroup;
    _status = status;
    _employeeName = employeeName;
    _department = department;
    _section = section;
    _location = location;
    _userName = userName;
    _designation = designation;
    _adName = adName;
    _unit = unit;
    _serialNoOrMac = serialNoOrMac;
    _manufacturer = manufacturer;
    _model = model;
    _mBoard = mBoard;
    _processor = processor;
    _processorGeneration = processorGeneration;
    _purchasePrice = purchasePrice;
    _officeLicense = officeLicense;
    _removedSoftware = removedSoftware;
    _speed = speed;
    _hdd = hdd;
    _ram = ram;
    _dateOfPurchase = dateOfPurchase;
    _supplier = supplier;
    _warranty = warranty;
    _installedOs = installedOs;
    _licenseOs = licenseOs;
    _serialNoOfOs = serialNoOfOs;
    _antivirusLicense = antivirusLicense;
    _installedSoftware = installedSoftware;
    _transferDate = transferDate;
    _remarks = remarks;
    _businessUnitName = businessUnitName;
    _employeeIdcardNo = employeeIdcardNo;
    _frontPhotoPath = frontPhotoPath;
    _backPhotoPath = backPhotoPath;
    _keyPhotoPath = keyPhotoPath;
    _screenPhotoPath = screenPhotoPath;
  }

  MisAssetModel.fromJson(dynamic json) {
    _misAssetId = json['MisAssetId'];
    _assetNo = json['AssetNo'].toString();
    _assetDetailID = json['AssetDetailID'].toString();
    _assetType = json['AssetType'].toString();
    _hostName = json['HostName'].toString();
    _ipAddress = json['IpAddress'].toString();
    _ipAddress2 = json['IpAddress2'].toString();
    _iaGroup = json['IaGroup'].toString();
    _status = json['Status'].toString();
    _employeeName = json['EmployeeName'].toString();
    _department = json['Department'].toString();
    _section = json['Section'].toString();
    _location = json['Location'].toString();
    _userName = json['UserName'].toString();
    _designation = json['Designation'].toString();
    _adName = json['AdName'].toString();
    _unit = json['Unit'].toString();
    _serialNoOrMac = json['SerialNoOrMac'].toString();
    _manufacturer = json['Manufacturer'].toString();
    _model = json['Model'].toString();
    _mBoard = json['MBoard'].toString();
    _processor = json['Processor'].toString();
    _processorGeneration = json['ProcessorGeneration'].toString();
    _purchasePrice = json['PurchasePrice'];
    _officeLicense = json['OfficeLicense'].toString();
    _removedSoftware = json['RemovedSoftware'].toString();
    _speed = json['Speed'].toString();
    _hdd = json['HDD'].toString();
    _ram = json['RAM'].toString();
    _dateOfPurchase = json['DateOfPurchase'].toString();
    _supplier = json['Supplier'].toString();
    _warranty = json['Warranty'].toString();
    _installedOs = json['InstalledOs'].toString();
    _licenseOs = json['LicenseOs'].toString();
    _serialNoOfOs = json['SerialNoOfOs'].toString();
    _antivirusLicense = json['AntivirusLicense'].toString();
    _installedSoftware = json['InstalledSoftware'].toString();
    _transferDate = json['TransferDate'].toString();
    _remarks = json['Remarks'].toString();
    _businessUnitName = json['BusinessUnitName'].toString();
    _employeeIdcardNo = json['EmployeeIdcardNo'].toString();
    _frontPhotoPath = json['FrontPhotoPath'].toString();
    _backPhotoPath = json['BackPhotoPath'].toString();
    _keyPhotoPath = json['KeyPhotoPath'].toString();
    _screenPhotoPath = json['ScreenPhotoPath'].toString();
  }
  num? _misAssetId;
  String? _assetNo;
  String? _assetDetailID;
  String? _assetType;
  String? _hostName;
  String? _ipAddress;
  String? _ipAddress2;
  String? _iaGroup;
  String? _status;
  String? _employeeName;
  String? _department;
  String? _section;
  String? _location;
  String? _userName;
  String? _designation;
  String? _adName;
  String? _unit;
  String? _serialNoOrMac;
  String? _manufacturer;
  String? _model;
  String? _mBoard;
  String? _processor;
  String? _processorGeneration;
  num? _purchasePrice;
  String? _officeLicense;
  String? _removedSoftware;
  String? _speed;
  String? _hdd;
  String? _ram;
  String? _dateOfPurchase;
  String? _supplier;
  String? _warranty;
  String? _installedOs;
  String? _licenseOs;
  String? _serialNoOfOs;
  String? _antivirusLicense;
  String? _installedSoftware;
  dynamic _transferDate;
  String? _remarks;
  String? _businessUnitName;
  String? _employeeIdcardNo;
  String? _frontPhotoPath;
  String? _backPhotoPath;
  String? _keyPhotoPath;
  String? _screenPhotoPath;

  MisAssetModel copyWith({
    num? misAssetId,
    String? assetNo,
    String? assetType,
    String? assetDetailID,
    String? hostName,
    String? ipAddress,
    String? ipAddress2,
    String? iaGroup,
    String? status,
    String? employeeName,
    String? department,
    String? section,
    String? location,
    String? userName,
    String? designation,
    String? adName,
    String? unit,
    String? serialNoOrMac,
    String? manufacturer,
    String? model,
    String? mBoard,
    String? processor,
    String? processorGeneration,
    num? purchasePrice,
    String? officeLicense,
    String? removedSoftware,
    String? speed,
    String? hdd,
    String? ram,
    String? dateOfPurchase,
    String? supplier,
    String? warranty,
    String? installedOs,
    String? licenseOs,
    String? serialNoOfOs,
    String? antivirusLicense,
    String? installedSoftware,
    dynamic transferDate,
    String? remarks,
    String? businessUnitName,
    String? employeeIdcardNo,
    String? frontPhotoPath,
    String? backPhotoPath,
    String? keyPhotoPath,
    String? screenPhotoPath,
  }) =>
      MisAssetModel(
        misAssetId: misAssetId ?? _misAssetId,
        assetNo: assetNo ?? _assetNo,
        assetDetailID: assetDetailID ?? _assetDetailID,
        assetType: assetType ?? _assetType,
        hostName: hostName ?? _hostName,
        ipAddress: ipAddress ?? _ipAddress,
        ipAddress2: ipAddress2 ?? _ipAddress2,
        iaGroup: iaGroup ?? _iaGroup,
        status: status ?? _status,
        employeeName: employeeName ?? _employeeName,
        department: department ?? _department,
        section: section ?? _section,
        location: location ?? _location,
        userName: userName ?? _userName,
        designation: designation ?? _designation,
        adName: adName ?? _adName,
        unit: unit ?? _unit,
        serialNoOrMac: serialNoOrMac ?? _serialNoOrMac,
        manufacturer: manufacturer ?? _manufacturer,
        model: model ?? _model,
        mBoard: mBoard ?? _mBoard,
        processor: processor ?? _processor,
        processorGeneration: processorGeneration ?? _processorGeneration,
        purchasePrice: purchasePrice ?? _purchasePrice,
        officeLicense: officeLicense ?? _officeLicense,
        removedSoftware: removedSoftware ?? _removedSoftware,
        speed: speed ?? _speed,
        hdd: hdd ?? _hdd,
        ram: ram ?? _ram,
        dateOfPurchase: dateOfPurchase ?? _dateOfPurchase,
        supplier: supplier ?? _supplier,
        warranty: warranty ?? _warranty,
        installedOs: installedOs ?? _installedOs,
        licenseOs: licenseOs ?? _licenseOs,
        serialNoOfOs: serialNoOfOs ?? _serialNoOfOs,
        antivirusLicense: antivirusLicense ?? _antivirusLicense,
        installedSoftware: installedSoftware ?? _installedSoftware,
        transferDate: transferDate ?? _transferDate,
        remarks: remarks ?? _remarks,
        businessUnitName: businessUnitName ?? _businessUnitName,
        employeeIdcardNo: employeeIdcardNo ?? _employeeIdcardNo,
        frontPhotoPath: frontPhotoPath ?? _frontPhotoPath,
        backPhotoPath: backPhotoPath ?? _backPhotoPath,
        keyPhotoPath: keyPhotoPath ?? _keyPhotoPath,
        screenPhotoPath: screenPhotoPath ?? _screenPhotoPath,
      );
  num? get misAssetId => _misAssetId;
  String? get assetNo => _assetNo;
  String? get assetDetailID => _assetDetailID;
  String? get assetType => _assetType;
  String? get hostName => _hostName;
  String? get ipAddress => _ipAddress;
  String? get ipAddress2 => _ipAddress2;
  String? get iaGroup => _iaGroup;
  String? get status => _status;
  String? get employeeName => _employeeName;
  String? get department => _department;
  String? get section => _section;
  String? get location => _location;
  String? get userName => _userName;
  String? get designation => _designation;
  String? get adName => _adName;
  String? get unit => _unit;
  String? get serialNoOrMac => _serialNoOrMac;
  String? get manufacturer => _manufacturer;
  String? get model => _model;
  String? get mBoard => _mBoard;
  String? get processor => _processor;
  String? get processorGeneration => _processorGeneration;
  num? get purchasePrice => _purchasePrice;
  String? get officeLicense => _officeLicense;
  String? get removedSoftware => _removedSoftware;
  String? get speed => _speed;
  String? get hdd => _hdd;
  String? get ram => _ram;
  String? get dateOfPurchase => _dateOfPurchase;
  String? get supplier => _supplier;
  String? get warranty => _warranty;
  String? get installedOs => _installedOs;
  String? get licenseOs => _licenseOs;
  String? get serialNoOfOs => _serialNoOfOs;
  String? get antivirusLicense => _antivirusLicense;
  String? get installedSoftware => _installedSoftware;
  dynamic get transferDate => _transferDate;
  String? get remarks => _remarks;
  String? get businessUnitName => _businessUnitName;
  String? get employeeIdcardNo => _employeeIdcardNo;
  String? get frontPhotoPath => _frontPhotoPath;
  String? get backPhotoPath => _backPhotoPath;
  String? get keyPhotoPath => _keyPhotoPath;
  String? get screenPhotoPath => _screenPhotoPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MisAssetId'] = _misAssetId;
    map['AssetNo'] = _assetNo;
    map['AssetDetailID'] = _assetDetailID;
    map['AssetType'] = _assetType;
    map['HostName'] = _hostName;
    map['IpAddress'] = _ipAddress;
    map['IpAddress2'] = _ipAddress2;
    map['IaGroup'] = _iaGroup;
    map['Status'] = _status;
    map['EmployeeName'] = _employeeName;
    map['Department'] = _department;
    map['Section'] = _section;
    map['Location'] = _location;
    map['UserName'] = _userName;
    map['Designation'] = _designation;
    map['AdName'] = _adName;
    map['Unit'] = _unit;
    map['SerialNoOrMac'] = _serialNoOrMac;
    map['Manufacturer'] = _manufacturer;
    map['Model'] = _model;
    map['MBoard'] = _mBoard;
    map['Processor'] = _processor;
    map['ProcessorGeneration'] = _processorGeneration;
    map['PurchasePrice'] = _purchasePrice;
    map['OfficeLicense'] = _officeLicense;
    map['RemovedSoftware'] = _removedSoftware;
    map['Speed'] = _speed;
    map['HDD'] = _hdd;
    map['RAM'] = _ram;
    map['DateOfPurchase'] = _dateOfPurchase;
    map['Supplier'] = _supplier;
    map['Warranty'] = _warranty;
    map['InstalledOs'] = _installedOs;
    map['LicenseOs'] = _licenseOs;
    map['SerialNoOfOs'] = _serialNoOfOs;
    map['AntivirusLicense'] = _antivirusLicense;
    map['InstalledSoftware'] = _installedSoftware;
    map['TransferDate'] = _transferDate;
    map['Remarks'] = _remarks;
    map['BusinessUnitName'] = _businessUnitName;
    map['EmployeeIdcardNo'] = _employeeIdcardNo;
    map['FrontPhotoPath'] = _frontPhotoPath;
    map['BackPhotoPath'] = _backPhotoPath;
    map['KeyPhotoPath'] = _keyPhotoPath;
    map['ScreenPhotoPath'] = _screenPhotoPath;

    return map;
  }
}
