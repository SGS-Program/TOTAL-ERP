class PrResponse {
  final bool error;
  final int type;
  final String message;
  final List<PrData> data;

  PrResponse({
    required this.error,
    required this.type,
    required this.message,
    required this.data,
  });

  factory PrResponse.fromJson(Map<String, dynamic> json) {
    bool hasError = true;
    if (json['error'] == false || json['error'] == 'false') {
      hasError = false;
    }
    return PrResponse(
      error: hasError,
      type: int.tryParse(json['type']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PrData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PrData {
  final PrMaster master;
  final List<PrItem> items;

  PrData({
    required this.master,
    required this.items,
  });

  factory PrData.fromJson(Map<String, dynamic> json) {
    return PrData(
      master: PrMaster.fromJson(json['master'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PrItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PrMaster {
  final int id;
  final String no;
  final String reqDate;
  final String department;
  final String? requestedBy;
  final String quantityRequired;
  final String? priority;
  final String? status;
  final String dtime;

  PrMaster({
    required this.id,
    required this.no,
    required this.reqDate,
    required this.department,
    this.requestedBy,
    required this.quantityRequired,
    this.priority,
    this.status,
    required this.dtime,
  });

  factory PrMaster.fromJson(Map<String, dynamic> json) {
    return PrMaster(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      no: json['no']?.toString() ?? '',
      reqDate: json['req_date']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      requestedBy: json['requested_by']?.toString(),
      quantityRequired: json['quantity_required']?.toString() ?? '0',
      priority: json['priority']?.toString(),
      status: json['status']?.toString(),
      dtime: json['dtime']?.toString() ?? '',
    );
  }
}

class PrItem {
  final int id;
  final String no;
  final int mid;
  final String? itemCode;
  final String? itemDescription;
  final String? uom;
  final String date;
  final String? quantityRequired;
  final String? productName;
  final String? qty;

  PrItem({
    required this.id,
    required this.no,
    required this.mid,
    this.itemCode,
    this.itemDescription,
    this.uom,
    required this.date,
    this.quantityRequired,
    this.productName,
    this.qty,
  });

  factory PrItem.fromJson(Map<String, dynamic> json) {
    return PrItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      no: json['no']?.toString() ?? '',
      mid: int.tryParse(json['mid']?.toString() ?? '') ?? 0,
      itemCode: json['item_code']?.toString(),
      itemDescription: json['item_description']?.toString(),
      uom: json['uom']?.toString(),
      date: json['date']?.toString() ?? '',
      quantityRequired: json['quantity_required']?.toString(),
      productName: json['product_name']?.toString(),
      qty: json['qty']?.toString(),
    );
  }
}
