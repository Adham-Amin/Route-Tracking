import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:routing_tracker/core/errors/failure.dart';
import 'package:routing_tracker/features/google_map/data/datasources/google_map_data_source.dart';
import 'package:routing_tracker/features/google_map/domain/entities/place_entity.dart';
import 'package:routing_tracker/features/google_map/domain/repositories/google_map_repo.dart';

class GoogleMapRepoImpl extends GoogleMapRepo {
  final GoogleMapDataSource googleMapDataSource;
  GoogleMapRepoImpl({required this.googleMapDataSource});

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    required String query,
  }) async {
    try {
      var data = await googleMapDataSource.getPlaces(query: query);
      return Right(data.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
