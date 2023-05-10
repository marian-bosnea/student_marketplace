import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/create_order/create_order_view_bloc.dart';
import 'package:student_marketplace_presentation/features/create_order/create_order_view_state.dart';

import '../../core/theme/theme_data.dart';

class CreateOrderViewPage extends StatelessWidget {
  final SalePostEntity post;
  const CreateOrderViewPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateOrderViewBloc()..init(post),
      child: BlocBuilder<CreateOrderViewBloc, CreateOrderViewState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<CreateOrderViewBloc>(context);

          return Material(
            child: PlatformScaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: PlatformAppBar(
                backgroundColor: Theme.of(context).highlightColor,
                cupertino: ((context, platform) =>
                    CupertinoNavigationBarData(previousPageTitle: 'Post')),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stepper(
                  onStepContinue: () => bloc.goToNextStep(context),
                  onStepCancel: () => bloc.goToPreviousStep(),
                  currentStep: state.currentStep,
                  controlsBuilder: (context, details) => Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: ScreenUtil().setWidth(400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (bloc.canGoToNextStep())
                          PlatformElevatedButton(
                            color: Theme.of(context).splashColor,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5, top: 5),
                            cupertino: ((context, platform) =>
                                CupertinoElevatedButtonData(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)))),
                            onPressed: details.onStepContinue,
                            child: Text(
                              state.currentStep == 2 ? 'Send order' : 'Next',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        if (details.currentStep > 0)
                          PlatformElevatedButton(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5, top: 5),
                            cupertino: ((context, platform) =>
                                CupertinoElevatedButtonData(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)))),
                            onPressed: details.onStepCancel,
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  color: Theme.of(context).splashColor),
                            ),
                          )
                      ],
                    ),
                  ),
                  steps: [
                    Step(
                        isActive: state.currentStep == 0,
                        title: const Text('Product'),
                        content: getProductStepContent(context, state)),
                    Step(
                        isActive: state.currentStep == 1,
                        title: const Text('Address'),
                        content: getAddressStepContent(context, state)),
                    Step(
                        isActive: state.currentStep == 2,
                        title: const Text('Additional information'),
                        content: getAdditionalInfoStepContent(context, state))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getProductStepContent(
      BuildContext context, CreateOrderViewState state) {
    return state.post != null
        ? Material(
            color: Theme.of(context).highlightColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(550),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: ScreenUtil().setHeight(300),
                      child: Image.memory(
                        state.post!.images.first,
                      )),
                  SizedBox(
                    width: ScreenUtil().setWidth(400),
                    child: Text(
                      state.post!.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(400),
                    child: Text(state.post!.categoryName!,
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(400),
                    child: Text(
                      "Price: ${state.post!.price} RON",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget getAddressStepContent(
      BuildContext context, CreateOrderViewState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil().setHeight(250),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.addresses.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () => BlocProvider.of<CreateOrderViewBloc>(context)
                    .setAddressId(state.addresses.elementAt(index).id!),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Material(
                    color: Theme.of(context).highlightColor,
                    elevation: state.selectedAddressId ==
                            state.addresses.elementAt(index).id
                        ? 0
                        : 1,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: ScreenUtil().setHeight(250),
                      width: ScreenUtil().setWidth(300),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              state.addresses.elementAt(index).name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              state.addresses.elementAt(index).county,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              state.addresses.elementAt(index).city,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              state.addresses.elementAt(index).description,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  Widget getAdditionalInfoStepContent(
      BuildContext context, CreateOrderViewState state) {
    return PlatformTextField(
      maxLines: 10,
      cupertino: (context, platform) => CupertinoTextFieldData(
          decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)))),
      onSubmitted: (text) =>
          BlocProvider.of<CreateOrderViewBloc>(context).setNotes(text),
    );
  }
}
