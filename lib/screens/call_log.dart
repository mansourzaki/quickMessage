import 'package:call_log/call_log.dart';
import 'package:easy_message/shared.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:time_elapsed/time_elapsed.dart';

import '../provider/bottom_navigationbar_provider.dart';

class CallLogPage extends StatefulWidget {
  const CallLogPage({Key? key}) : super(key: key);

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> {
  String message = '';
  Future<Iterable<CallLogEntry>> getLogs() async {
    final status = await Permission.phone.status;

    if (!status.isGranted) {
      message = '1';
      return [];
    } else {
      message = '0';
    }
    final logs = await CallLog.get();
    return logs;
  }

  @override
  Widget build(BuildContext context) {
    void editOnMainPage(String phone) {
      Provider.of<BottomNavigationBarProvider>(context, listen: false)
          .setNewPhone(phone);
      Provider.of<BottomNavigationBarProvider>(context, listen: false)
          .changeIndex(0);
    }

    return FutureBuilder<Iterable<CallLogEntry>>(
        future: getLogs(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occured'),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text(message),
            );
          } else {
            List<CallLogEntry> data = snapshot.data!.toList();
            return message == '1'
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Give permission from app settings'),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green[300]),
                            onPressed: () async {
                              setState(() {
                                openAppSettings();
                              });
                            },
                            child: const Text('Open App Settings')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green[300]),
                            onPressed: () async {
                              setState(() {});
                            },
                            child: const Text('Refresh')),
                      ],
                    ),
                  )
                : data.isEmpty
                    ? Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('No Recent Calls')),
                      )
                    : ListView.separated(
                        separatorBuilder: ((context, i) => const Divider()),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(data[i].number!),
                            subtitle: Text(
                              data[i].name! +
                                  ' - ' +
                                  TimeElapsed.fromDateTime(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          data[i].timestamp!)) +
                                  ' ago',
                            ),
                            leading: Text(
                              '${i + 1}',
                              style: const TextStyle(fontSize: 18, height: 1.8),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      editOnMainPage(data[i].number!);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      launchWhatsapp(data[i].number!);
                                    },
                                    icon: const Icon(
                                      Icons.whatsapp,
                                      color: Colors.green,
                                      size: 28,
                                    )),
                              ],
                            ),
                          );
                        });
          }
        }));
  }
}
