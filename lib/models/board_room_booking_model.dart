class BoardRoomBookingModel {
  BoardRoomBookingModel({
      num? id, 
      String? meetingTitle, 
      String? organizerName, 
      String? organizerUserId, 
      String? organizerEmail, 
      String? department, 
      String? startTime, 
      String? endTime, 
      String? attendees, 
      String? agenda, 
      String? decisions, 
      String? actionItems, 
      String? notes, 
      String? status, 
      String? createdDate, 
      dynamic modifiedBy, 
      String? modifiedDate,}){
    _id = id;
    _meetingTitle = meetingTitle;
    _organizerName = organizerName;
    _organizerUserId = organizerUserId;
    _organizerEmail = organizerEmail;
    _department = department;
    _startTime = startTime;
    _endTime = endTime;
    _attendees = attendees;
    _agenda = agenda;
    _decisions = decisions;
    _actionItems = actionItems;
    _notes = notes;
    _status = status;
    _createdDate = createdDate;
    _modifiedBy = modifiedBy;
    _modifiedDate = modifiedDate;
}

  BoardRoomBookingModel.fromJson(dynamic json) {
    _id = json['Id'];
    _meetingTitle = json['MeetingTitle'];
    _organizerName = json['OrganizerName'];
    _organizerUserId = json['OrganizerUserId'];
    _organizerEmail = json['OrganizerEmail'];
    _department = json['Department'];
    _startTime = json['StartTime'];
    _endTime = json['EndTime'];
    _attendees = json['Attendees'];
    _agenda = json['Agenda'];
    _decisions = json['Decisions'];
    _actionItems = json['ActionItems'];
    _notes = json['Notes'];
    _status = json['Status'];
    _createdDate = json['CreatedDate'];
    _modifiedBy = json['ModifiedBy'];
    _modifiedDate = json['ModifiedDate'];
  }
  num? _id;
  String? _meetingTitle;
  String? _organizerName;
  String? _organizerUserId;
  String? _organizerEmail;
  String? _department;
  String? _startTime;
  String? _endTime;
  String? _attendees;
  String? _agenda;
  String? _decisions;
  String? _actionItems;
  String? _notes;
  String? _status;
  String? _createdDate;
  dynamic _modifiedBy;
  String? _modifiedDate;
BoardRoomBookingModel copyWith({  num? id,
  String? meetingTitle,
  String? organizerName,
  String? organizerUserId,
  String? organizerEmail,
  String? department,
  String? startTime,
  String? endTime,
  String? attendees,
  String? agenda,
  String? decisions,
  String? actionItems,
  String? notes,
  String? status,
  String? createdDate,
  dynamic modifiedBy,
  String? modifiedDate,
}) => BoardRoomBookingModel(  id: id ?? _id,
  meetingTitle: meetingTitle ?? _meetingTitle,
  organizerName: organizerName ?? _organizerName,
  organizerUserId: organizerUserId ?? _organizerUserId,
  organizerEmail: organizerEmail ?? _organizerEmail,
  department: department ?? _department,
  startTime: startTime ?? _startTime,
  endTime: endTime ?? _endTime,
  attendees: attendees ?? _attendees,
  agenda: agenda ?? _agenda,
  decisions: decisions ?? _decisions,
  actionItems: actionItems ?? _actionItems,
  notes: notes ?? _notes,
  status: status ?? _status,
  createdDate: createdDate ?? _createdDate,
  modifiedBy: modifiedBy ?? _modifiedBy,
  modifiedDate: modifiedDate ?? _modifiedDate,
);
  num? get id => _id;
  String? get meetingTitle => _meetingTitle;
  String? get organizerName => _organizerName;
  String? get organizerUserId => _organizerUserId;
  String? get organizerEmail => _organizerEmail;
  String? get department => _department;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get attendees => _attendees;
  String? get agenda => _agenda;
  String? get decisions => _decisions;
  String? get actionItems => _actionItems;
  String? get notes => _notes;
  String? get status => _status;
  String? get createdDate => _createdDate;
  dynamic get modifiedBy => _modifiedBy;
  String? get modifiedDate => _modifiedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['MeetingTitle'] = _meetingTitle;
    map['OrganizerName'] = _organizerName;
    map['OrganizerUserId'] = _organizerUserId;
    map['OrganizerEmail'] = _organizerEmail;
    map['Department'] = _department;
    map['StartTime'] = _startTime;
    map['EndTime'] = _endTime;
    map['Attendees'] = _attendees;
    map['Agenda'] = _agenda;
    map['Decisions'] = _decisions;
    map['ActionItems'] = _actionItems;
    map['Notes'] = _notes;
    map['Status'] = _status;
    map['CreatedDate'] = _createdDate;
    map['ModifiedBy'] = _modifiedBy;
    map['ModifiedDate'] = _modifiedDate;
    return map;
  }

}