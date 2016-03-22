#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
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

              //qDebug()<<"Email"<<item->property("email").toString();
              engine.rootContext()->setContextProperty("navBar", item);

        }
    }

    return app.exec();
}
