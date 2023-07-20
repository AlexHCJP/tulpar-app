import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garage/data/params/order/create_order_params.dart';
import 'package:garage/data/repositories/user/order_user_repository.dart';

import '../../../../data/enums/fetch_status.dart';
import '../../../../data/models/error_model.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit() : super(CreateOrderState());

  create(CreateOrderParams params) {
    if(state.status == FetchStatus.loading) return;
    emit(CreateOrderState(status: FetchStatus.loading));
      OrderUserRepository.create(params).then((value) {
      // myCarCubit.fetch();
      emit(CreateOrderState(status: FetchStatus.success));
    }).catchError((error) {
      emit(CreateOrderState(status: FetchStatus.error, error: ErrorModel.parse(error)));
    });
  }
}