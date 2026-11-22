class CartItem {
  const CartItem({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  final String productId;
  final String variantId;
  final int quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        variantId: variantId,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'variantId': variantId,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as String,
        variantId: json['variantId'] as String,
        quantity: json['quantity'] as int,
      );
}

enum FulfillmentType { delivery, pickup }

enum PaymentMethod { cod, card, instaPay, vodafoneCash }

enum OrderStatus { received, preparing, outForDelivery, readyForPickup, delivered }

class OrderLineItem {
  const OrderLineItem({
    required this.productId,
    required this.variantId,
    required this.nameEn,
    required this.nameAr,
    required this.variantLabelEn,
    required this.variantLabelAr,
    required this.unitPriceEgp,
    required this.quantity,
    this.grams,
  });

  final String productId;
  final String variantId;
  final String nameEn;
  final String nameAr;
  final String variantLabelEn;
  final String variantLabelAr;
  final double unitPriceEgp;
  final int quantity;
  final int? grams;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'variantId': variantId,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'variantLabelEn': variantLabelEn,
        'variantLabelAr': variantLabelAr,
        'unitPriceEgp': unitPriceEgp,
        'quantity': quantity,
        'grams': grams,
      };

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        productId: json['productId'] as String,
        variantId: json['variantId'] as String,
        nameEn: json['nameEn'] as String,
        nameAr: json['nameAr'] as String,
        variantLabelEn: json['variantLabelEn'] as String,
        variantLabelAr: json['variantLabelAr'] as String,
        unitPriceEgp: (json['unitPriceEgp'] as num).toDouble(),
        quantity: json['quantity'] as int,
        grams: json['grams'] as int?,
      );
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotalEgp,
    required this.discountEgp,
    required this.deliveryFeeEgp,
    required this.totalEgp,
    required this.pointsEarned,
    required this.pointsUsed,
    required this.fulfillmentType,
    required this.paymentMethod,
    required this.status,
    this.addressSummary,
    this.couponCode,
  });

  final String id;
  final DateTime createdAt;
  final List<OrderLineItem> items;
  final double subtotalEgp;
  final double discountEgp;
  final double deliveryFeeEgp;
  final double totalEgp;
  final int pointsEarned;
  final int pointsUsed;
  final FulfillmentType fulfillmentType;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final String? addressSummary;
  final String? couponCode;

  OrderModel copyWith({OrderStatus? status}) => OrderModel(
        id: id,
        createdAt: createdAt,
        items: items,
        subtotalEgp: subtotalEgp,
        discountEgp: discountEgp,
        deliveryFeeEgp: deliveryFeeEgp,
        totalEgp: totalEgp,
        pointsEarned: pointsEarned,
        pointsUsed: pointsUsed,
        fulfillmentType: fulfillmentType,
        paymentMethod: paymentMethod,
        status: status ?? this.status,
        addressSummary: addressSummary,
        couponCode: couponCode,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((e) => e.toJson()).toList(),
        'subtotalEgp': subtotalEgp,
        'discountEgp': discountEgp,
        'deliveryFeeEgp': deliveryFeeEgp,
        'totalEgp': totalEgp,
        'pointsEarned': pointsEarned,
        'pointsUsed': pointsUsed,
        'fulfillmentType': fulfillmentType.name,
        'paymentMethod': paymentMethod.name,
        'status': status.name,
        'addressSummary': addressSummary,
        'couponCode': couponCode,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        items: (json['items'] as List<dynamic>)
            .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotalEgp: (json['subtotalEgp'] as num).toDouble(),
        discountEgp: (json['discountEgp'] as num).toDouble(),
        deliveryFeeEgp: (json['deliveryFeeEgp'] as num).toDouble(),
        totalEgp: (json['totalEgp'] as num).toDouble(),
        pointsEarned: json['pointsEarned'] as int,
        pointsUsed: json['pointsUsed'] as int,
        fulfillmentType: FulfillmentType.values.byName(
          json['fulfillmentType'] as String,
        ),
        paymentMethod: PaymentMethod.values.byName(
          json['paymentMethod'] as String,
        ),
        status: OrderStatus.values.byName(json['status'] as String),
        addressSummary: json['addressSummary'] as String?,
        couponCode: json['couponCode'] as String?,
      );
}
