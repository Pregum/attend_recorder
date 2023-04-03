import 'dart:math';

import 'package:attendance_recoder/attend_info.dart';
import 'package:attendance_recoder/attend_info_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AttendInfoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '勤怠記録',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'attend card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<AttendInfo?> _hasWorked() async {
    final ret = await AttendInfoService.ins.getByStartAt(DateTime.now());
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              builder:
                  (BuildContext context, AsyncSnapshot<AttendInfo?> snapshot) {
                if (snapshot.data != null) {
                  var targetAttendInfo = snapshot.data!;
                  if (targetAttendInfo.isPunchClock) {
                    return SizedBox(
                      height: min(MediaQuery.of(context).size.height * 0.3,
                          MediaQuery.of(context).size.width * 0.4),
                      width: min(MediaQuery.of(context).size.height * 0.3,
                          MediaQuery.of(context).size.width * 0.4),
                      child: const ElevatedButton(
                        onPressed: null,
                        child: Text('退勤済みです！'),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: min(MediaQuery.of(context).size.height * 0.3,
                          MediaQuery.of(context).size.width * 0.4),
                      width: min(MediaQuery.of(context).size.height * 0.3,
                          MediaQuery.of(context).size.width * 0.4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 100),
                            shape: const CircleBorder()),
                        onPressed: () async {
                          targetAttendInfo.endAt = DateTime.now();
                          targetAttendInfo.isPunchClock = true;
                          await AttendInfoService.ins.upsert(targetAttendInfo);
                          if (mounted) {
                            const sb = SnackBar(content: Text('退勤しました！'));
                            ScaffoldMessenger.of(context).showSnackBar(sb);
                            setState(() {});
                          }
                        },
                        child: Text(
                          '退勤',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    );
                  }
                } else {
                  return SizedBox(
                    height: min(MediaQuery.of(context).size.height * 0.3,
                        MediaQuery.of(context).size.width * 0.4),
                    width: min(MediaQuery.of(context).size.height * 0.3,
                        MediaQuery.of(context).size.width * 0.4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 100),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final newAttendInfo = AttendInfo(isPunchClock: false);
                        await AttendInfoService.ins.add(newAttendInfo);
                        if (mounted) {
                          const sb = SnackBar(content: Text('出勤しました！'));
                          ScaffoldMessenger.of(context).showSnackBar(sb);
                          setState(() {});
                        }
                      },
                      child: Text(
                        '出勤',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  );
                }
              },
              future: _hasWorked(),
              initialData: null,
            ),
          ],
        ),
      ),
    );
  }
}
