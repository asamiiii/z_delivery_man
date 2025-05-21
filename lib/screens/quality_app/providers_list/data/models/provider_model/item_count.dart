class ItemCount {
  int? opened;
  int? providerAssigned;
  int? providerReceived;
  int? itemsChecked;
  int? clientConfirm;
  int? inProcess;
  int? finished;
  int? fromProvider;
  int? remaining;

  ItemCount({
    this.opened,
    this.providerAssigned,
    this.providerReceived,
    this.itemsChecked,
    this.clientConfirm,
    this.inProcess,
    this.finished,
    this.fromProvider,
    this.remaining,
  });

  factory ItemCount.fromJson(Map<String, dynamic> json) => ItemCount(
        opened: json['opened'] as int?,
        providerAssigned: json['provider_assigned'] as int?,
        providerReceived: json['provider_received'] as int?,
        itemsChecked: json['items_checked'] as int?,
        clientConfirm: json['client_confirm'] as int?,
        inProcess: json['in_process'] as int?,
        finished: json['finished'] as int?,
        fromProvider: json['from_provider'] as int?,
        remaining: json['remaining'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'opened': opened,
        'provider_assigned': providerAssigned,
        'provider_received': providerReceived,
        'items_checked': itemsChecked,
        'client_confirm': clientConfirm,
        'in_process': inProcess,
        'finished': finished,
        'from_provider': fromProvider,
        'remaining': remaining,
      };
}
