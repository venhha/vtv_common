import 'package:flutter/material.dart';

import '../../../core/constants/types.dart';
import '../../../core/utils.dart';

enum OrderStatusBadgeType { customer, vendor, shipper }
//> shipper is not use???

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    this.type = OrderStatusBadgeType.customer,
  });

  final OrderStatus status;
  final OrderStatusBadgeType type;

//   WAITING,
//   PENDING,
//   SHIPPING,
//   COMPLETED,
//   CANCELLED,
//   PROCESSING,
//   CANCELED,

  String nameByType(OrderStatusBadgeType type) {
    switch (type) {
      case OrderStatusBadgeType.customer || OrderStatusBadgeType.vendor:
        return StringUtils.getOrderStatusName(status);
      case OrderStatusBadgeType.shipper:
        return StringUtils.getOrderStatusNameByShipper(status);
      default:
        return StringUtils.getOrderStatusName(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: ColorUtils.getOrderStatusBackgroundColor(status),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          // StringHelper.getOrderStatusName(status),
          nameByType(type),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
