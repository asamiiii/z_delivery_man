import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/components.dart';
import '../../../styles/color.dart';
import '../../order_details/cubit.dart';
import '../../order_details/order_details_state.dart';

class ImagesScreen extends StatelessWidget {
  const ImagesScreen({Key? key, this.orderId}) : super(key: key);
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderDetailsCubit()..getProviderOrderDetails(orderId: orderId),
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state is PostAssociateImagesSuccess) {
            showToast(
                message: 'تم ارفاق الصورة بنجاح', state: ToastStates.SUCCESS);
          } else if (state is PostAssociateImagesFailed) {
            showToast(message: 'فشل ارفاق الصورة ', state: ToastStates.ERROR);
          }

          if (state is AssociateItemsDeleteSuccess) {
            if (state.successModel!.status!) {
              showToast(
                  message: 'تم مسح الصورة بنجاح', state: ToastStates.SUCCESS);
              BlocProvider.of<OrderDetailsCubit>(context, listen: false)
                  .getProviderOrderDetails(orderId: orderId);
            }
          } else if (state is AssociateItemsDeleteFailed) {
            showToast(
                message: 'الرجاء المحاولة مرة اخري', state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          final cubit = OrderDetailsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('الصور'),
              backgroundColor: primaryColor,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                                title: const Text('نوع الصورة'),
                                content: const Text(
                                    'اختر نوع الصورة الذي تريد ارفاقه'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('كاميرا'),
                                    onPressed: () {
                                      cubit
                                          .pickImage(source: ImageSource.camera)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    cubit.pickedImages
                                                        .add(value)
                                                  }
                                              });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('الصور'),
                                    onPressed: () {
                                      cubit
                                          .pickImage(
                                              source: ImageSource.gallery)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    cubit.pickedImages
                                                        .add(value)
                                                  }
                                              });
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    icon: const Icon(Icons.add_a_photo_outlined))
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! ImagePickedStateLoading &&
                  state is! OrderProviderDetailsLoadingState,
              fallback: (context) => const Center(
                child: CupertinoActivityIndicator(),
              ),
              builder: (context) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الصور التي تم رفعها',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (cubit.networkImages.isNotEmpty ||
                      cubit.networkImages != null)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.networkImages.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 3.h,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 1.h),
                          height: 40.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Image(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    cubit.networkImages[index].imagePath ?? ''),
                              ),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: ConditionalBuilder(
                                    condition:
                                        state is! AssociateItemsDeleteLoading,
                                    fallback: (context) => const Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    builder: (context) => IconButton(
                                      onPressed: () {
                                        cubit.deleteAssociateImage(
                                            orderId: orderId,
                                            imageId:
                                                cubit.networkImages[index].id);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 2.h),
                  if (cubit.networkImages.isEmpty ||
                      cubit.networkImages == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'لا يوجد صور حتي الان',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'الصور التي لم يتم رفعها',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (cubit.pickedImages.isNotEmpty)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.pickedImages.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 3.h,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 1.h),
                          height: 40.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: Image(
                            fit: BoxFit.cover,
                            image: FileImage(cubit.pickedImages[index]),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 2.h),
                  if (cubit.pickedImages.isEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'لا يوجد صور حتي الان',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  SizedBox(height: 2.h),
                  if (cubit.pickedImages.isNotEmpty)
                    ConditionalBuilder(
                      condition: state is! PostAssociateImagesLoading,
                      fallback: (context) => const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                      builder: (context) => FractionallySizedBox(
                        widthFactor: 0.7,
                        child: ElevatedButton(
                          onPressed: () {
                            print("orderid :$orderId");
                            // cubit.postAssociateImage(orderId: orderId,itemId: );
                          },
                          child: const Text(
                            'الموافقة علي الصور',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: primaryColor, padding: EdgeInsets.zero),
                        ),
                      ),
                    ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
