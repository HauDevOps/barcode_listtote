class StatusTote{

  StatusTote({this.tote, this.status});

  factory StatusTote.fromJson(Map<String, dynamic> json) {
    return StatusTote(
      tote: json['Tote'],
      status: json['Status']
    );
  }

  Map<String, dynamic> toJson() => {
    'Tote': tote,
    'Status': status
  };

  String tote;
  bool status;
}