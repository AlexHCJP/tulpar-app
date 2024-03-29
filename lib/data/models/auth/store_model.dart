import 'package:flutter/cupertino.dart';
import 'package:garage/core/services/database/isar_service.dart';
import 'package:garage/core/utils/parser.dart';
import 'package:garage/data/models/dictionary/car_model_model.dart';
import 'package:isar/isar.dart';

import '../dictionary/car_model.dart';
import '../dictionary/city_model.dart';
import '../dictionary/group_model.dart';
import '../dictionary/producer_model.dart';

part 'store_model.g.dart';

@collection
class StoreModel {
  final Id id;
  final String name;
  final String? description;
  final String phone;
  final String? image;
  final double rating;
  @ignore
  final CityModel? city;
  final String? address;

  @ignore
  final StoreCategoryModel? categories;

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    StoreModel store = StoreModel(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        phone: map['phone'],
        image: map['image'],
        rating: Parser.toDouble(map['rating']),
        categories: map['store_category'] != null ? StoreCategoryModel.fromMap(map['store_category']) : null,
        city: map['city'] != null ? CityModel.fromMap(map['city']): null,
        address: map['address']
    );
    return store;
  }

  StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.phone,
    required this.rating,
    this.image,
    this.categories,
    this.city,
    this.address
  });
}

class StoreCategoryModel {
  final List<ProducerModel> producers;
  final List<CarModelModel> models;
  final List<CarModel> cars;
  final List<GroupModel> groups;

  StoreCategoryModel({
    required this.producers,
    required this.models,
    required this.groups,
    required this.cars
  });

  factory StoreCategoryModel.fromMap(Map<String, dynamic> map) {
    StoreCategoryModel storeCategory = StoreCategoryModel(
      groups: map['groups']?.map<GroupModel>((val) => GroupModel.fromMap(val)).toList() ?? [],
      models: map['models']?.map<CarModelModel>((val) => CarModelModel.fromMap(val)).toList() ?? [],
      producers: map['producers']?.map<ProducerModel>((val) => ProducerModel.fromMap(val)).toList() ?? [],
      cars: map['cars']?.map<CarModel>((val) => CarModel.fromMap(val)).toList() ?? [],
    );

    return storeCategory;
  }
}