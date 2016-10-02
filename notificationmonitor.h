#ifndef NOTIFICATIONMONITOR_H
#define NOTIFICATIONMONITOR_H

#include <QObject>

class NotificationMonitor : public QObject
{
    Q_OBJECT
public:
    using QObject::QObject;
    Q_INVOKABLE void startNotificationProcess() ;
    Q_INVOKABLE void stopNotificationProcess() ;

public slots:
//    Q_INVOKABLE void startNotificationProcess() ;
//    Q_INVOKABLE void stopNotificationProcess() ;
};

#endif // NOTIFICATIONMONITOR_H
