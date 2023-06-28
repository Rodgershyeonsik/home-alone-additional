import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utility/providers/board_list_provider.dart';
import 'package:provider/provider.dart';

import '../../refresh_fab.dart';
import '../api/board.dart';
import '../screens/board_detail_screen.dart';
import '../../utility/custom_enums.dart';

class BoardListView extends StatefulWidget {
  const BoardListView(
      {Key? key,
      required this.boards,
      required this.listTitle,
      required this.category})
      : super(key: key);

  final String listTitle;
  final List<Board> boards;
  final BoardCategory category;

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  String _sortValue = SortBy.latest.sortValue;
  late BoardListProvider _boardListProvider;
  final ScrollController _scrollController = ScrollController();
  final positionAdjustment = 60.0;
  int pageRequestCnt = 0;

  @override
  void initState() {
    super.initState();
    _boardListProvider = Provider.of<BoardListProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        pageRequestCnt++;
        if(pageRequestCnt > _boardListProvider.lastIndex) {
          print("마지막 페이지");
        } else {
          requestNextPage(pageRequestCnt);
        }
      }
    });
  }

  Future<void> requestNextPage(int pageCnt) async {
    switch (widget.category) {
      case BoardCategory.all:
        _boardListProvider.loadEveryBoards(pageCnt);
        break;
      case BoardCategory.free:
        _boardListProvider.loadFreeBoards();
        break;
      case BoardCategory.ask:
        _boardListProvider.loadAskBoards();
        break;
      case BoardCategory.recipe:
        _boardListProvider.loadRecipeBoards();
        break;
      case BoardCategory.notice:
        _boardListProvider.loadNoticeBoards();
        break;
      default:
        debugPrint("그럴리가 없는데?");
    }
  }
  @override
  Widget build(BuildContext context) {
    print("빌드됨?");
    return LayoutBuilder(
      builder: (context, constrains) {
        return Stack(
            children:[
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.grey[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.listTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            _buildSortButton(context)
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          separatorBuilder: (BuildContext context, int index) =>
                          const Divider(thickness: 1, height: 1),
                          itemCount: widget.boards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: _makeBoard(widget.boards[index]),
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BoardDetailScreen(board: widget.boards[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  )),
              RefreshFloatingButton(
                  max: constrains.maxHeight - positionAdjustment,
                  onPressEvent: () {
                    refreshBoardList();
                    pageRequestCnt = 0;
                  })
            ]
        );
      },
    );
  }

  Future<void> refreshBoardList() async {
    _boardListProvider.forceLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    switch (widget.category) {
      case BoardCategory.all:
        _boardListProvider.loadEveryBoards(0);
        break;
      case BoardCategory.free:
        _boardListProvider.loadFreeBoards();
        break;
      case BoardCategory.ask:
        _boardListProvider.loadAskBoards();
        break;
      case BoardCategory.recipe:
        _boardListProvider.loadRecipeBoards();
        break;
      case BoardCategory.notice:
        _boardListProvider.loadNoticeBoards();
        break;
      default:
        debugPrint("그럴리가 없는데?");
    }
  }

  Widget _buildSortButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Row(
        children: [Text(_sortValue), const Icon(Icons.arrow_drop_down)],
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: size.height * 0.20,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSortOption(context, SortBy.latest),
                      _buildSortOption(context, SortBy.earliest)
                    ],
                  ));
            },
            backgroundColor: Colors.transparent);
      },
    );
  }

  Widget _buildSortOption(BuildContext context, SortBy sortBy) {
    var size = MediaQuery.of(context).size;

    return TextButton(
        style: TextButton.styleFrom(
            minimumSize: Size.fromHeight(size.height * 0.08)),
        onPressed: () {
          setState(() {
            _sortValue = sortBy.sortValue;
          });
          Navigator.pop(context);
          Provider.of<BoardListProvider>(context, listen: false)
              .sortBoard(sortBy);
        },
        child: Text(sortBy.sortValue));
  }

  Widget _makeBoard(Board board) {
    List<String> splitRegDate = board.regDate.split('T');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            board.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                splitRegDate[0] + ' ' + splitRegDate[1].substring(0, 5),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
              ),
              Text(
                board.writer,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );
  }
}
