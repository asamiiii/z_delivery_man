class IndexModel {
  IndexModel({
    required this.today,
    required this.all,
  });
    Today? today;
    All? all;
  
  IndexModel.fromJson(Map<String, dynamic> json){
    today = Today?.fromJson(json['Today']??{});
    all = All.fromJson(json['All']??{});
  }

}

class Today {
  Today({
    required this.orderCount,
    required this.itemCount,
  });
  late final OrderCount orderCount;
  late final ItemCount itemCount;
  
  Today.fromJson(Map<String, dynamic> json){
    orderCount = OrderCount.fromJson(json['order_count']);
    itemCount = ItemCount.fromJson(json['item_count']);
  }

 
}

class OrderCount {
  OrderCount({
    required this.opened,
    required this.providerAssigned,
    required this.providerReceived,
    required this.checkUp,
    required this.finished,
    required this.fromProvider,
    required this.remaining,
  });
  late final int? opened;
  late final int? providerAssigned;
  late final int? providerReceived;
  late final int? checkUp;
  late final int? finished;
  late final int? fromProvider;
  late final int? remaining;
  
  OrderCount.fromJson(Map<String, dynamic> json){
    opened = json['opened'] ?? 0;
    providerAssigned = json['provider_assigned'] ?? 0;
    providerReceived = json['provider_received'] ?? 0;
    checkUp = json['check_up'] ?? 0;
    finished = json['finished'] ?? 0;
    fromProvider = json['from_provider'] ?? 0;
    remaining = json['remaining']??0;
  }

}

class OrderCountAll {
  OrderCountAll({
    required this.opened,
    required this.providerAssigned,
    required this.providerReceived,
    required this.checkUp,
    required this.finished,
    required this.fromProvider,
    required this.remaining,
  });
  late final int? opened;
  late final int? providerAssigned;
  late final int? providerReceived;
  late final int? checkUp;
  late final int? finished;
  late final int? fromProvider;
  late final int? remaining;
  
  OrderCountAll.fromJson(Map<String, dynamic> json){
    opened = json['opened_all'] ?? 0;
    providerAssigned = json['provider_assigned_all'] ?? 0;
    providerReceived = json['provider_received_all'] ?? 0;
    checkUp = json['check_up_all'] ?? 0;
    finished = json['finished_all'] ?? 0;
    fromProvider = json['from_provider_all'] ?? 0;
    // remaining = json['remaining']??0;
  }

}

class ItemCount {
  ItemCount({
    required this.opened,
    required this.providerAssigned,
    required this.providerReceived,
    required this.checkUp,
    required this.finished,
    required this.fromProvider,
    required this.remaining,
  });
  late final int? opened;
  late final int? providerAssigned;
  late final int? providerReceived;
  late final int? checkUp;
  late final int? finished;
  late final int? fromProvider;
  late final int? remaining;
  
  ItemCount.fromJson(Map<String, dynamic> json){
    opened = json['opened'] ?? 0;
    providerAssigned = json['provider_assigned'] ?? 0;
    providerReceived = json['provider_received'] ?? 0;
    checkUp = json['check_up'] ?? 0;
    finished = json['finished'] ?? 0;
    fromProvider = json['from_provider']??0;
    remaining = json['remaining'] ?? 0;
  }

}

class ItemCountAll {
  ItemCountAll({
    required this.opened,
    required this.providerAssigned,
    required this.providerReceived,
    required this.checkUp,
    required this.finished,
    required this.fromProvider,
    required this.remaining,
  });
  late final int? opened;
  late final int? providerAssigned;
  late final int? providerReceived;
  late final int? checkUp;
  late final int? finished;
  late final int? fromProvider;
  late final int? remaining;
  
  ItemCountAll.fromJson(Map<String, dynamic> json){
    opened = json['opened_all'] ?? 0;
    providerAssigned = json['provider_assigned_all'] ?? 0;
    providerReceived = json['provider_received_all'] ?? 0;
    checkUp = json['check_up_all'] ?? 0;
    finished = json['finished_all'] ?? 0;
    fromProvider = json['from_provider_all']??0;
  }

}

class All {
  All({
    required this.orderCount,
    required this.itemCount,
  });
  late final OrderCountAll orderCount;
  late final ItemCountAll itemCount;
  
  All.fromJson(Map<String, dynamic> json){
    orderCount = OrderCountAll.fromJson(json['order_count']??{});
    itemCount = ItemCountAll.fromJson(json['item_count']??{});
  }

}

// class IndexModel {
//   List<StatusModel?>? statusModel;
//   IndexModel(
//     this.statusModel,
//   );

//   IndexModel.fromJson(Map<String, dynamic> json) {
//     statusModel = [];

//     for (var ele in json.entries) {
//       statusModel?.add(StatusModel.fromJson(ele));
//     }
//   }
// }

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
