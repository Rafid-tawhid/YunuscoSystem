class MachineRepairTaskModel {
  MachineRepairTaskModel({
      num? taskId, 
      String? taskName,}){
    _taskId = taskId;
    _taskName = taskName;
}

  MachineRepairTaskModel.fromJson(dynamic json) {
    _taskId = json['TaskId'];
    _taskName = json['TaskName'];
  }
  num? _taskId;
  String? _taskName;
MachineRepairTaskModel copyWith({  num? taskId,
  String? taskName,
}) => MachineRepairTaskModel(  taskId: taskId ?? _taskId,
  taskName: taskName ?? _taskName,
);
  num? get taskId => _taskId;
  String? get taskName => _taskName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TaskId'] = _taskId;
    map['TaskName'] = _taskName;
    return map;
  }

}