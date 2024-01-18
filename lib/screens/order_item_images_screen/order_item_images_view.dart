import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/paint_on_image.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/styles/color.dart';

import 'cubit.dart';

class OrderItemImagesScreen extends StatefulWidget {
  String? itemName;
  String? statusName;
  int? itemId;
  int? orderId;

  bool? idEdit;
  OrderItemImagesScreen(
      {Key? key,
      required this.itemName,
      this.idEdit = false,
      this.statusName,
      this.itemId,
      this.orderId})
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
    double? screenWidth = MediaQuery.of(context).size.width;
    var itemsCount = (screenWidth / 190).floor();
    return BlocConsumer<OrderItemImagesCubit, OrderItemImagesState>(
      listener: (context, state) {
        if (state is OrderItemImagesSuccessState) {
          showToast(message: 'تمت العملية بنجاح', state: ToastStates.SUCCESS);
        } else if (state is OrderItemImagesFailedState) {
          showToast(message: 'حدث خطأ !!', state: ToastStates.ERROR);
        } else if (state is OrderItemImagesUpLoadingState) {
          showToast(
              message: 'يتم رفع الصوره الان ، يمكنك اضافة صور اخري',
              state: ToastStates.ERROR);
        }
        else if (state is OrderItemCommentLoadingState) {
          showToast(
              message: "يتم اضافة تعليق",
              state: ToastStates.ERROR);
        }
        else if (state is OrderItemCommentSuccessState) {
          showToast(
              message: "تم اضافة التعليق بنجاح",
              state: ToastStates.ERROR);
        }

        else if (state is OrderItemRemoveImagesLoadingState) {
          showToast(
              message: "جاري حذف الصوره من العنصر",
              state: ToastStates.ERROR);
        }
        else if (state is OrderItemRemoveImagesSuccessState) {
          showToast(

              message: "تم الحذف",
              state: ToastStates.ERROR);
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
              SizedBox(
                width: 10,
              ),
              // cubit.imagesLocalFiles.isNotEmpty
              //     ? ElevatedButton(
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all(
              //                 state is OrderItemImagesLoadingState
              //                     ? Colors.grey[300]
              //                     : Colors.white)),
              //         onPressed: state is OrderItemImagesLoadingState
              //             ? () {}
              //             : () async {
              //                 // await cubit
              //                 //     .postAssociateImage(
              //                 //         orderId: widget.orderId,
              //                 //         itemId: widget.itemId)
              //                 //     .then((value) {
              //                 //   Navigator.pop(context);
              //                 // });
              //               },
              //         child: Text(
              //           'رفع الصور',
              //           style: TextStyle(color: primaryColor),
              //         ))
              //     : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child:
                cubit.imagesLocalFiles.isNotEmpty || cubit.remoteList.isNotEmpty
                    ? GridView(
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: itemsCount,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                        ),
                        children: [
                          // ...cubit.imagesLocalFiles
                          //     .map((e) => Stack(
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           PaintOnImage(
                          //                               image: e.imageFile),
                          //                     ));
                          //               },
                          //               child: ClipRRect(
                          //                 borderRadius:
                          //                     BorderRadius.circular(26),
                          //                 child: FadeInImage(
                          //                   fit: BoxFit.fill,
                          //                   placeholder: const AssetImage(
                          //                     'assets/images/q.png',
                          //                   ),
                          //                   image: FileImage(
                          //                     e.imageFile ??
                          //                         File('dummmy_path'),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //             widget.statusName ==
                          //                         'provider_received_all' ||
                          //                     widget.statusName ==
                          //                         'provider_received'
                          //                 ? Positioned(
                          //                     top: 5,
                          //                     left: 5,
                          //                     child: InkWell(
                          //                       onTap: () {
                          //                         showAreYouSureDialoge(
                          //                             context: context,
                          //                             yesFun: () {
                          //                               cubit
                          //                                   .removeImageFromLocalStorageList(
                          //                                       e.imageFile);
                          //                               Navigator.pop(
                          //                                   context);
                          //                             },
                          //                             noFun: () {
                          //                               Navigator.pop(
                          //                                   context);
                          //                             });
                          //                       },
                          //                       child: CircleAvatar(
                          //                         radius: 10.sp,
                          //                         backgroundColor:
                          //                             primaryColor,
                          //                         child: const Icon(
                          //                           Icons.close,
                          //                           color: Colors.white,
                          //                         ),
                          //                       ),
                          //                     ))
                          //                 : const SizedBox(),
                          //             Positioned(
                          //                 bottom: 20,
                          //                 left: 10,
                          //                 child: ElevatedButton(
                          //                   style: ButtonStyle(
                          //                       backgroundColor:
                          //                           MaterialStateProperty.all(
                          //                               primaryColor)),
                          //                   onPressed: () {
                          //                     TextEditingController
                          //                         commentController =
                          //                         TextEditingController(
                          //                             text: e.comment);
                          //                     showDialog(
                          //                         context: context,
                          //                         builder: (context) =>
                          //                             AlertDialog(
                          //                               title: const Text(
                          //                                   'اضافة تعليقات'),
                          //                               content:
                          //                                   TextFormField(
                          //                                 controller:
                          //                                     commentController,
                          //                                 maxLines: 2,
                          //                                 textDirection:
                          //                                     TextDirection
                          //                                         .rtl,
                          //                                 decoration: const InputDecoration(
                          //                                     hintText:
                          //                                         'أضف تعليقك ..',
                          //                                     hintTextDirection:
                          //                                         TextDirection
                          //                                             .rtl),
                          //                               ),
                          //                               actions: [
                          //                                 TextButton(
                          //                                     onPressed: () {
                          //                                       Navigator.pop(
                          //                                           context);
                          //                                       debugPrint(
                          //                                           'Cancel');
                          //                                     },
                          //                                     child: const Text(
                          //                                         'تراجع')),
                          //                                 TextButton(
                          //                                     onPressed:
                          //                                         () async {
                          //                                       Navigator.pop(
                          //                                           context);
                          //                                       e.comment =
                          //                                           commentController
                          //                                               .text;
                          //                                     },
                          //                                     child:
                          //                                         const Text(
                          //                                             'حفظ')),
                          //                               ],
                          //                             ));
                          //                   },
                          //                   child: const Text(
                          //                     'اضافة تعليق',
                          //                     style: TextStyle(
                          //                         color: Colors.white),
                          //                   ),
                          //                 ))
                          //           ],
                          //         ))
                          //     .toList(),
                          ...cubit.remoteList
                              .map((e) => Stack(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaintOnImage(url: e.url,itemId: widget.itemId,orderId: widget.orderId),
                                              ));
                                          },
                                          child: e.id != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                  child: FadeInImage(
                                                    height: 30.h,
                                                    fit: BoxFit.fill,
                                                    placeholder: const AssetImage(
                                                        'assets/images/q.png'),
                                                    image: NetworkImage(
                                                      e.url ?? '',
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                  child: Image.asset(
                                                    'assets/images/loading.gif',
                                                    fit: BoxFit.fitHeight,
                                                    height: 30.h,
                                                  ),
                                                )),
                                      widget.statusName ==
                                                  'provider_received_all' ||
                                              widget.statusName ==
                                                  'provider_received'
                                          ? Positioned(
                                              top: 5,
                                              left: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  e.url != ''
                                                      ? showAreYouSureDialoge(
                                                          context: context,
                                                          yesFun: e.url != ''
                                                              ? () {
                                                                  cubit.deleteAssociateImage(
                                                                      imageId:
                                                                          e.id,
                                                                      orderId:
                                                                          widget
                                                                              .orderId);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              : () {},
                                                          noFun: () {
                                                            Navigator.pop(
                                                                context);
                                                          })
                                                      : () {};
                                                },
                                                child: CircleAvatar(
                                                  radius: 10.sp,
                                                  backgroundColor: e.url != ''
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ))
                                          : const SizedBox(),
                                      Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              
                                                backgroundColor:
                                                    MaterialStateProperty.all(primaryColor )
                                                            ),
                                            onPressed: state
                                                    is OrderItemImagesLoadingState
                                                ? () {}
                                                : () {
                                                    TextEditingController
                                                        commentController =
                                                        TextEditingController(
                                                            text: e.comment);
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
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
                                                                            TextDirection.rtl),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
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
                                                                          cubit.addComment(
                                                                              imageId: e.id,
                                                                              orderId: widget.orderId,
                                                                              comment: commentController.text);
                                                                          Navigator.pop(
                                                                              context);
                                                                          // e.comment =
                                                                          //     commentController
                                                                          //         .text;
                                                                        },
                                                                        child: const Text(
                                                                            'حفظ')),
                                                                  ],
                                                                ));
                                                  },
                                            child: const Text(
                                              'تعليق',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))
                                    ],
                                  ))
                              .toList(),
                              // SizedBox(height: 30,)
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: widget.statusName == 'provider_received_all' ||
                  widget.statusName == 'provider_received'
              ? SizedBox(
                  width: 15.w,
                  // height: 20.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.cyanAccent,
                    onPressed: () async {
                      await cubit.pickImageFromCamera(
                          itemId: widget.itemId, orderId: widget.orderId);
                      // setState(() {});
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Text('اضافه صوره'),
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
