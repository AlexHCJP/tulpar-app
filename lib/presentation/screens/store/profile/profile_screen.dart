import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage/logic/bloc/dictionary/current_city/current_city_cubit.dart';
import 'package:garage/logic/bloc/user/auth/auth_cubit.dart';
import 'package:garage/presentation/routing/router.dart';
import 'package:garage/presentation/widgets/screen_templates/screen_default_template.dart';

import '../../../../data/models/dictionary/offer_model.dart';
import '../../../../logic/bloc/store/auth/auth_store_cubit.dart';
import '../../../widgets/tiles/setting_tile.dart';

@RoutePage()
class StoreProfileScreen extends StatefulWidget {

  const StoreProfileScreen({super.key});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
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

  _exit() {
    context.read<AuthStoreCubit>().logout();
  }

  _change() {
    context.router.navigate(SplashRouter(
        children: [
          StoreFormRouter(
              children: [
                ChangeStoreRoute()
              ]
          )
        ]
    ));
  }

  _notificationSwitch(bool value) {

  }

  @override
  Widget build(BuildContext context) {
    return ScreenDefaultTemplate(
      scrollController: _scrollController,
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return ClipOval(
              child: Container(
                color: Colors.grey.shade200,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                child: CachedNetworkImage(
                  imageUrl: state.user?.image ?? '',
                  placeholder: (context, String val) => CupertinoActivityIndicator(),
                  errorWidget: (context, String val, err) => Icon(Icons.person),
                ),
              ),
            );
          },
        ),
        TextButton(onPressed: _change, child: Text('Изменить профиль')),
        SizedBox(height: 20,),
        BlocBuilder<CurrentCityCubit, CurrentCityState>(
            builder: (context, state) {
              return SettingsTile(label: 'Город', child: Text(state.currentCity?.name ?? 'Не выбран'));
            }
        ),
        SettingsTile(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          label: 'Уведомления',
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: true,
            onChanged: _notificationSwitch,
          ),
          callback: _exit,
        ),
        SettingsTile(
          label: 'Выйти',
          child: Icon(
            Icons.exit_to_app_rounded,
            color: Colors.red.shade800,
          ),
          callback: _exit,
        ),

      ],
    );
  }
}
