import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage/data/enums/fetch_status.dart';
import 'package:garage/logic/bloc/user/my_orders/my_order_cubit.dart';
import 'package:garage/presentation/widgets/screen_templates/screen_default_template.dart';

import '../../../../data/models/dictionary/order_model.dart';
import '../../../routing/router.dart';
import '../../../widgets/cards/order_card.dart';
import '../../../widgets/navigation/header.dart';
import '../../../widgets/snackbars/error_snackbar.dart';

@RoutePage()
class OrdersScreen extends StatefulWidget {

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _onRefresh();
    _scrollController = ScrollController()..addListener(_listenerScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenerScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    return await context.read<MyOrderCubit>().fetch();
  }

  _listenerState(context, MyOrderState state) {
    if(state.status == FetchStatus.error) {
      showErrorSnackBar(context, state.error?.messages[0] ?? 'Неизвестная ошибка');
    }
  }

  _listenerScroll() async {
    if(_scrollController.position.maxScrollExtent < _scrollController.position.pixels + 200) {
      final state = context.read<MyOrderCubit>().state;

      if(state.status != FetchStatus.loading) return;

      final params = state.params;
      await context.read<MyOrderCubit>().fetch(params?.copyWith(
          startRow: params.startRow + params.rowsPerPage
      ));
    }
  }

  _toDetails(OrderModel order) => () {
    context.router.navigate(DetailsOrderRoute(order: order));
  };

  @override
  Widget build(BuildContext context) {
    return ScreenDefaultTemplate(
      scrollController: _scrollController,
      onRefresh: _onRefresh,
      children: [
        Header(isBack: false, title: 'Заказы'),

        BlocConsumer<MyOrderCubit, MyOrderState>(
          listener: _listenerState,
          builder: (context, state) {
            return Column(
              children: [
                ...state.orders.map((order) {
                  return OrderCard(order: order, callback: _toDetails(order));
                }).toList(),
                if(state.orders.isEmpty && state.status == FetchStatus.success) Text('Нет Заказов'),
                if(state.status == FetchStatus.loading) CupertinoActivityIndicator(),
                if(state.status == FetchStatus.error) Text('Ошибка')
              ],
            );
          },
        )
      ],
    );
  }
}
