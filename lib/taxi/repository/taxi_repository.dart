import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/dio/dio.dart';
import '../model/taxi_model.dart';

part 'taxi_repository.g.dart';

@riverpod
TaxiGroupRepository taxiGroupRepository(TaxiGroupRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return TaxiGroupRepository(dio, baseUrl: '/taxi');
}

@RestApi()
abstract class TaxiGroupRepository {
  factory TaxiGroupRepository(Dio dio, {String baseUrl}) = _TaxiGroupRepository;

  @GET('/')
  Future<List<TaxiGroup>> getTaxiGroups();

  @GET('/{id}')
  Future<TaxiGroup> getTaxiGroup({
    @Path() required String id,
  });

  @POST('/')
  Future<TaxiGroup> createTaxiGroup({
    @Body() required CreateTaxiGroup group,
  });

  @PATCH('/{id}/{status}')
  Future<void> updateTaxiGroup({
    @Path() required String id,
    @Path() required String status,
  });

  @POST('/{id}/member')
  Future<void> joinTaxiGroup({
    @Path() required String id,
  });

  @DELETE('/{id}/member')
  Future<void> leaveTaxiGroup({
    @Path() required String id,
  });

  @GET('/{id}/fee')
  Future<TaxiTotalFee> getFee({
    @Path() required String id,
  });

  @PATCH('/{id}/fee')
  Future<void> updateFee({
    @Path() required String id,
    @Body() required TaxiTotalFee totalFee,
  });
}
