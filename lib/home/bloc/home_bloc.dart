import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeSelectPictureEvent>(homeSelectPictureEvent);
  }

  Future<FutureOr<void>> homeSelectPictureEvent(
      HomeSelectPictureEvent event, Emitter<HomeState> emit) async {
    final imaged = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imaged != null) {
      emit(HomeSelectPictureState(File(imaged.path)));
    }
  }
}
