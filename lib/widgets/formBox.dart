import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class FormBox extends StatefulWidget {
  const FormBox({Key? key}) : super(key: key);

  @override
  State<FormBox> createState() => _FormBoxState();
}

class _FormBoxState extends State<FormBox> {
  final formKey = GlobalKey<FormState>();
  final countryCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                buildTextFormField(countryCodeController, '970', 3,
                    flex: 1, prefixText: '+'),
                buildTextFormField(phoneNumberController, '0567892568', 15,
                    flex: 3),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ElevatedButton(
              onPressed: () async {
                await _launchWhatsapp(
                    countryCodeController.text + phoneNumberController.text);
                print(countryCodeController.text + phoneNumberController.text);
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

  _launchWhatsapp(String phone) async {
   // final url = Uri.parse('https://api.WhatsApp.com/send?phone=$phone');
   // print(url);
   final url = Uri.parse('whatsapp://send/?phone=$phone');

    if (await canLaunchUrl(url)) {
      await launchUrl(url).catchError((error) {
       
      });
    }
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return const AlertDialog(
    //         title: Text('An Error Occured'),
    //         content: Text(''),
    //       );
    //     });

    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return const AlertDialog(
    //           title: Text('An Error Occured'),
    //         );
    //       });
    // }
  }

  Widget buildTextFormField(
      TextEditingController controller, String hintText, int maxLength,
      {int flex = 0, String? prefixText}) {
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
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
