
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garage/presentation/widgets/builder/favorite_builder.dart';
import 'package:garage/presentation/widgets/tiles/data_tile.dart';

import '../../../data/models/dictionary/car_model.dart';
import '../../routing/router.dart';

class CarCard extends StatelessWidget {
  final VoidCallback? callback;
  final CarModel car;
  final bool isMy;

  const CarCard({super.key, required this.car, this.callback, this.isMy = false});

  @override
  Widget build(BuildContext context) {
    return Container(

      // margin: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: callback,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(10)
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isMy) Align(
                alignment: Alignment.centerRight,
                child: FavoriteBuilder(carId: car.id),
              ),
              // Spacer(),
              DataTile(title: 'VIN', data: car.vinNumber, isDivider: false),
              DataTile(title: 'Машина', data: car.name, isDivider: false),
              DataTile(title: 'Год', data: car.year.toString(), isDivider: false),
              DataTile(title: 'Объем двигателя', data: car.volumeEngine.toString(), isDivider: false)

            ],
          ),
        ),
      ),
    );
  }

}