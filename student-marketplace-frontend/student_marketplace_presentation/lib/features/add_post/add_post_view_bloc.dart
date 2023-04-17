import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/sale_post_model.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_business_logic/domain/usecases/product_category/get_all_categories_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/update_post_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/sale_post/upload_post_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/core/utils/date_formater.dart';
import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/posts_view/posts_view_bloc.dart';

import '../../core/config/injection_container.dart';
import 'add_post_view_state.dart';

class AddPostViewBloc extends Cubit<AddPostState> {
  final GetAllCategoriesUsecase getAllCategoriesUsecase;
  final UploadPostUsecase uploadPostUsecase;
  late UpdatePostUsecase updatePostUsecase;

  AddPostViewBloc({
    required this.uploadPostUsecase,
    required this.getAllCategoriesUsecase,
  }) : super(const AddPostState()) {
    updatePostUsecase =
        UpdatePostUsecase(operations: sl.call(), authRepository: sl.call());
  }
  Future<void> init(SalePostEntity? post) async {
    await fetchAllCategories();
    if (post != null) {
      final postCategory = post.categoryName;
      int categoryId = -1;

      for (var c in state.categories) {
        if (c.name == postCategory) {
          categoryId = c.id;
        }
      }

      emit(state.copyWith(
          isUpdating: true,
          title: post.title,
          description: post.description,
          images: post.images,
          postId: post.postId,
          categoryId: categoryId,
          price: post.price));
    }
  }

  Future<void> setTitleValue(String value) async {
    emit(state.copyWith(title: value));
  }

  Future<void> setDescriptionValue(String value) async {
    emit(state.copyWith(description: value));
  }

  Future<void> setPriceValue(String value) async {
    emit(state.copyWith(price: value));
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

    emit(state.copyWith(images: previousImages));
  }

  Future<void> upload(BuildContext context) async {
    if (state.isUpdating) {
      updatePostUsecase(PostParam(
          post: SalePostModel(
              price: state.price,
              title: state.title,
              images: state.images,
              postId: state.postId,
              description: state.description,
              categoryId: state.categoryId)));

      return;
    }

    await uploadPostUsecase(PostParam(
        post: SalePostModel(
            categoryId: state.categoryId,
            description: state.description,
            images: state.images,
            ownerId: 0,
            price: state.price,
            postId: state.postId,
            postingDate: getCurrentDateFormatted(),
            title: state.title)));

    Navigator.of(context).pushReplacementNamed(PageNames.homePage);
  }

  Future<void> setCategoryValue(int categoryId) async {
    emit(state.copyWith(categoryId: categoryId));
  }

  Future<void> fetchAllCategories() async {
    final result = await getAllCategoriesUsecase(NoParams());
    if (result is Left) return;

    final categories = (result as Right).value;

    emit(state.copyWith(categories: categories));
  }

  setCurrentStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  goToNextStep(BuildContext context) {
    if (state.currentStep == 4) {
      upload(context);
      BlocProvider.of<PostViewBloc>(context).fetchAllPosts();
      BlocProvider.of<HomeViewBloc>(context).goToHome();
      Navigator.of(context).pushReplacementNamed(PageNames.homePage);

      return;
    }
    final nextStep = state.currentStep + 1;
    emit(state.copyWith(currentStep: nextStep));
  }

  goToPreviousStep() {
    if (state.currentStep > 0) {
      final prevStep = state.currentStep - 1;
      emit(state.copyWith(currentStep: prevStep));
    }
  }

  bool canGoToNextStep() {
    if (state.currentStep == 0 && state.title.length > 3) return true;
    if (state.currentStep == 1 && state.description.length > 3) {
      return true;
    }

    if (state.currentStep == 2 && state.price.isNotEmpty) {
      return true;
    }

    if (state.currentStep == 3 && state.categoryId != -1) {
      return true;
    }

    if (state.currentStep == 4 && state.images.isNotEmpty) {
      return true;
    }

    return false;
  }
}
