import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/core/service_locator.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/repo/quality_manager_repo_imp.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/repo/quality_manger_repo.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/manager/fetch_provides_cubit/fetch_providers_cubit.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/assistant_select_doc_view_body.dart';
import 'package:z_delivery_man/styles/color.dart';

class QualityManagerSelectView extends StatelessWidget {
  const QualityManagerSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchProvidersCubit>(
          create: (context) => FetchProvidersCubit(getIt<QualityManagerRepoImp>()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اختر المغسله',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: const AssistantSelectDocViewBody(),
      ),
    );
  }
}
