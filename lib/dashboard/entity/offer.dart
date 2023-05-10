class TraineeeRegistrationOffer {
  String? name;
  String? surname;
  String? phoneNumber;
  String? program;
  bool? offerAccepted;
  String? trainerId;
  String? date;

  TraineeeRegistrationOffer(
    this.name,
    this.surname,
    this.phoneNumber,
    this.program,
    this.offerAccepted,
    this.trainerId,
    this.date,
  );

  TraineeeRegistrationOffer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phoneNumber'];
    program = json['program'];
    offerAccepted = json['offerAccepted'];
    trainerId = json['trainerId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['surname'] = surname;
    data['phoneNumber'] = phoneNumber;
    data['program'] = program;
    data['offerAccepted'] = offerAccepted;
    data['trainerId'] = trainerId;
    data['date'] = date;
    return data;
  }
}
