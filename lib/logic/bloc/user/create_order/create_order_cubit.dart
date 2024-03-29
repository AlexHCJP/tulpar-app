import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:garage/data/params/order/create_order_params.dart';
import 'package:garage/data/repositories/user/order_user_repository.dart';

import '../../../../data/enums/fetch_status.dart';
import '../../../../data/models/error_model.dart';
import '../auth/auth_cubit.dart';
import '../my_orders/my_order_cubit.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final MyOrderCubit myOrderCubit;
  final AuthCubit authCubit;
  CreateOrderCubit(this.myOrderCubit, this.authCubit) : super(CreateOrderState());

  create(CreateOrderParams params) {
    if(state.status == FetchStatus.loading) return;
    emit(CreateOrderState(status: FetchStatus.loading));
    OrderUserRepository.create(params).then((value) {
      print(value);
      myOrderCubit.fetch();
      emit(CreateOrderState(status: FetchStatus.success));
    }).catchError((error) {
      if(error is DioException) {
        if(error.response?.statusCode == 403) {
          authCubit.logout();
          emit(CreateOrderState(status: FetchStatus.error, error: ErrorModel.parse(error)));
        }
      }
      emit(CreateOrderState(status: FetchStatus.error, error: ErrorModel.parse(error)));
    });
  }
}
