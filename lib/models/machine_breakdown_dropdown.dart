class MachineBreakdownDropdown {
  MachineBreakdownDropdown({
      List<Tasks>? tasks, 
      List<Operations>? operations, 
      List<ProductionLines>? productionLines, 
      List<Employees>? employees,}){
    _tasks = tasks;
    _operations = operations;
    _productionLines = productionLines;
    _employees = employees;
}

  MachineBreakdownDropdown.fromJson(dynamic json) {
    if (json['Tasks'] != null) {
      _tasks = [];
      json['Tasks'].forEach((v) {
        _tasks?.add(Tasks.fromJson(v));
      });
    }
    if (json['Operations'] != null) {
      _operations = [];
      json['Operations'].forEach((v) {
        _operations?.add(Operations.fromJson(v));
      });
    }
    if (json['ProductionLines'] != null) {
      _productionLines = [];
      json['ProductionLines'].forEach((v) {
        _productionLines?.add(ProductionLines.fromJson(v));
      });
    }
    if (json['Employees'] != null) {
      _employees = [];
      json['Employees'].forEach((v) {
        _employees?.add(Employees.fromJson(v));
      });
    }
  }
  List<Tasks>? _tasks;
  List<Operations>? _operations;
  List<ProductionLines>? _productionLines;
  List<Employees>? _employees;
MachineBreakdownDropdown copyWith({  List<Tasks>? tasks,
  List<Operations>? operations,
  List<ProductionLines>? productionLines,
  List<Employees>? employees,
}) => MachineBreakdownDropdown(  tasks: tasks ?? _tasks,
  operations: operations ?? _operations,
  productionLines: productionLines ?? _productionLines,
  employees: employees ?? _employees,
);
  List<Tasks>? get tasks => _tasks;
  List<Operations>? get operations => _operations;
  List<ProductionLines>? get productionLines => _productionLines;
  List<Employees>? get employees => _employees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_tasks != null) {
      map['Tasks'] = _tasks?.map((v) => v.toJson()).toList();
    }
    if (_operations != null) {
      map['Operations'] = _operations?.map((v) => v.toJson()).toList();
    }
    if (_productionLines != null) {
      map['ProductionLines'] = _productionLines?.map((v) => v.toJson()).toList();
    }
    if (_employees != null) {
      map['Employees'] = _employees?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Employees {
  Employees({
      num? employeeId, 
      String? employeeCode, 
      String? employeeName,}){
    _employeeId = employeeId;
    _employeeCode = employeeCode;
    _employeeName = employeeName;
}

  Employees.fromJson(dynamic json) {
    _employeeId = json['EmployeeId'];
    _employeeCode = json['EmployeeCode'];
    _employeeName = json['EmployeeName'];
  }
  num? _employeeId;
  String? _employeeCode;
  String? _employeeName;
Employees copyWith({  num? employeeId,
  String? employeeCode,
  String? employeeName,
}) => Employees(  employeeId: employeeId ?? _employeeId,
  employeeCode: employeeCode ?? _employeeCode,
  employeeName: employeeName ?? _employeeName,
);
  num? get employeeId => _employeeId;
  String? get employeeCode => _employeeCode;
  String? get employeeName => _employeeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['EmployeeId'] = _employeeId;
    map['EmployeeCode'] = _employeeCode;
    map['EmployeeName'] = _employeeName;
    return map;
  }

}

class ProductionLines {
  ProductionLines({
      num? lineId, 
      String? shortName, 
      String? name, 
      num? businessUnitId, 
      num? productionUnitId,}){
    _lineId = lineId;
    _shortName = shortName;
    _name = name;
    _businessUnitId = businessUnitId;
    _productionUnitId = productionUnitId;
}

  ProductionLines.fromJson(dynamic json) {
    _lineId = json['LineId'];
    _shortName = json['ShortName'];
    _name = json['Name'];
    _businessUnitId = json['BusinessUnitId'];
    _productionUnitId = json['ProductionUnitId'];
  }
  num? _lineId;
  String? _shortName;
  String? _name;
  num? _businessUnitId;
  num? _productionUnitId;
ProductionLines copyWith({  num? lineId,
  String? shortName,
  String? name,
  num? businessUnitId,
  num? productionUnitId,
}) => ProductionLines(  lineId: lineId ?? _lineId,
  shortName: shortName ?? _shortName,
  name: name ?? _name,
  businessUnitId: businessUnitId ?? _businessUnitId,
  productionUnitId: productionUnitId ?? _productionUnitId,
);
  num? get lineId => _lineId;
  String? get shortName => _shortName;
  String? get name => _name;
  num? get businessUnitId => _businessUnitId;
  num? get productionUnitId => _productionUnitId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LineId'] = _lineId;
    map['ShortName'] = _shortName;
    map['Name'] = _name;
    map['BusinessUnitId'] = _businessUnitId;
    map['ProductionUnitId'] = _productionUnitId;
    return map;
  }

}

class Operations {
  Operations({
      num? operationId, 
      String? operationName, 
      String? workTimeType,}){
    _operationId = operationId;
    _operationName = operationName;
    _workTimeType = workTimeType;
}

  Operations.fromJson(dynamic json) {
    _operationId = json['OperationId'];
    _operationName = json['OperationName'];
    _workTimeType = json['WorkTimeType'];
  }
  num? _operationId;
  String? _operationName;
  String? _workTimeType;
Operations copyWith({  num? operationId,
  String? operationName,
  String? workTimeType,
}) => Operations(  operationId: operationId ?? _operationId,
  operationName: operationName ?? _operationName,
  workTimeType: workTimeType ?? _workTimeType,
);
  num? get operationId => _operationId;
  String? get operationName => _operationName;
  String? get workTimeType => _workTimeType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['OperationId'] = _operationId;
    map['OperationName'] = _operationName;
    map['WorkTimeType'] = _workTimeType;
    return map;
  }

}

class Tasks {
  Tasks({
      num? taskId, 
      String? taskName, 
      String? taskCode,}){
    _taskId = taskId;
    _taskName = taskName;
    _taskCode = taskCode;
}

  Tasks.fromJson(dynamic json) {
    _taskId = json['TaskId'];
    _taskName = json['TaskName'];
    _taskCode = json['TaskCode'];
  }
  num? _taskId;
  String? _taskName;
  String? _taskCode;
Tasks copyWith({  num? taskId,
  String? taskName,
  String? taskCode,
}) => Tasks(  taskId: taskId ?? _taskId,
  taskName: taskName ?? _taskName,
  taskCode: taskCode ?? _taskCode,
);
  num? get taskId => _taskId;
  String? get taskName => _taskName;
  String? get taskCode => _taskCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TaskId'] = _taskId;
    map['TaskName'] = _taskName;
    map['TaskCode'] = _taskCode;
    return map;
  }

}