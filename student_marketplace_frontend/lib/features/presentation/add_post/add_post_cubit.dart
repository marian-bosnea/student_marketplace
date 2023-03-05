import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_marketplace_frontend/core/usecases/usecase.dart';
import 'package:student_marketplace_frontend/features/data/models/sale_post_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/sale_post/upload_post_usecase.dart';
import 'package:student_marketplace_frontend/features/presentation/add_post/add_post_page_state.dart';

class AddPostCubit extends Cubit<AddPostPageState> {
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final UploadPostUsecase uploadPostUsecase;

  AddPostCubit(
      {required this.uploadPostUsecase, required this.getAllCategoriesUsecase})
      : super(const AddPostPageState());
  AddPostPageState state = AddPostPageState();

  Future<void> setTitleValue(String value) async {
    state = state.copyWith(titleValue: value);
  }

  Future<void> setDescriptionValue(String value) async {
    state = state.copyWith(descriptionValue: value);
  }

  Future<void> setPriceValue(String value) async {
    state = state.copyWith(price: value);
  }

  Future<void> setPhotos() async {
    final ImagePicker imagePicker = ImagePicker();
    List<Uint8List> imageFileList = [];
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      for (var img in selectedImages) {
        final bytes = await img.readAsBytes();
        imageFileList.add(bytes);
      }
    }

    List<Uint8List> previousImages = [];
    previousImages.addAll(state.images);
    previousImages.addAll(imageFileList);

    state = state.copyWith(images: previousImages);
    emit(state);
  }

  Future<void> uploadPost() async {
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    uploadPostUsecase(PostParam(
        post: SalePostModel(
            categoryId: state.categoryId,
            description: state.descriptionValue,
            images: state.images,
            ownerId: '0',
            price: state.price,
            postingDate: dateSlug,
            title: state.titleValue)));
  }

  Future<void> setCategoryValue(String categoryId) async {
    state = state.copyWith(categoryId: categoryId);
  }

  Future<void> fetchAllCategories() async {
    final result = await getAllCategoriesUsecase(NoParams());
    if (result is Left) return;

    final categories = (result as Right).value;

    state = state.copyWith(categories: categories);
    emit(state);
  }
}
