import 'package:bde_esiee_mobile/src/resources/free_rooms_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import 'free_rooms_event.dart';
import 'free_rooms_state.dart';

class FreeRoomsBloc extends Bloc<FreeRoomEvent, FreeRoomState> {
  final FreeRoomsRepository freeRoomRepository;

  FreeRoomsBloc({@required this.freeRoomRepository})
      : assert(freeRoomRepository != null),
        super(FreeRoomsInitial());

  @override
  Stream<FreeRoomState> mapEventToState(FreeRoomEvent event) async* {

    if (event is FreeRoomsRequested) {
      yield FreeRoomsLoadInProgress();
      try {
        final List<dynamic> freeRooms = await freeRoomRepository.fetchFreeRooms();
        yield FreeRoomsLoadSuccess(freeRooms: freeRooms);
      } catch (_) {
        yield FreeRoomsLoadFailure();
      }
    }
  }
}