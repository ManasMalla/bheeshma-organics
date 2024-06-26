import 'package:bheeshmaorganics/data/entitites/notification.dart';
import 'package:bheeshmaorganics/data/providers/notification_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(FeatherIcons.arrowLeft),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/images/character-two.svg',
                    width: 140,
                    colorFilter: Theme.of(context).brightness == Brightness.dark
                        ? const ColorFilter.mode(
                            Colors.white54, BlendMode.srcIn)
                        : null,
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                "Missed something?",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Catch all the updates you might have missed out",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 36,
              ),
              ListView.separated(
                itemBuilder: (context, index) {
                  return NotificationCard(
                      notificationProvider.notification[index]);
                },
                separatorBuilder: (_, __) => const SizedBox(
                  height: 16,
                ),
                itemCount: notificationProvider.notification.length,
                primary: false,
                shrinkWrap: true,
              ),
            ]),
          ),
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final BheeshmaNotification notification;
  const NotificationCard(
    this.notification, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.network(
              notification.image,
              width: 100,
              height: ((notification.body.length / 36) * 20).floor() + 100,
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  notification.body,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact),
                  onPressed: () {
                    Navigator.of(context).pushNamed(notification.route,
                        arguments: notification.payload);
                  },
                  child: Text(
                    notification.cta,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
