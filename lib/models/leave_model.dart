class LeaveBalance {
  final String type;
  final num used;
  final num total;
  final num remaining;
  final String policyType;
  final int policyId;

  LeaveBalance({
    required this.type,
    required this.used,
    required this.total,
    required this.policyType,
    required this.policyId,
  }) : remaining = total - used;
}
