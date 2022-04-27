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
  late PermissionStatus status;

  @override
  void initState() {
    Permission.phone.status.then((value) => status = value);
    super.initState();
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
        future: CallLog.get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status.isDenied) {
            Permission.phone.request();
            return Text('Grant permission to call logs');
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An Error Occured'),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text('No Recent Calls'),
            );
          } else {
            List<CallLogEntry> data = snapshot.data!.toList();
            return ListView.separated(
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
