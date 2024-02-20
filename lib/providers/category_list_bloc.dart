import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/category/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CategoryListStatus { init, loading, loaded, error }

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc() : super(CategoryListState.init()) {
    on<LoadCategoryListEvent>(_loadCategoryList);
    add(LoadCategoryListEvent());
  }

  Future<void> _loadCategoryList(LoadCategoryListEvent event, emit) async {
    emit(state.copyWith(status: CategoryListStatus.loading));
    List<Category>? res = await CategoryService.getAllCategories();

    if (res == null) {
      emit(state.copyWith(
        status: CategoryListStatus.error,
        errorMessage: '카테고리를 불러오는데 실패했습니다.',
      ));
    } else {
      emit(state.copyWith(status: CategoryListStatus.loaded, result: res));
    }
  }
}

abstract class CategoryListEvent extends Equatable {}

class LoadCategoryListEvent extends CategoryListEvent {
  @override
  List<Object?> get props => [];
}

class CategoryListState extends Equatable {
  final CategoryListStatus status;
  final List<Category> result;
  final String? errorMessage;

  const CategoryListState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  CategoryListState.init() : this(status: CategoryListStatus.init, result: []);

  CategoryListState copyWith({
    CategoryListStatus? status,
    List<Category>? result,
    String? errorMessage,
  }) {
    return CategoryListState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Category> categoryListForFilter() {
    Category allCategory = Category(
      name: '전체',
      subName: '',
      value: null,
      emoji: '',
      tags: const [],
    );
    Tag allTag = const Tag(name: '전체', value: null);
    return [allCategory, ...result]
        .map(
          (Category category) => Category(
            name: category.name,
            subName: category.subName,
            value: category.value,
            emoji: category.emoji,
            tags: [allTag, ...category.tags],
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}