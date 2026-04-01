import 'package:dartz/dartz.dart';
import 'package:routing_tracker/core/errors/failure.dart';
import 'package:routing_tracker/features/google_map/domain/entities/place_entity.dart';

abstract class GoogleMapRepo {
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({required String query});
}
