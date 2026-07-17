class Survey {
  final String uuid;
  final String clientName;
  final String contactNumber;
  final String email;
  final String address;
  final String? coordinates;
  final DateTime surveyDate;
  final Map<String, String> technicalSpecs;
  final String proposedSystem;
  final double proposedCapacityKw;
  final String status;
  final String? notes;
  final String? convertedProjectUuid;

  const Survey({
    required this.uuid,
    required this.clientName,
    required this.contactNumber,
    required this.email,
    required this.address,
    this.coordinates,
    required this.surveyDate,
    required this.technicalSpecs,
    required this.proposedSystem,
    required this.proposedCapacityKw,
    required this.status,
    this.notes,
    this.convertedProjectUuid,
  });

  Survey copyWith({
    String? uuid,
    String? clientName,
    String? contactNumber,
    String? email,
    String? address,
    String? coordinates,
    DateTime? surveyDate,
    Map<String, String>? technicalSpecs,
    String? proposedSystem,
    double? proposedCapacityKw,
    String? status,
    String? notes,
    String? convertedProjectUuid,
  }) {
    return Survey(
      uuid: uuid ?? this.uuid,
      clientName: clientName ?? this.clientName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      surveyDate: surveyDate ?? this.surveyDate,
      technicalSpecs: technicalSpecs ?? this.technicalSpecs,
      proposedSystem: proposedSystem ?? this.proposedSystem,
      proposedCapacityKw: proposedCapacityKw ?? this.proposedCapacityKw,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      convertedProjectUuid: convertedProjectUuid ?? this.convertedProjectUuid,
    );
  }
}
