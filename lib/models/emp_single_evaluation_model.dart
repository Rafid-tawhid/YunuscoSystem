class EmpSingleEvaluationModel {
  EmpSingleEvaluationModel({
      num? id, 
      String? employeeId, 
      String? ratingDate, 
      num? qualityOfWork, 
      num? productivity, 
      num? technicalSkills, 
      num? communication, 
      num? teamwork, 
      num? problemSolving, 
      num? initiative, 
      num? attendance, 
      num? adaptability, 
      num? leadership, 
      String? comments, 
      String? goals, 
      String? reviewedBy,}){
    _id = id;
    _employeeId = employeeId;
    _ratingDate = ratingDate;
    _qualityOfWork = qualityOfWork;
    _productivity = productivity;
    _technicalSkills = technicalSkills;
    _communication = communication;
    _teamwork = teamwork;
    _problemSolving = problemSolving;
    _initiative = initiative;
    _attendance = attendance;
    _adaptability = adaptability;
    _leadership = leadership;
    _comments = comments;
    _goals = goals;
    _reviewedBy = reviewedBy;
}

  EmpSingleEvaluationModel.fromJson(dynamic json) {
    _id = json['Id'];
    _employeeId = json['EmployeeId'];
    _ratingDate = json['RatingDate'];
    _qualityOfWork = json['QualityOfWork'];
    _productivity = json['Productivity'];
    _technicalSkills = json['TechnicalSkills'];
    _communication = json['Communication'];
    _teamwork = json['Teamwork'];
    _problemSolving = json['ProblemSolving'];
    _initiative = json['Initiative'];
    _attendance = json['Attendance'];
    _adaptability = json['Adaptability'];
    _leadership = json['Leadership'];
    _comments = json['Comments'];
    _goals = json['Goals'];
    _reviewedBy = json['ReviewedBy'];
  }
  num? _id;
  String? _employeeId;
  String? _ratingDate;
  num? _qualityOfWork;
  num? _productivity;
  num? _technicalSkills;
  num? _communication;
  num? _teamwork;
  num? _problemSolving;
  num? _initiative;
  num? _attendance;
  num? _adaptability;
  num? _leadership;
  String? _comments;
  String? _goals;
  String? _reviewedBy;
EmpSingleEvaluationModel copyWith({  num? id,
  String? employeeId,
  String? ratingDate,
  num? qualityOfWork,
  num? productivity,
  num? technicalSkills,
  num? communication,
  num? teamwork,
  num? problemSolving,
  num? initiative,
  num? attendance,
  num? adaptability,
  num? leadership,
  String? comments,
  String? goals,
  String? reviewedBy,
}) => EmpSingleEvaluationModel(  id: id ?? _id,
  employeeId: employeeId ?? _employeeId,
  ratingDate: ratingDate ?? _ratingDate,
  qualityOfWork: qualityOfWork ?? _qualityOfWork,
  productivity: productivity ?? _productivity,
  technicalSkills: technicalSkills ?? _technicalSkills,
  communication: communication ?? _communication,
  teamwork: teamwork ?? _teamwork,
  problemSolving: problemSolving ?? _problemSolving,
  initiative: initiative ?? _initiative,
  attendance: attendance ?? _attendance,
  adaptability: adaptability ?? _adaptability,
  leadership: leadership ?? _leadership,
  comments: comments ?? _comments,
  goals: goals ?? _goals,
  reviewedBy: reviewedBy ?? _reviewedBy,
);
  num? get id => _id;
  String? get employeeId => _employeeId;
  String? get ratingDate => _ratingDate;
  num? get qualityOfWork => _qualityOfWork;
  num? get productivity => _productivity;
  num? get technicalSkills => _technicalSkills;
  num? get communication => _communication;
  num? get teamwork => _teamwork;
  num? get problemSolving => _problemSolving;
  num? get initiative => _initiative;
  num? get attendance => _attendance;
  num? get adaptability => _adaptability;
  num? get leadership => _leadership;
  String? get comments => _comments;
  String? get goals => _goals;
  String? get reviewedBy => _reviewedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['EmployeeId'] = _employeeId;
    map['RatingDate'] = _ratingDate;
    map['QualityOfWork'] = _qualityOfWork;
    map['Productivity'] = _productivity;
    map['TechnicalSkills'] = _technicalSkills;
    map['Communication'] = _communication;
    map['Teamwork'] = _teamwork;
    map['ProblemSolving'] = _problemSolving;
    map['Initiative'] = _initiative;
    map['Attendance'] = _attendance;
    map['Adaptability'] = _adaptability;
    map['Leadership'] = _leadership;
    map['Comments'] = _comments;
    map['Goals'] = _goals;
    map['ReviewedBy'] = _reviewedBy;
    return map;
  }

}