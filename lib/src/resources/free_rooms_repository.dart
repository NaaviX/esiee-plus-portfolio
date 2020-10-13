import 'dart:async';
import 'package:meta/meta.dart';

import 'free_rooms_api_provider.dart';


class FreeRoomsRepository {
  final FreeRoomsApiProvider freeRoomsApiProvider;

  FreeRoomsRepository({@required this.freeRoomsApiProvider})
      : assert(freeRoomsApiProvider != null);

  Future<List<dynamic>> fetchFreeRooms() async {
    return freeRoomsApiProvider.fetchFreeRoomsList();
  }
}