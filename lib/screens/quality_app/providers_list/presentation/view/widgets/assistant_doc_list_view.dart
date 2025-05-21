import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/core/components/empty_state.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/manager/fetch_provides_cubit/fetch_providers_cubit.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/manager/fetch_provides_cubit/fetch_providers_state.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/view/widgets/assistant_doc_clickable_widget.dart';

class AssistantDocListView extends StatelessWidget {
  const AssistantDocListView({super.key});

  @override
  Widget build(BuildContext context) {
    // var relatedDoctorsCubit = context.read<RelatedDoctorsCubit>();
    var relatedDoctorsWatch = context.watch<FetchProvidersCubit>();
    return BlocBuilder<FetchProvidersCubit, FetchProvidersState>(
        builder: (context, state) {
      return state is FetchProvidersLoading
          ? const Expanded(child: Center(child: CircularProgressIndicator()))
          : relatedDoctorsWatch.doctors.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                    itemCount: relatedDoctorsWatch.doctors.length,
                    // shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      var provider = relatedDoctorsWatch.doctors[index];
                      return AssistantDocClickableWidget(
                        onTap: () {
                          context
                              .read<FetchProvidersCubit>()
                              .setSelectedDocId(provider);
                          // context
                          //     .read<UserCubit>()
                          //     .updateAssistantUser(provider);
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop(true);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }

                          // GoRouter.of(context).go(
                          //     RoutesKeys.kAssistantReservationsViewTab);
                        },
                        providerModel: provider,
                        isSelected: provider.providerId ==
                            relatedDoctorsWatch.selectedDocId,
                      );
                      // : AssistantDocClickableWidget(
                      //     onTap: () {
                      //       context
                      //           .read<FetchProvidersCubit>()
                      //           .setSelectedDocId(doc);
                      //       context
                      //           .read<UserCubit>()
                      //           .updateAssistantUser(doc);
                      //       if (Navigator.of(context).canPop()) {
                      //         Navigator.of(context).pop(true);
                      //       } else {
                      //         Navigator.of(context).push(
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 const HomeScreen(),
                      //           ),
                      //         );
                      //       }
                      //     },
                      //     providerModel: provider,
                      //     isSelected: provider.providerId ==
                      //         context
                      //             .read<FetchProvidersCubit>()
                      //             .selectedDocId,
                      //   ),
                      // );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8),
                  ),
                )
              : Expanded(
                  child: EmptyState(
                    text: 'لا يوجد مغاسل حاليا ',

                    // iconPath: AppAssets.doctorBg,
                  ),
                );
    });
  }
}
