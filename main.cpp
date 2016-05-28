#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QtQml>
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
//    result.setProperty("meteor_url",QString("wiamb-staging.scalingo.io"));
    result.setProperty("meteor_url",QString("wiamb-imad.scalingo.io"));
//    result.setProperty("meteor_url",QString("localhost:3000"));
    return result;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.addImportPath(":/.");
    MaterialPlugin qmlMaterial;
    qmlMaterial.registerTypes("Material");
    qmlRegisterSingletonType("Qondrite",0,1,"Qondrite",singletonQondrite_provider);
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));

    for(auto o:engine.rootObjects()){
         QQuickItem *item = o->findChild<QQuickItem*>("sidePanel");
        if(item){
              engine.rootContext()->setContextProperty("sideNavigationPanel", item);
        }
    }

    return app.exec();
}
