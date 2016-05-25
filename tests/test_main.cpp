#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QtQml>
#include <QtQuickTest/QtQuickTest>
#include "../qml-material/src/plugin.h"

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

int main(int argc, char **argv)
{
    MaterialPlugin qmlMaterial;
    qmlMaterial.registerTypes("Material");

    qmlRegisterSingletonType("Qondrite",0,1,"Qondrite",singletonQondrite_provider);

    return quick_test_main(argc, argv, "wiamb", 0);
}


