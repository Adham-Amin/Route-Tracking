import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routing_tracker/features/google_map/domain/entities/place_entity.dart';
import 'package:routing_tracker/features/google_map/domain/repositories/google_map_repo.dart';
part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit({required this.googleMapRepo}) : super(GoogleMapInitial());

  final GoogleMapRepo googleMapRepo;

  List<PlaceEntity> places = [];

  void getPlaces({required String query}) async {
    emit(GoogleMapLoading());
    var result = await googleMapRepo.getPlaces(query: query);
    result.fold((l) => emit(GoogleMapError(failure: l.message)), (r) {
      places = r;
      emit(GoogleMapLoaded());
    });
  }

  void clearPlaces() {
    places = [];
    emit(GoogleMapLoaded());
  }
}
