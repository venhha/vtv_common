import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:vtv_common/core.dart';

import '../chat_room_entity.dart';

class ChatRoomPageResp extends IBasePageResp<ChatRoomEntity> {
  const ChatRoomPageResp({
    required super.items,
    super.count,
    super.page,
    super.size,
    super.totalPage,
  });

  ChatRoomPageResp copyWith({
    List<ChatRoomEntity>? items,
    int? count,
    int? page,
    int? size,
    int? totalPage,
  }) {
    return ChatRoomPageResp(
      items: items ?? this.items,
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'count': count,
      'page': page,
      'size': size,
      'totalPage': totalPage,
    };
  }

  factory ChatRoomPageResp.fromMap(Map<String, dynamic> map) {
    return ChatRoomPageResp(
      items: List<ChatRoomEntity>.from(
        (map['roomChatDTOs'] as List).map<ChatRoomEntity>(
          (x) => ChatRoomEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      count: map['count'] != null ? map['count'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
      size: map['size'] != null ? map['size'] as int : null,
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomPageResp.fromJson(String source) =>
      ChatRoomPageResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomChatPageResp(items: $items, count: $count, page: $page, size: $size, totalPage: $totalPage)';
  }

  @override
  bool operator ==(covariant ChatRoomPageResp other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items) &&
        other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage;
  }

  @override
  int get hashCode {
    return items.hashCode ^ count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode;
  }
}
