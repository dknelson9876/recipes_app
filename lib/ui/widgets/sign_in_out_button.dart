import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/firebase_service.dart';

class SignInOutButton extends StatelessWidget {
  final IconData icon = Icons.exit_to_app;
  final String title = "Log out";
  late String caption;
  final void Function()? onPressed;

  SignInOutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    caption = context.select<FirebaseService, String>(
      (service) => service.user?.displayName ?? 'Sign in',
    );

    return MaterialButton(
      // textColor: const Color(0xFF807A6B),
      padding: const EdgeInsets.all(20.0),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 5.0),
              Text(caption, style: Theme.of(context).textTheme.caption),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: (() {
              //there's probably a better way to do this
              String? photoURL = context.select<FirebaseService, String?>(
                  (service) => service.user?.photoURL);

              if (photoURL == null) {
                return const CircleAvatar(
                  child: Text('U'),
                );
              } else {
                return CircleAvatar(backgroundImage: NetworkImage(photoURL));
              }
            }()),
          ),
        ],
      ),
    );
  }
}
