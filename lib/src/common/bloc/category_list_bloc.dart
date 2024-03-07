import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:dodal_app/src/common/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc() : super(CategoryListState.init()) {
    on<LoadCategoryListEvent>(_loadCategoryList);
    add(LoadCategoryListEvent());
  }

  Future<void> _loadCategoryList(LoadCategoryListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      List<Category> res = await CategoryRepository.getAllCategories();
      emit(state.copyWith(status: CommonStatus.loaded, result: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '카테고리를 불러오는데 실패했습니다.',
      ));
    }
  }
}

abstract class CategoryListEvent extends Equatable {}

class LoadCategoryListEvent extends CategoryListEvent {
  @override
  List<Object?> get props => [];
}

class CategoryListState extends Equatable {
  final CommonStatus status;
  final List<Category> result;
  final String? errorMessage;

  const CategoryListState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  CategoryListState.init() : this(status: CommonStatus.init, result: []);

  CategoryListState copyWith({
    CommonStatus? status,
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
    Category allCategory = const Category(
      name: '전체',
      subName: '',
      value: null,
      emoji: '',
      tags: [],
    );
    Tag allTag = const Tag(name: '전체', value: null);
    return [allCategory, ...result]
        .map(
          (Category category) => Category(
            name: category.name,
            subName: category.subName,
            value: category.value,
            emoji: category.emoji,
            tags: [allTag, ...category.tags!],
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
