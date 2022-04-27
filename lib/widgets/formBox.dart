import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../provider/bottom_navigationbar_provider.dart';

class FormBox extends StatefulWidget {
  const FormBox({Key? key}) : super(key: key);
  @override
  State<FormBox> createState() => _FormBoxState();
}

class _FormBoxState extends State<FormBox> {
  final countryCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    phoneNumberController.text =
        context.watch<BottomNavigationBarProvider>().phone;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // buildTextFormField(countryCodeController, '1', 3,
                //     flex: 1, prefixText: '+'),
                buildTextFormField(
                    phoneNumberController, 'Enter Number Here', 15, flex: 3,
                    validator: (input) {
                  if (input != null) {
                    if (input.startsWith('00')) {
                      return 'Remove a zero or replace 00 with +';
                    } else {
                      return null;
                    }
                  }
                }),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await launchWhatsapp(
                      countryCodeController.text + phoneNumberController.text);
                }
              },
              child: RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.whatsapp),
                    ),
                    TextSpan(text: " Send Now", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            )
          ],
        ),
      ),
    );
  }

  launchWhatsapp(String phone) async {
    // final url = Uri.parse('https://api.WhatsApp.com/send?phone=$phone');
    // print(url);
    final url = Uri.parse('whatsapp://send/?phone=$phone');

    if (await canLaunchUrl(url)) {
      await launchUrl(url).catchError((error) {});
    }
  }

  Widget buildTextFormField(
      TextEditingController controller, String hintText, int maxLength,
      {int flex = 0,
      String? prefixText,
      String? Function(String?)? validator}) {
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          validator: validator,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(hintText: hintText, prefixText: prefixText
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10.0),
              //   child: Text(
              //     prefixIcon ?? '',
              //     style: const TextStyle(fontSize: 22),
              //   ),
              // ),
              ),
        ),
      ),
    );
  }
}
