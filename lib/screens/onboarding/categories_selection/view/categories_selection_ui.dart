import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/screens/onboarding/bloc/onboarding_bloc.dart';

class CategorySelection extends StatelessWidget {
  const CategorySelection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<OnboardingBloc>(context);
    context.read<OnboardingBloc>().add(LoadCategoriesEvent());
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Select Your Favorite Categories',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (previous, current) =>
                  current is CategoriesLoadingState ||
                  current is CategoriesLoadedState ||
                  current is CategorySelectedState,
              builder: (context, state) {
                return state is CategoriesLoadingState
                    ? CommonWidget.getLoader()
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: bloc.categories.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<OnboardingBloc>().add(CategorySelectedEvent(index));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: bloc.categories[index].isSelected
                                          ? Colors.amber.withOpacity(0.5)
                                          : Colors.grey.withOpacity(0.2),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      bloc.categories[index].category!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 22),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 5,
                                  top: 5,
                                  child: bloc.categories[index].isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : Container())
                            ],
                          );
                        },
                      );
              },
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
