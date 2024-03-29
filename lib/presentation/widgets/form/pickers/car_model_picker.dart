import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garage/data/models/dictionary/car_model_model.dart';
import 'package:garage/presentation/routing/router.dart';
import 'package:garage/presentation/widgets/form/pickers/car_picker.dart';
import 'package:garage/presentation/widgets/form/pickers/volume_picker.dart';
import 'package:garage/presentation/widgets/form/pickers/year_picker.dart';

import '../../../../data/models/dictionary/producer_model.dart';

class CarModelController extends ValueNotifier<CarModelModel?> {
  CarModelController({ CarModelModel? value }): super(value);

  _change(CarModelModel carModel) {
    value = carModel;
    notifyListeners();
  }

  void toCarModelScreen(
      BuildContext context,
      ProducerModel producer,
      YearController? yearController,
      VolumeController? volumeController,
      CarApiController? carApiController
  ) {
    print('aaa');
    context.router.push(SplashRouter(
        children: [
          PickerRouter(
              children: [CarModelPickerRoute(producer: producer)]
          )
        ]
    )).then((value) {
      if(value != null) {
        _change(value as CarModelModel);
        if(carApiController != null) {
          carApiController.toCarApiScreen(
              context,
              producer,
              value,
              yearController,
              volumeController
          );
        }
      }
    });
  }

  remove() {
    value = null;
    notifyListeners();
  }
}

class CarModelPickerWidget extends StatelessWidget {
  final CarModelController? controller;
  final CarApiController? carApiController;
  final YearController? yearController;
  final VolumeController? volumeController;
  final ProducerModel producer;
  final String label;

  const CarModelPickerWidget({
    super.key,
    required this.label,
    this.controller,
    required this.producer,
    this.yearController,
    this.volumeController,
    this.carApiController
  });


  _onTap(BuildContext context) => () {
    controller?.toCarModelScreen(context, producer, yearController, volumeController, carApiController);
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        InkWell(
          onTap: _onTap(context),
          child: Container(
            height: 55,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(10)

            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder(
                  valueListenable: controller ?? CarModelController(),
                  builder: (context, value, child) {
                    return Text(
                        value?.name ?? 'Не выбрано'
                    );
                  }
              ),
            ),
          ),
        ),
      ],
    );
  }
}