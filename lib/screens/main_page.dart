import 'package:flutter/material.dart';

import '../widgets/formBox.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: Container(
              color: Colors.green[200],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sms,
                      size: 100,
                    ),
                    Text(
                      'Send whatsapp message without saving number',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ]),
            ),
          ),
          const FormBox()
        ],
      ),
    );
  }
}
