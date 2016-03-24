#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QObject>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));
    for(auto o:engine.rootObjects()){
         QQuickItem *item = o->findChild<QQuickItem*>("myNavBar");
        if(item){
              engine.rootContext()->setContextProperty("sideNavigationPanel ", item);
        }
    }

    return app.exec();
}
