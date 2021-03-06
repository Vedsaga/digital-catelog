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
              elevation: 5,
              child: FittedBox(
                child: Row(
                  children: [
                    Column(
                      children: <Widget>[
                        SizedBox(
                          child: SizedBox(
                            width: 144,
                            height: 144,
                            child: Image.network(state.response![0].imageURL!),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Text(
                            state.response![0].name!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 27, 29, 31),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Text.rich(
                            TextSpan(
                              text: 'Price: ',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Color.fromARGB(255, 75, 82, 85),
                              ),
                              children: [
                                const TextSpan(
                                  text: 'INR ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color.fromARGB(255, 43, 195, 255),
                                  ),
                                ),
                                TextSpan(
                                  text: '${state.response![0].price}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Color.fromARGB(255, 25, 26, 27),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                      ],
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
