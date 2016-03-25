#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QtQml>


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    // TODO keep this comment to remember us that we may have the possibility of registring singleton this way
    //qmlRegisterSingletonType(QUrl("qrc:/src/Qondrite.qml"), "Wiamp", 1, 0, "qondrite" );
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));
    for(auto o:engine.rootObjects()){
         QQuickItem *item = o->findChild<QQuickItem*>("myNavBar");
        if(item){
              engine.rootContext()->setContextProperty("sideNavigationPanel ", item);
        }
    }

    return app.exec();
}
