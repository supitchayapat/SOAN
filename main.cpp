#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QtQml>
#include "qml-material/src/plugin.h"
#include "appaction.h"
#include "appactions.h"
#include "notificationmonitor.h"
#include <QtAndroid>
#include "appactions.h"

static QJSValue singletonQondrite_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    QQmlComponent qondrite(engine,QUrl("qrc:/Qondrite/Qondrite.qml"));

    while(!qondrite.isReady()) {
        qWarning() << "error while loading qondrite"<< qondrite.errorString() ;
        QThread::msleep(100);
    }

    QObject *qrondriteObject = qondrite.create();
    QJSValue result = scriptEngine->newQObject(qrondriteObject);
    result.setProperty("meteor_url",QString("ambuplus.herokuapp.com"));
    return result;
}

int main(int argc, char *argv[])
{
#ifndef Q_OS_ANDROID
    // TODO : move the this qputenv to an equivalent in the .pro file
    qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "1");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.addImportPath(":/.");
    MaterialPlugin qmlMaterial;
    qmlMaterial.registerTypes("Material");

    qmlRegisterSingletonType("Qondrite",0,1,"Qondrite",singletonQondrite_provider);
    qmlRegisterType<AppAction>("Qure", 0, 1, "AppAction");


    qmlRegisterUncreatableType<NotificationMonitor>("Qure",0,1,"_notificationMonitor","give some description");

    NotificationMonitor *notificationMonitor = new NotificationMonitor(&engine);
    engine.rootContext()->setContextProperty("_notificationMonitor", notificationMonitor);

    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));

    return app.exec();
}
