#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
#include <QQmlContext>
#include <QtQml>

static QJSValue singletonQondrite_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    QQmlComponent qondrite(engine,QUrl("qrc:/Qondrite/Qondrite.qml"),QQmlComponent::PreferSynchronous);
    if(!qondrite.isReady()) QThread::msleep(50);
    QObject *qrondriteObject = qondrite.create();
    QJSValue result = scriptEngine->newQObject(qrondriteObject);
    result.setProperty("meteor_url",QString("localhost:3000/"));
    return result;
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    qmlRegisterSingletonType("Qondrite",0,1,"Qondrite",singletonQondrite_provider);
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));
    return app.exec();
}
