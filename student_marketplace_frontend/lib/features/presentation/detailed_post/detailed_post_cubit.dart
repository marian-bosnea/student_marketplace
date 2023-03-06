import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_state.dart';

class DetailedPostCubit extends Cubit<DetailedPostPageState> {
  DetailedPostPageState state = DetailedPostPageState();

  DetailedPostCubit() : super(DetailedPostPageState());

  setSelectedImage(int index) {
    state = state.copyWith(selectedImageIndex: index);
    emit(state);
  }

  resetContext() {
    state = DetailedPostPageState();
  }
}
