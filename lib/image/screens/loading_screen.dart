import 'package:digital_catalog/image/bloc/select_image_bloc.dart';
import 'package:digital_catalog/image/screens/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SelectImageCubit, SelectImageState>(
        listener: (context, state) {
          if (state.status == SelectImageStatus.error) {
            context.read<SelectImageCubit>().initial();
            Navigator.of(context).pop();
          }
          if (state.status == SelectImageStatus.processed) {
            // navigate to result screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<SelectImageCubit>(),
                  child: const ResultScreen(),
                ),
              ),
              (_) => false,
            );
          }
          if (state.status == SelectImageStatus.emptyResponse) {
            // show cupertino message
            showCupertinoDialog(
              context: context,
              builder: okayDialog,
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Processing...',
                  style: TextStyle(
                    fontSize: 21,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget okayDialog(BuildContext context) => AlertDialog(
        elevation: 55,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        title: const Text(
          'Please Retry',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        content: const Text(
          'Please provide clear picture!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'Montserrat',
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
}
