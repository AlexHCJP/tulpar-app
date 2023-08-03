import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/api/api_service.dart';
import 'core/services/database/isar_service.dart';
import 'core/services/database/shared_preference.dart';
import 'core/services/firebase/fb_auth_service.dart';
import 'core/services/firebase/fb_notification.dart';
import 'core/services/firebase/fb_service.dart';

import 'logic/bloc/dictionary/car_model/car_model_cubit.dart';
import 'logic/bloc/dictionary/current_city/current_city_cubit.dart';
import 'logic/bloc/dictionary/producer/producer_cubit.dart';
import 'logic/bloc/store/auth/auth_store_cubit.dart';
import 'logic/bloc/store/change_image/change_image_cubit.dart';
import 'logic/bloc/store/change_store/change_store_cubit.dart';
import 'logic/bloc/store/login/login_store_cubit.dart';
import 'logic/bloc/store/my_offers/my_offers_cubit.dart';
import 'logic/bloc/store/orders/orders_cubit.dart';
import 'logic/bloc/user/auth/auth_cubit.dart';
import 'logic/bloc/user/change_image/change_image_cubit.dart';
import 'logic/bloc/user/change_profile/change_profile_cubit.dart';
import 'logic/bloc/user/create_car/create_car_cubit.dart';
import 'logic/bloc/user/create_order/create_order_cubit.dart';
import 'logic/bloc/user/details_car/details_car_cubit.dart';
import 'logic/bloc/user/details_order/details_order_cubit.dart';
import 'logic/bloc/user/login/login_cubit.dart';
import 'logic/bloc/user/my_car/my_car_cubit.dart';
import 'logic/bloc/user/my_orders/my_order_cubit.dart';
import 'logic/bloc/user/order_offer/order_offer_cubit.dart';
import 'logic/bloc/user/register/register_cubit.dart';

import 'presentation/routing/router.dart';

// bool shouldUseFirebaseEmulator = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SPService.initialize();
  await dotenv.load(fileName: ".env");
  await FBService.initialize();
  await FbNotification.initialize();

  FBAuthService.setInstance();
  ApiService.initialize();
  await IsarService.initialize();

  // if (shouldUseFirebaseEmulator) {
  //   await auth.useAuthEmulator('localhost', 9099);
  // }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthCubit _authCubit;
  late AuthStoreCubit _authStoreCubit;
  late RegisterCubit _registerCubit;
  late MyCarCubit _myCarCubit;
  late MyOrderCubit _myOrderCubit;
  late AppRouter _appRouter;

  @override
  void initState() {
    _authCubit = AuthCubit()..initial();
    _authStoreCubit = AuthStoreCubit()..initial();
    _registerCubit = RegisterCubit(_authCubit);

    _myCarCubit = MyCarCubit(_authCubit);
    _myOrderCubit = MyOrderCubit(_authCubit);
    _appRouter = AppRouter(_authCubit, _authStoreCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => _authCubit,
        ),
        BlocProvider(
          lazy: false,
          create: (context) => _authStoreCubit,
        ),
        BlocProvider(
          create: (context) => _registerCubit,
        ),
        BlocProvider(
          create: (context) => LoginCubit(_authCubit, _registerCubit),
        ),
        BlocProvider(
          create: (context) => LoginStoreCubit(_authStoreCubit),
        ),


        //SCREEN WITH AUTH
        BlocProvider(
          create: (context) => _myCarCubit,
        ),
        BlocProvider(
          create: (context) => _myOrderCubit,
        ),
        BlocProvider(
          create: (context) => MyOffersCubit(_authCubit),
        ),


        //FORM
        BlocProvider(
          create: (context) => ChangeProfileCubit(_authCubit),
        ),
        BlocProvider(
          create: (context) => ChangeImageUserCubit(_authCubit),
        ),
        BlocProvider(
          create: (context) => ChangeStoreCubit(_authStoreCubit),
        ),
        BlocProvider(
          create: (context) => ChangeImageStoreCubit(_authStoreCubit),
        ),
        BlocProvider(
          create: (context) => CreateCarCubit(_myCarCubit),
        ),
        BlocProvider(
          create: (context) => CreateOrderCubit(_myOrderCubit),
        ),

        BlocProvider(
          create: (context) => OrderOfferCubit(),
        ),
        BlocProvider(
          create: (context) => DetailsCarCubit(),
        ),

        BlocProvider(
          create: (context) => ProducerCubit(),
        ),
        BlocProvider(
          create: (context) => CarModelCubit(),
        ),
        BlocProvider(
          create: (context) => CurrentCityCubit(_authCubit)..initial(),
        ),
        BlocProvider(
          create: (context) => DetailsOrderCubit(),
        ),
        BlocProvider(
          create: (context) => StoreOrdersCubit(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
