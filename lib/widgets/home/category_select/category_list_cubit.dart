import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/category/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CategoryListStatus { init, loading, loaded, error }

Category CATEGORY_OF_ALL = Category(
  name: '전체',
  subName: '',
  value: null,
  emoji: '',
  tags: [const Tag(name: '전체', value: null)],
);

class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit() : super(CategoryListState.init()) {
    _loadCategory();
  }

  _loadCategory() async {
    emit(state.copyWith(status: CategoryListStatus.loading));
    final categoryList = await CategoryService.getAllCategories();
    if (categoryList == null) return;
    emit(state.copyWith(
      status: CategoryListStatus.loaded,
      result: categoryList,
    ));
  }
}

class CategoryListState extends Equatable {
  final CategoryListStatus status;
  final List<Category> result;

  const CategoryListState({
    required this.status,
    required this.result,
  });

  CategoryListState.init()
      : this(
          status: CategoryListStatus.init,
          result: [],
        );

  CategoryListState copyWith({
    CategoryListStatus? status,
    List<Category>? result,
  }) {
    return CategoryListState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, result];
}
