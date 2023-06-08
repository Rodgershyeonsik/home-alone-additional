import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utility/providers/board_list_provider.dart';
import 'package:provider/provider.dart';

import '../api/board.dart';
import '../screens/board_detail_screen.dart';
import '../../utility/custom_enums.dart';

class BoardListView extends StatefulWidget {
  const BoardListView({Key? key, required this.boards, required this.listTitle})
      : super(key: key);

  final String listTitle;
  final List<Board> boards;

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  String _sortValue = SortBy.latest.sortValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 1, height: 1),
                  itemCount: widget.boards.length,
                  itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: _makeBoard(widget.boards[index]),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            ))
          ],
        ));
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
