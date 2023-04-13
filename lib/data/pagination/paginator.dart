import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:meta/meta.dart';

typedef Future<RepositoryResult<MPage<ItemType>>> PageRepo<ItemType>(
    int page, int pageSize);

class Paginator<ItemType> {
  final PageRepo pageRepo;

  int curPage = 1;
  int pageSize;

  bool _isLoading = false;
  bool _hasReachedMax = false;

  bool get canLoadMore => !_isLoading && !_hasReachedMax;

  List<ItemType> _loadedItems = <ItemType>[];

  List<ItemType> get loadedItems => List<ItemType>.from(_loadedItems);

  Paginator({this.pageRepo, this.pageSize = 20}) {
    _setInitialState();
  }

  void _setInitialState() {
    curPage = 1;
    _loadedItems.clear();
    _isLoading = false;
    _hasReachedMax = false;
  }

  void addItem(ItemType item) {
    _loadedItems.insert(0, item);
    _loadedItems.removeLast();
  }

  Future<bool> deleteItem(ItemType item) async {
    const int perPageCount = 1;
    final loadedPage =
        await _loadPage(_loadedItems.length, perPage: perPageCount);
    if (loadedPage != null) {
      _hasReachedMax = loadedPage.data.length < perPageCount;
      _loadedItems.remove(item);
      _loadedItems.addAll(loadedPage.data);
      return true;
    }

    return false;
  }

  Stream<RepositoryResult<MPage<ItemType>>> reloadRata() async* {
    _setInitialState();
    yield* loadNextPage();
  }

  Stream<RepositoryResult<MPage<ItemType>>> loadNextPage() async* {
    print('Loading page...');
    if (!this.canLoadMore) {
      print('Paginator cannot load more');
      return;
    }

    final loadedPage = await _loadPage(_loadedItems.length, perPage: pageSize);

    if (loadedPage != null) {
      curPage += 1;
      _hasReachedMax = loadedPage.data.length < pageSize;
      _loadedItems.addAll(loadedPage.data);
      yield RepositoryResult(resultValue: loadedPage);
    }
  }

  Future<MPage<ItemType>> _loadPage(int page, {@required int perPage}) async {
    _isLoading = true;

    final res = await pageRepo(curPage, pageSize);
    final MPage<ItemType> loadedPage = res.resultValue;
    _isLoading = false;
    return loadedPage;
  }
}
