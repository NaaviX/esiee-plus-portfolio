import 'package:meta/meta.dart';

abstract class FreeRoomState  {
  const FreeRoomState();

}

class FreeRoomsInitial extends FreeRoomState {}

class FreeRoomsLoadInProgress extends FreeRoomState {}

class FreeRoomsLoadSuccess extends FreeRoomState {
  final List<dynamic> freeRooms;

  const FreeRoomsLoadSuccess({@required this.freeRooms}) : assert(freeRooms != null);

}

class FreeRoomsLoadFailure extends FreeRoomState {}