import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:digital_catalog/image/bloc/select_image_bloc.dart';
import 'package:digital_catalog/image/screens/loading_screen.dart';

List<CameraDescription> cameras = [];
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BlocProvider<SelectImageCubit>(
        create: (context) => SelectImageCubit(),
        child: MyHomePage(deviceCameras: cameras),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.deviceCameras,
  }) : super(key: key);
  final List<CameraDescription> deviceCameras;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File? image;

  @override
  void initState() {
    super.initState();
  }

  Future _imageFromCamera() async {
    await context.read<SelectImageCubit>().imageFromCamera();
  }

  Future _imageFromGallery() async {
    await context.read<SelectImageCubit>().imageFromGallery();
  }

  // make sure to dispose the stream when the widget is disposed
  @override
  void dispose() {
    super.dispose();
  }

  _MyHomePageState({this.image}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Catalog'),
      ),
      body: BlocConsumer<SelectImageCubit, SelectImageState>(
        listener: (context, state) {
          if (state.status == SelectImageStatus.selected) {
            setState(() {
              image = state.image;
            });
          }
          if (state.status == SelectImageStatus.processing) {
            // navigation to ProcessingScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<SelectImageCubit>(),
                  child: const ProcessingScreen(),
                ),
              ),
            );
          }
          if (state.status == SelectImageStatus.cancelled) {
            Navigator.pop(context);
            setState(() {});
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if image is null show Text
                if (state.status == SelectImageStatus.initial)
                  const SizedBox(
                    height: 200,
                  ),
                if (state.status == SelectImageStatus.initial)
                  const Text(
                    'Please provide image',
                    // add font as parameter
                    style: TextStyle(
                      fontSize: 21,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (state.status == SelectImageStatus.selected && kIsWeb)
                  Image.network(
                    state.filePath!,
                  ),
                if (state.status == SelectImageStatus.selected && !kIsWeb)
                  Image.file(
                    state.image!,
                  ),
                if (state.status == SelectImageStatus.selected)
                  // add confirm
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.125,
                      vertical: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // set the state.status to initial
                            context.read<SelectImageCubit>().initial();
                            setState(() {
                              image = null;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                            // make the button round
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          child: const SizedBox(
                            width: 89,
                            height: 46,
                            child: Center(
                              child: Text(
                                'Remove',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 21,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // set the state.status to initial
                            context.read<SelectImageCubit>().uploadImage();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green,
                            ),
                            // make the button round
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          child: const SizedBox(
                            width: 89,
                            height: 46,
                            child: Center(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (state.status == SelectImageStatus.initial)
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45,
                      left: MediaQuery.of(context).size.width * 0.125,
                      bottom: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (!kIsWeb)
                            // make two buttons
                            ElevatedButton(
                              onPressed: () {
                                _imageFromCamera();
                              },
                              child: const SizedBox(
                                width: 89,
                                height: 46,
                                child: Center(
                                  child: Text(
                                    'Camera',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            width: 21,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _imageFromGallery();
                            },
                            child: const SizedBox(
                              width: 89,
                              height: 46,
                              child: Center(
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
