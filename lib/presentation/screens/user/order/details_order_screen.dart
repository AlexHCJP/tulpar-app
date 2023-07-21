import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garage/data/models/dictionary/order_model.dart';
import 'package:garage/presentation/routing/router.dart';
import 'package:garage/presentation/widgets/screen_templates/screen_default_template.dart';

@RoutePage()
class DetailsOrderScreen extends StatefulWidget {

  final OrderModel order;

  const DetailsOrderScreen({super.key, required this.order});

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _back() {
    context.router.pop();
  }

  _toOffers() {
    context.router.navigate(
      OrderOffersRoute(order: widget.order)
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Details Order');
    return Stack(
      children: [
        ScreenDefaultTemplate(
          scrollController: _scrollController,
          children: [
            Text(widget.order.title),
            ElevatedButton(onPressed: _toOffers, child: Text('Offers'))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(onPressed: _back, icon: Icon(Icons.arrow_back_ios)),
        ),
      ],
    );
  }
}