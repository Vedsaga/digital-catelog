import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import 'package:digital_catalog/image/model/descriptor_model.dart';

part 'select_image_state.dart';

class SelectImageCubit extends Cubit<SelectImageState> {
  SelectImageCubit()
      : super(
          SelectImageState(),
        );
  late List<Descriptor> descriptors = [];

  // this function is used to select image from camera
  Future imageFromCamera() async {
    emit(state.copyWith(status: SelectImageStatus.selecting));
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      // if file is null then it means user has cancelled the image selection
      if (file == null) {
        emit(
          state.copyWith(
            status: SelectImageStatus.initial,
          ),
        );
        return null;
      }
      final returnImage = File(
        file.path,
      );
      emit(
        state.copyWith(
          fileName: file.path.split('/').last,
          filePath: file.path,
          image: returnImage,
          status: SelectImageStatus.selected,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SelectImageStatus.error));
    }
  }

  // this function is used to select image from gallery
  Future imageFromGallery() async {
    emit(
      state.copyWith(
        status: SelectImageStatus.selecting,
      ),
    );
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      // if file is null then it means user has cancelled the image selection
      if (file == null) {
        emit(
          state.copyWith(
            status: SelectImageStatus.initial,
          ),
        );
        return null;
      }
      final returnImage = File(file.path);
      emit(
        state.copyWith(
          fileName: file.path.split('/').last,
          filePath: file.path,
          image: returnImage,
          status: SelectImageStatus.selected,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SelectImageStatus.error));
    }
  }

  // make a function which upload the image to "https://mandi.succinct.in/skus/image_search"
  // and get the response
  // if response is success then emit the state with status success
  // else emit the state with status error
  Future uploadImage() async {
    emit(
      state.copyWith(
        status: SelectImageStatus.processing,
      ),
    );
    try {
      FormData formData = FormData.fromMap(
        {
          "file": await MultipartFile.fromFile(
            state.filePath!,
            filename: state.fileName,
          ),
        },
      );
      emit(
        state.copyWith(
          status: SelectImageStatus.processing,
        ),
      );
      Response response = await Dio().post(
        'https://mandi.succinct.in/skus/image_search',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        // extract the descriptors and price from the response

        Map<String, dynamic> content =
            Map<String, dynamic>.from(response.data[0]['descriptor']);
        Map<String, dynamic> price =
            Map<String, dynamic>.from(response.data[0]['price']);

        // add the price to the descriptors
        content.addAll(price);
        descriptors.add(
          Descriptor.fromMap(
            content,
          ),
        );

        emit(
          state.copyWith(
            response: descriptors,
            status: SelectImageStatus.processed,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SelectImageStatus.emptyResponse,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SelectImageStatus.error,
        ),
      );
    }
  }

  // make a function which set the status to initial
  void initial() {
    emit(
      state.copyWith(
        status: SelectImageStatus.initial,
        image: null,
      ),
    );
  }
}
