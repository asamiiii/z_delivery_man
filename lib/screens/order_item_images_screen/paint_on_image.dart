import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/cubit.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/order_item_images_view.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';

class PaintOnImage extends StatefulWidget {
  File? image;
  PaintOnImage({Key? key, required this.image}) : super(key: key);

  @override
  _PaintOnImageState createState() => _PaintOnImageState();
}

class _PaintOnImageState extends State<PaintOnImage> {
  bool isloading = false;
  

 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderItemImagesCubit,OrderItemImagesState>(
      listener: (context, state) {
        
      },
      builder:(context, state) {
        final cubit = OrderItemImagesCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          actions: [
            SizedBox(width: 1.w,),
            InkWell(
              onTap: state is OrderItemImagesLoadingState? (){} : () async{
                await cubit.saveImage(context,widget.image!);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Text('Save changes',style: TextStyle(color: Colors.white),),
                      SizedBox(width: 2.w,),
            const Icon(Icons.save_alt),
                ],
              ),
            ),
        
          SizedBox(width: 3.w,),
          ],
        ),
        body: state is OrderItemImagesSuccessState ? ImagePainter.file(
          widget.image!,
          key: cubit.imageKey,
          scalable: true,
          initialStrokeWidth: 5,
          textDelegate: TextDelegate(),
          initialColor: Colors.green,
          initialPaintMode: PaintMode.line,
        ):const Center(child: CircularProgressIndicator()),
      );},
    );
  }
}
