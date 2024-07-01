class StatusOrderModel {
  Statuses? statuses;

  StatusOrderModel({this.statuses});

  StatusOrderModel.fromJson(Map<String, dynamic> json) {
    statuses =
        json['statuses'] != null ? Statuses.fromJson(json['statuses']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statuses != null) {
      data['statuses'] = statuses?.toJson();
    }
    return data;
  }
}

class Statuses {
  List<Today>? today;
  List<All>? all;

  Statuses({this.today, this.all});

  Statuses.fromJson(Map<String, dynamic> json) {
    if (json['today'] != null) {
      today = <Today>[];
      json['today'].forEach((v) {
        today?.add(Today.fromJson(v));
      });
    }
    if (json['all'] != null) {
      all = <All>[];
      json['all'].forEach((v) {
        all?.add(All.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (today != null) {
      data['today'] = today?.map((v) => v.toJson()).toList();
    }
    if (all != null) {
      data['all'] = all?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Today {
  String? status;
  int? count;
  String? translate;
  String? total;

  Today({this.status, this.count, this.translate,this.total});

  Today.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    translate = json['translate'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    data['translate'] = translate;
    data['total'] = total;
    return data;
  }
}

class All {
  String? status;
  int? count;
  String? translate;
  String? total;

  All({this.status, this.count, this.translate,this.total});

  All.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    translate = json['translate'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    data['translate'] = translate;
    data['total'] = total;
    return data;
  }
}
