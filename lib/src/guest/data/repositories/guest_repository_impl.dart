import 'package:vtv_common/src/core/constants/typedef.dart';
import 'package:vtv_common/src/home/domain/entities/dto/product_detail_resp.dart';
import 'package:vtv_common/src/home/domain/entities/dto/product_page_resp.dart';
import 'package:vtv_common/src/order/domain/entities/shipping_entity.dart';
import 'package:vtv_common/src/shop/domain/entities/shop_category_entity.dart';

import 'package:vtv_common/src/shop/domain/entities/dto/shop_detail_resp.dart';

import '../../../core/network/network.dart';
import '../../../profile/domain/domain.dart';
import '../data_sources/guest_data_source.dart';
import '../../domain/repositories/guest_repository.dart';

class GuestRepositoryImpl implements GuestRepository {
  final GuestDataSource _guestDataSource;

  GuestRepositoryImpl(this._guestDataSource);

  @override
  FRespData<int> countShopFollowed(int shopId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () => _guestDataSource.countShopFollowed(shopId),
    );
  }

  @override
  FRespData<ShopDetailResp> getShopDetailById(int shopId) async {
    return handleDataResponseFromDataSource(
      dataCallback: () => _guestDataSource.getShopDetailById(shopId),
    );
  }

  @override
  FRespData<List<DistrictEntity>> getDistrictsByProvinceCode(String provinceCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getDistrictsByProvinceCode(provinceCode),
    );
  }

  @override
  FRespData<List<ProvinceEntity>> getProvinces() async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getProvinces(),
    );
  }

  @override
  FRespData<List<WardEntity>> getWardsByDistrictCode(String districtCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getWardsByDistrictCode(districtCode),
    );
  }

  @override
  FRespData<String> getAddressByWardCode(String wardCode) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async {
        final addressResp = await _guestDataSource.getFullAddressByWardCode(wardCode);
        return SuccessResponse(
            code: addressResp.code,
            message: addressResp.message,
            status: addressResp.status,
            // ward -> district -> province
            data:
                '${addressResp.data?.ward.fullName}, ${addressResp.data?.district.fullName}, ${addressResp.data?.province.fullName}');
      },
    );
  }

  @override
  FRespData<ShopCategoryEntity> getCategoryShopByCategoryShopId(int categoryShopId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getCategoryShopByCategoryShopId(categoryShopId),
    );
  }

  @override
  FRespData<List<ShopCategoryEntity>> getCategoryShopByShopId(int shopId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getCategoryShopByShopId(shopId),
    );
  }

  @override
  FRespData<ProductPageResp> getProductPageByCategory(int page, int size, categoryId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getProductPageByCategory(page, size, categoryId),
    );
  }

  @override
  FRespData<int> getProductCountFavorite(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _guestDataSource.getProductCountFavorite(productId),
    );
  }

  @override
  FRespData<ProductDetailResp> getProductDetailById(int productId) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => _guestDataSource.getProductDetailById(productId),
    );
  }

  @override
  FRespData<ShippingEntity> getCalculateShipping(
      String wardCodeCustomer, String wardCodeShop, String shippingProvider) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async =>
          await _guestDataSource.getCalculateShipping(wardCodeCustomer, wardCodeShop, shippingProvider),
    );
  }

  @override
  FRespData<List<ShippingEntity>> getTransportProviders(String wardCodeCustomer, String wardCodeShop) async {
    return await handleDataResponseFromDataSource(
      dataCallback: () async => await _guestDataSource.getTransportProviders(wardCodeCustomer, wardCodeShop),
    );
  }
}
