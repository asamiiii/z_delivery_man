List<TimeSlotsModel> timeSlotsFromJson(jsonData) {
  return List<TimeSlotsModel>.from(
      jsonData.map((x) => TimeSlotsModel.fromJson(x)));
}

class TimeSlotsModel {
  int? id;
  String? from;
  String? to;
  int? type;
  int? count;

  TimeSlotsModel({this.id, this.from, this.to, this.type, this.count});

  TimeSlotsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from'] = from;
    data['to'] = to;
    data['type'] = type;
    data['count'] = count;
    return data;
  }
}
