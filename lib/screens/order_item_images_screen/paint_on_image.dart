import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/cubit.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';

class PaintOnImage extends StatefulWidget {
  String? url;
  int? orderId;
  int? itemId;
  int? imageId;
  PaintOnImage({Key? key, required this.url, required this.itemId, required this.orderId,required this.imageId}) : super(key: key);

  @override
  _PaintOnImageState createState() => _PaintOnImageState();
}

class _PaintOnImageState extends State<PaintOnImage> {
  bool isloading = false;

  File? imageFile;
  
@override
  void initState() {
    // final cubit = OrderItemImagesCubit.get(context);
    //     WidgetsBinding.instance.addPostFrameCallback((_) async {
    //           imageFile =await  cubit.downloadAndSaveImage(widget.url ?? '');
    //     });

    super.initState();
  }
 

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
                Navigator.pop(context);
                await cubit.saveImage(itemId:widget.itemId,orderId:  widget.orderId,imageId: widget.imageId);
              // ignore: use_build_context_synchronously
              
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
        body: 
        state is !PaintLoading  ? ImagePainter.network(
          widget.url??'',
          key: cubit.imageKey,
          scalable: true,
          initialStrokeWidth: 5,
          textDelegate: TextDelegate(),
          initialColor: Colors.green,
          initialPaintMode: PaintMode.freeStyle,
        ):
        const Center(child: CircularProgressIndicator()),
      );},
    );
  }
}
