import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../base/base_lazy_load_page_resp.dart';
import '../../constants/typedef.dart';

// OK_BUG rebuild when the parent long list is scrolled >> lost data + rebuild lazy load
//: DONE create a controller to keep the data + current page

class LazyLoadController<T> extends ChangeNotifier {
  LazyLoadController({
    required this.scrollController,
    required this.items,
    this.useGrid = true,
    this.currentPage = 1,
    this.emptyMessage = 'Trống',
    this.showIndicator = false,
  });

  final ScrollController scrollController;
  List<T> items;
  int currentPage;

  /// Use GridView or ListView
  final bool useGrid;
  final String emptyMessage;

  /// Show loading indicator at the end of the list
  final bool showIndicator;

  // for controller
  bool get isFetchDataOnReload => _shouldFetchData;
  bool _shouldFetchData = false; //! config every time reload notifyListeners()

  //add
  void addItems(List<T> newItems) {
    items.addAll(newItems);
  }

  void reload({List<T>? newItems, bool shouldFetchData = true}) {
    items.clear();
    currentPage = 1;
    if (newItems != null) {
      items.addAll(newItems);
      _shouldFetchData = false;
    } else {
      _shouldFetchData = shouldFetchData;
    }
    notifyListeners();
  }

  void clearItems() {
    items.clear();
    currentPage = 1;
    _shouldFetchData = true;
    notifyListeners();
  }

  void clearItemsNoReload() {
    items.clear();
    currentPage = 1;
    _shouldFetchData = true;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LazyLoadController: items.length=${items.length}, currentPage=$currentPage, shouldFetchData: $_shouldFetchData';
  }
}

class NestedLazyLoadBuilder<T> extends StatefulWidget {
  //? no longer use internal scrollController >> cause unexpected rebuild
  const NestedLazyLoadBuilder({
    super.key,
    required this.dataCallback,
    required this.controller,
    this.crossAxisCount = 2,
    required this.itemBuilder,
  }) : assert(crossAxisCount > 0);

  final Future<RespData<IBasePageResp<T>>> Function(int page) dataCallback;
  final LazyLoadController<T> controller;

  final int crossAxisCount;

  final Widget Function(BuildContext context, int index, T data) itemBuilder;

  @override
  State<NestedLazyLoadBuilder<T>> createState() => _NestedLazyLoadBuilderState<T>();
}

class _NestedLazyLoadBuilderState<T> extends State<NestedLazyLoadBuilder<T>> {
  bool _isLoading = false;
  // String? _message;
  bool _reachEnd = false;

  //> scrollController dispose handled by parent
  @override
  void initState() {
    log('[NestedLazyLoadBuilder] initState');
    super.initState();
    _loadData(widget.controller.currentPage);
    widget.controller.scrollController.addListener(() {
      final pos = widget.controller.scrollController.position;
      if (pos.pixels == pos.maxScrollExtent && !_isLoading && !_reachEnd) {
        _loadData(widget.controller.currentPage);
      }
    });

    // refresh the list when the controller is updated
    widget.controller.addListener(() {
      log('[LazyLoadBuilder] listener called');
      if (mounted) {
        if (widget.controller.isFetchDataOnReload) {
          _loadData(widget.controller.currentPage);
          _reachEnd = false;
        } else {
          setState(() {
            _reachEnd = false;
          });
        }
      }
    });
  }

  Future<void> _loadData(int page) async {
    if (!_isLoading) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));

      List<T> data;
      final dataEither = await widget.dataCallback(page);
      data = dataEither.fold(
        (error) {
          Fluttertoast.showToast(msg: '${error.message}');
          return [];
        },
        (dataResp) {
          final newItems = dataResp.data!.items;
          if (newItems.isEmpty) {
            log('[LazyLoadBuilder] No more items at page $page');
            _reachEnd = true;
          } else {
            widget.controller.currentPage++;
          }
          return newItems;
        },
      );

      if (mounted) {
        setState(() {
          log('[LazyLoadBuilder] load more ${data.length} items at page $page');

          widget.controller.addItems(data);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('[LazyLoadBuilder] build with ${widget.controller.items.length} items');
    if (widget.controller.items.isEmpty && !_isLoading) {
      return Center(
        child: Text(
          widget.controller.emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }
    //? scrollController passed from parent
    //: 1: Disable the physics of the GridView & shrinkWrap it
    //! 2: Use the parent's scrollController --no longer use internal scrollController
    return widget.controller.useGrid ? _buildLazyLoadWithGridView() : _buildLazyLoadWithListView();
  }

  ListView _buildLazyLoadWithListView() {
    return ListView.builder(
      // controller: widget.scrollController != null ? null : _scrollController,
      // physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      // shrinkWrap: widget.scrollController != null ? true : false,
      // controller: widget.controller.scrollController,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: widget.crossAxisCount,
      //   crossAxisSpacing: 8,
      //   mainAxisSpacing: 8,
      // ),
      padding: EdgeInsets.zero,
      itemCount: widget.controller.showIndicator ? widget.controller.items.length + 1 : widget.controller.items.length,
      itemBuilder: (context, index) {
        if (widget.controller.items.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.controller.items.length) {
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : !_reachEnd
                    ? Container()
                    : Text(widget.controller.emptyMessage),
          );
        } else {
          return widget.itemBuilder(context, index, widget.controller.items[index]);
        }
      },
    );
  }

  Widget _buildLazyLoadWithGridView() {
    return GridView.builder(
      // controller: widget.scrollController != null ? null : _scrollController,
      // physics: widget.scrollController != null ? const NeverScrollableScrollPhysics() : null,
      // shrinkWrap: widget.scrollController != null ? true : false,
      // controller: widget.controller.scrollController,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.controller.showIndicator ? widget.controller.items.length + 1 : widget.controller.items.length,
      itemBuilder: (context, index) {
        if (widget.controller.items.isEmpty && _isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (index == widget.controller.items.length) {
          //> only show when [showIndicator] is true >> length + 1
          return Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : !_reachEnd
                    ? Container()
                    : Text(widget.controller.emptyMessage),
          );
        } else {
          return widget.itemBuilder(context, index, widget.controller.items[index]);
        }
      },
    );
  }
}