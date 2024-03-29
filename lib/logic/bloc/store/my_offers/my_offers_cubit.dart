import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:garage/data/models/dictionary/offer_model.dart';
import 'package:garage/data/repositories/store/offer_store_repository.dart';
import 'package:garage/logic/bloc/store/auth/auth_store_cubit.dart';

import '../../../../data/enums/fetch_status.dart';
import '../../../../data/models/error_model.dart';
import '../../../../data/params/offers/index_offer_params.dart';
import '../../user/auth/auth_cubit.dart';

part 'my_offers_state.dart';

class MyOffersCubit extends Cubit<MyOffersState> {
  final AuthStoreCubit authCubit;
  MyOffersCubit(this.authCubit) : super(MyOffersState());

  Future fetch([IndexOfferParams? params]) async {
    if(state.status == FetchStatus.loading) return;
    emit(state.copyWith(status: FetchStatus.loading));
    return OfferStoreRepository.indexMy(params ?? IndexOfferParams()).then((value) {
      replace(value, params == null || params.startRow == 0);
    }).catchError((error) {
      if(error is DioException) {
        if(error.response?.statusCode == 403) {
          authCubit.logout();
          emit(state.copyWith(status: FetchStatus.error, error: ErrorModel.parse(error)));
        }
      }
      emit(state.copyWith(status: FetchStatus.error, error: ErrorModel.parse(error)));
    });
  }

  replace(List<OfferModel> orders, bool isReplace) {
    emit(state.copyWith(
        status: FetchStatus.success,
        offers: isReplace ? orders : [...state.offers, ...orders]
    ));
  }
}
