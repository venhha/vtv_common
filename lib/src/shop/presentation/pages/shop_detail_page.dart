import 'package:flutter/material.dart';
import 'package:vtv_common/src/core/presentation/components/rating.dart';
import 'package:vtv_common/src/core/presentation/components/wrapper.dart';
import 'package:vtv_common/src/shop/domain/entities/dto/shop_detail_resp.dart';
import 'package:vtv_common/src/shop/presentation/components/shop_info.dart';

class ShopDetailPage extends StatelessWidget {
  const ShopDetailPage({
    super.key,
    required this.shopDetail,
    this.bottomActionBuilder,
  });

  final ShopDetailResp shopDetail;
  final Widget? bottomActionBuilder;

  // custom show

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cửa hàng'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShopInfo(
            shopId: shopDetail.shop.shopId,
            shopDetail: shopDetail,
            showFollowedCount: true,
            showShopDetail: true,
          ),
          const Divider(),

          // rating
          Wrapper(
            label: const WrapperLabel(labelText: 'Đánh giá', icon: Icons.star),
            suffixLabel: Row(
              children: [
                Rating(
                  rating: shopDetail.averageRatingShop,
                  showRatingBar: true,
                  showRatingText: false,
                ),
              ],
            ),
          ),

          // product count
          Wrapper(
            label: const WrapperLabel(labelText: 'Tổng sản phẩm', icon: Icons.shopping_cart),
            suffixLabel: Text('${shopDetail.countProduct} sản phẩm'),
          ),

          // phone
          Wrapper(
            label: const WrapperLabel(labelText: 'Số điện thoại', icon: Icons.phone),
            suffixLabel: Text(shopDetail.shop.phone),
          ),

          // email
          Wrapper(
            label: const WrapperLabel(labelText: 'Email', icon: Icons.email),
            suffixLabel: Text(shopDetail.shop.email),
          ),

          // address
          Wrapper(
            labelCrossAxisAlignment: CrossAxisAlignment.start,
            label: const WrapperLabel(labelText: 'Địa chỉ', icon: Icons.location_on),
            suffixLabel: Expanded(
              child: Text(
                shopDetail.shop.fullAddress,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // time open
          Wrapper(
            label: const WrapperLabel(labelText: 'Giờ mở cửa', icon: Icons.access_time),
            // suffixLabel: Text(ConversionUtils.convertDateTimeToString(shopDetail.shop.openTime, pattern: 'hh:mm aa')),
            suffixLabel: Text(shopDetail.shop.openTime),
          ),

          // time open
          Wrapper(
            label: const WrapperLabel(labelText: 'Giờ đóng cửa', icon: Icons.access_time_filled),
            // suffixLabel: Text(ConversionUtils.convertDateTimeToString(shopDetail.shop.closeTime, pattern: 'hh:mm aa')),
            suffixLabel: Text(shopDetail.shop.closeTime),
          ),

          if (bottomActionBuilder != null) bottomActionBuilder!,
        ],
      ),
    );
  }
}
