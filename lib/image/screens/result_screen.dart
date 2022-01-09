import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:digital_catalog/image/bloc/select_image_bloc.dart';
import 'package:digital_catalog/main.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        // add a back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<SelectImageCubit>(
                  create: (context) => SelectImageCubit(),
                  child: const MyHomePage(
                    deviceCameras: [],
                  ),
                ),
              ),
              (_) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<SelectImageCubit, SelectImageState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Card(
              child: SizedBox(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      child: SizedBox(
                        width: 89,
                        height: 89,
                        child: Image.network(state.response![0].imageURL!),
                      ),
                    ),
                    Text(
                      state.response![0].name!,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
