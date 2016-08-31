#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QtQml>
#include <QtAndroid>
#include <QAndroidJniObject>
#include "qml-material/src/plugin.h"

static QJSValue singletonQondrite_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    QQmlComponent qondrite(engine,QUrl("qrc:/Qondrite/Qondrite.qml"));

    while(!qondrite.isReady()) {
        qWarning() << "error while loading qondrite"<< qondrite.errorString() ;
        QThread::msleep(100);
    }

    QObject *qrondriteObject = qondrite.create();
    QJSValue result = scriptEngine->newQObject(qrondriteObject);
    result.setProperty("meteor_url",QString("wiamb-staging.scalingo.io"));
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

    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));

    // linking between backButtonClicked (main.qml) and onBackClicked method (Android side)
    // workaround: no direct way to use qml signals in the new QObject::connect syntax hence using lambda with qml signals
    QSignalMapper signalMapper;
    QObject* appWindow = engine.rootObjects()[0];
    QObject::connect( appWindow, SIGNAL(sendBackground()), &signalMapper, SLOT(map()));
    signalMapper.setMapping( appWindow, "appWindow" );

    QObject::connect( &signalMapper, static_cast<void(QSignalMapper::*)(const QString&)>(&QSignalMapper::mapped), [&]() {
        QtAndroid::androidActivity().callMethod<void>("onBackClicked");
    });

    //WARNING the following generate a conflict with initialItem in main.qml
//    for(auto o:engine.rootObjects()){
//        QQuickItem *item = o->findChild<QQuickItem*>("sidePanel");
//        if(item){
//            engine.rootContext()->setContextProperty("sideNavigationPanel", item);
//        }
//    }

    return app.exec();
}
