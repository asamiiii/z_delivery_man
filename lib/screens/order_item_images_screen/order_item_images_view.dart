import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/paint_on_image.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/styles/color.dart';

import 'cubit.dart';

class OrderItemImagesScreen extends StatefulWidget {
  String? itemName;
  String? statusName;

  bool? idEdit;
  OrderItemImagesScreen(
      {Key? key, required this.itemName, this.idEdit = false, this.statusName})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderItemImagesScreenState createState() => _OrderItemImagesScreenState();
}

class _OrderItemImagesScreenState extends State<OrderItemImagesScreen> {
  @override
  void initState() {
    final cubit = OrderItemImagesCubit.get(context);
    cubit.imagesLocalFiles.clear();
    cubit.getOrderItemImages(); //* Empty Fun
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderItemImagesCubit, OrderItemImagesState>(
      listener: (context, state) {
        if (state is OrderItemImagesSuccessState) {
          showToast(message: 'تمت العملية بنجاح', state: ToastStates.SUCCESS);
        } else if (state is OrderItemImagesFailedState) {
          showToast(message: 'حدث خطأ !!', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final cubit = OrderItemImagesCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.itemName ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              SizedBox(width: 10,),
              cubit.imagesLocalFiles.isNotEmpty
                  ? ElevatedButton(
                      onPressed: () async {
                        await cubit.postAssociateImage(orderId: 1);
                        // await cubit.uploadImagesToStorage();
                        // await cubit.sendOrderItemImages();
                        Navigator.pop(context);

                        //
                      },
                      child:  Text(
                        'رفع الصور',
                        style: TextStyle(color: primaryColor),
                      ))
                  : const SizedBox(),
                  const SizedBox(width: 10,),
            ],
          ),
          body: state is OrderItemImagesLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: cubit.imagesLocalFiles.isNotEmpty ||
                          cubit.remoteList.isNotEmpty
                      ? GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                          ),
                          children: [
                            ...cubit.imagesLocalFiles
                                .map((e) => Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaintOnImage(
                                                          image: e.imageFile),
                                                ));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            child: FadeInImage(
                                              fit: BoxFit.fill,
                                              placeholder: const AssetImage(
                                                'assets/images/q.png',
                                              ),
                                              image: FileImage(
                                                e.imageFile ??
                                                    File('dummmy_path'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        widget.statusName ==
                                                    'provider_received_all' ||
                                                widget.statusName ==
                                                    'provider_received'
                                            ? Positioned(
                                                top: 5,
                                                left: 5,
                                                child: InkWell(
                                                  onTap: () {
                                                    showAreYouSureDialoge(
                                                        context: context,
                                                        yesFun: () {
                                                          cubit
                                                              .removeImageFromLocalStorageList(
                                                                  e.imageFile);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        noFun: () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 10.sp,
                                                    backgroundColor:
                                                        primaryColor,
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ))
                                            : const SizedBox(),
                                        Positioned(
                                            bottom: 20,
                                            left: 10,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColor)),
                                              onPressed: () {
                                                TextEditingController
                                                    commentController =
                                                    TextEditingController(
                                                        text: e.comment);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'اضافة تعليقات'),
                                                          content:
                                                              TextFormField(
                                                            controller:
                                                                commentController,
                                                            maxLines: 2,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            decoration: const InputDecoration(
                                                                hintText:
                                                                    'أضف تعليقك ..',
                                                                hintTextDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  debugPrint(
                                                                      'Cancel');
                                                                },
                                                                child: const Text(
                                                                    'تراجع')),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  e.comment =
                                                                      commentController
                                                                          .text;
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'حفظ')),
                                                          ],
                                                        ));
                                              },
                                              child: const Text(
                                                'اضافة تعليق',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ))
                                .toList(),
                            ...cubit.remoteList
                                .map((e) => Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           PaintOnImage(image: e),
                                            //     ));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              placeholder: const AssetImage(
                                                  'assets/images/q.png'),
                                              image: NetworkImage(
                                                e,
                                              ),
                                            ),
                                          ),
                                        ),
                                        widget.statusName ==
                                                    'provider_received_all' ||
                                                widget.statusName ==
                                                    'provider_received'
                                            ? Positioned(
                                                top: 5,
                                                left: 5,
                                                child: InkWell(
                                                  onTap: () {
                                                    showAreYouSureDialoge(
                                                        context: context,
                                                        yesFun: () {
                                                          cubit
                                                              .removeImageFromFireStorage(
                                                                  e);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        noFun: () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 10.sp,
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ))
                                            : const SizedBox()
                                      ],
                                    ))
                                .toList()
                          ],
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 100,
                                color: primaryColor,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text('لا يوجد صور متاحة'),
                            ],
                          ),
                        ),
                ),
          floatingActionButton: widget.statusName == 'provider_received_all' ||
                  widget.statusName == 'provider_received'
              ? SizedBox(
                  width: 40.w,
                  // height: 20.h,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await cubit.pickImageFromCamera();
                      setState(() {});
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('اضافه صوره'),
                        Icon(
                          Icons.add_a_photo_outlined,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
