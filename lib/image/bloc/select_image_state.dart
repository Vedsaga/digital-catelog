part of 'select_image_bloc.dart';

class SelectImageState with EquatableMixin {
  late final File? image;
  late final SelectImageStatus status;
  late final String? filePath;
  late final String? fileName;
  late final List<Descriptor>? response;

  SelectImageState({
    this.image,
    this.status = SelectImageStatus.initial,
    this.filePath,
    this.fileName,
    this.response,
  });

  @override
  List<Object?> get props => [image, status, filePath, fileName];

  SelectImageState copyWith({
    File? image,
    SelectImageStatus? status,
    String? filePath,
    String? fileName,
    List<Descriptor>? response,
  }) {
    return SelectImageState(
      image: image ?? this.image,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      response: response ?? this.response,
    );
  }
}

enum SelectImageStatus {
  initial,
  selecting,
  cancelled,
  selected,
  capturing,
  captured,
  processing,
  processed,
  error,
  emptyResponse,
}
