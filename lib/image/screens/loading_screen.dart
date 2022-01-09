import 'package:digital_catalog/image/bloc/select_image_bloc.dart';
import 'package:digital_catalog/image/screens/result_screen.dart';
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
            Navigator.of(context).pop();
            context.read<SelectImageCubit>().initial();
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
}
