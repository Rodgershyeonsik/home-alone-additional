import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utility/providers/board_list_provider.dart';
import 'package:provider/provider.dart';

import '../../api/board.dart';
import '../../pages/boards/board_detail_page.dart';
import '../../utility/custom_enums.dart';

class BoardListView extends StatefulWidget {
  BoardListView({Key? key, required this.boards, required this.listTitle})
      : super(key: key);

  String listTitle;
  List<Board> boards;
  List<String> sortItems = ["최신순", "오래된 순"];

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  late String _sortValue = widget.sortItems.first;
  bool sortButtonIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey[100],
              height: 55.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.listTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  _buildSortButton()
                ],
              ),
            ),
            Expanded(
                child: ListView.separated(
              itemCount: widget.boards.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: _makeBoard(widget.boards[index]),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BoardDetailPage(board: widget.boards[index]),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(thickness: 1, height: 1),
            ))
          ],
        ));
  }

  Widget _buildSortButton() {
    return Container(
      color: Colors.green,
      width: 200,
      height: 150.0,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          Row(
            children: [
              Text(_sortValue),
              sortButtonIsExpanded
                  ? Icon(Icons.arrow_drop_up)
                  : Icon(Icons.arrow_drop_down),
            ],
          ),
          sortButtonIsExpanded
              ? Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            sortButtonIsExpanded = false;
                          });
                          Provider.of<BoardListProvider>(context,
                                  listen: false)
                              .sortBoard(SortBy.latest);
                        },
                        child: Text("최신순")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            sortButtonIsExpanded = false;
                          });
                          Provider.of<BoardListProvider>(context,
                                  listen: false)
                              .sortBoard(SortBy.earliest);
                        },
                        child: Text("오래된순")),
                  ],
                )
              : const SizedBox.shrink()
        ])
        // child: DropdownButton<String>(
        //             elevation: 0,
        //               underline: Container(),
        //               iconSize: 30.0,
        //               style: TextStyle(
        //                 color: Colors.black87,
        //                 fontSize: 15
        //               ),
        //               value: _dropdownValue,
        //               items: widget.sortItems.map<DropdownMenuItem<String>>((value) =>
        //               DropdownMenuItem<String>(
        //                 value: value,
        //                   child: Text(value))).toList(),
        //               onChanged: (value) {
        //                 setState(() {
        //                   _dropdownValue = value!;
        //                   if(_dropdownValue == "최신순"){
        //                     print('최신순 정렬됨?');
        //                     Provider.of<BoardListProvider>(context, listen: false).sortBoard(SortBy.latest);
        //                   } else {
        //                     print('오래된 순 정렬됨?');
        //                     Provider.of<BoardListProvider>(context, listen: false).sortBoard(SortBy.earliest);
        //                   }
        //                 });
        //               }),
        );
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
