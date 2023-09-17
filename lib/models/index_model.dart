class IndexModel {
  List<StatusModel?>? statusModel;
  IndexModel(
    this.statusModel,
  );

  IndexModel.fromJson(Map<String, dynamic> json) {
    statusModel = [];

    for (var ele in json.entries) {
      statusModel?.add(StatusModel.fromJson(ele));
    }
  }
}

class StatusModel {
  String? statusName;
  int? count;

  StatusModel({required this.statusName, required this.count});

  StatusModel.fromJson(MapEntry<String, dynamic> json) {
    statusName = json.key;
    count = json.value;
  }

  // Map<String, dynamic> toJson() => {
  // 			'new': new,
  // 			'waiting_deliveryMan': waitingDeliveryMan,
  // 			'finished': finished,
  // 			'check_up': checkUp,
  // 			'deliver_today': deliverToday,
  // 			'in_progress': inProgress,
  // 			'ended': ended,
  // 		};

}
