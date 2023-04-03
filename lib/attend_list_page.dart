import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'attend_info.dart';
import 'attend_info_service.dart';

class AttendListPage extends StatefulWidget {
  const AttendListPage({Key? key}) : super(key: key);

  @override
  State<AttendListPage> createState() => _AttendListPageState();
}

class _AttendListPageState extends State<AttendListPage> {
  Future<List<AttendInfo>> _fetchAttendInfos() async {
    final ret = await AttendInfoService.ins.getAll();
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('勤怠一覧'),
      ),
      body: FutureBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<List<AttendInfo>> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          }

          final attendInfos = snapshot.data;

          return ListView.builder(
            itemBuilder: ((context, index) {
              final item = attendInfos?[index];
              final formatter = DateFormat('MM月dd日');
              final timeFormatter = DateFormat('HH:mm');
              final str =
                  item?.startAt != null ? formatter.format(item!.startAt) : '';
              final timeStr = item?.startAt != null
                  ? timeFormatter.format(item!.startAt)
                  : '';
              final endTimeStr =
                  item?.endAt != null ? timeFormatter.format(item!.endAt) : '';
              return Dismissible(
                key: ValueKey<int>(item?.id ?? -1),
                background: Container(),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete),
                  ),
                ),
                onDismissed: ((direction) async {
                  if (direction == DismissDirection.endToStart) {
                    if (item != null) {
                      try {
                        await AttendInfoService.ins.delete(item);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('削除しました'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('削除に失敗しました'),
                          ),
                        );
                      }
                    }
                  }

                  setState(() {
                    attendInfos?.removeAt(index);
                  });
                }),
                child: ListTile(
                  leading: Text(str),
                  title: Text('$timeStr ~ $endTimeStr'),
                ),
              );
            }),
            itemCount: attendInfos?.length ?? 0,
          );
        },
        future: _fetchAttendInfos(),
      ),
    );
  }
}
