import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/notification_bloc.dart';
import 'package:unites_flutter/domain/models/notification_model.dart';
import 'package:unites_flutter/domain/models/notification_state.dart';
import 'package:unites_flutter/ui/events/event_info_screen.dart';
import 'package:unites_flutter/ui/profile/userInfo_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationBloc = getIt<NotificationBloc>();

  @override
  void initState() {
    notificationBloc.getNotifications();
    super.initState();
  }

  @override
  void dispose() {
    notificationBloc.setNotificationsAsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Уведомления')),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: StreamBuilder<List<NotificationModel>>(
            stream: notificationBloc.notifications,
            builder: (BuildContext context,
                AsyncSnapshot<List<NotificationModel>> snapshot) {
              Widget child;
              var bufferWidgets = <Widget>[];
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                if (snapshot.data!
                        .firstWhere((element) => element.seenByMe == false) != null) {
                  bufferWidgets.add(Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
                    child: Text('Новые'),
                  ));
                  snapshot.data!.forEach((element) {
                    print('element ${element.seenByMe}');
                    if (element.seenByMe == false) {
                      bufferWidgets.add(Padding(
                          padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                          child: Card(
                              child: ListTile(
                            onTap: () {
                              navigateFromNotification(element, context);
                            },
                            title: Text('${getNotificationText(element)}'),
                          ))));
                    }
                  });
                  bufferWidgets.add(Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
                    child: Text('Просмотренные'),
                  ));
                  snapshot.data!.forEach((element) {
                    if (element.seenByMe == true) {
                      bufferWidgets.add(Padding(
                          padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                          child: Card(
                              child: ListTile(
                            onTap: () {
                              navigateFromNotification(element, context);
                            },
                            title: Text('${getNotificationText(element)}'),
                          ))));
                    }
                  });
                } else {
                  snapshot.data!.forEach((element) {
                    bufferWidgets.add(Padding(
                        padding: EdgeInsets.only(left: 6, right: 6, top: 4),
                        child: Card(
                            child: ListTile(
                          onTap: () {
                            navigateFromNotification(element, context);
                          },
                          title: Text('${getNotificationText(element)}'),
                        ))));
                  });
                }

                child = Column(
                  children: bufferWidgets,
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              } else {
                print('empty list');
                child = Column(children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/broke.svg',
                        width: 100,
                        height: 160,
                      )),
                  Container(padding: EdgeInsets.only(top: 16)),
                  Text('Список уведомлений пуст',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center)
                ]);
              }
              return child;
            },
          ),
        ));
  }

  String getNotificationText(NotificationModel notificationModel) {
    var res = '';

    if (notificationModel.state == NotificationState.EVENT_CHANGED) {
      res = 'Мероприятие  `${notificationModel.eventName}` изменилось';
    } else if (notificationModel.state ==
        NotificationState.EVENT_NEW_PARTICIPANT) {
      res =
          '${notificationModel.initiatorName} вступил в Ваше мероприятие `${notificationModel.eventName}`';
    } else if (notificationModel.state ==
        NotificationState.EVENT_LEFT_PARTICIPANT) {
      res =
          '${notificationModel.initiatorName} покинул Ваше мероприятие `${notificationModel.eventName}`';
    } else {
      res =
          '${notificationModel.initiatorName} прокомментировал ваше мероприятие `${notificationModel.eventName}`';
    }

    return res;
  }

  void navigateFromNotification(
      NotificationModel notification, BuildContext context) {
    if (notification.state == NotificationState.EVENT_CHANGED ||
        notification.state == NotificationState.EVENT_NEW_COMMENT) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EventInfoScreen(eventId: notification.eventId)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserInfoScreen(userId: notification.initiatorId)));
    }
  }
}
