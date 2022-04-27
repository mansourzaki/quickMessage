import 'package:url_launcher/url_launcher.dart';

launchWhatsapp(String phone) async {
  // final url = Uri.parse('https://api.WhatsApp.com/send?phone=$phone');
  // print(url);
  final url = Uri.parse('whatsapp://send/?phone=$phone');

  if (await canLaunchUrl(url)) {
    await launchUrl(url).catchError((error) {});
  }
}


