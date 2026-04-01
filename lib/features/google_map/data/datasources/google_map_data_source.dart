import 'package:routing_tracker/core/services/api_service.dart';
import 'package:routing_tracker/features/google_map/data/models/place_response.dart';

abstract class GoogleMapDataSource {
  Future<List<PlaceResponse>> getPlaces({required String query});
}

class GoogleMapDataSourceImpl implements GoogleMapDataSource {
  final ApiService _apiService;

  GoogleMapDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<PlaceResponse>> getPlaces({required String query}) async {
    var data = await _apiService.get(endPoint: '/search?q=$query&format=json');

    return List<PlaceResponse>.from(data.map((e) => PlaceResponse.fromJson(e)));
  }
}
