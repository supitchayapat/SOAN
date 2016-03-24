#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
#include <QQmlContext>
#include <QtQml>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    //qmlRegisterSingletonType(QUrl("qrc:/src/Qondrite.qml"), "Wiamp", 1, 0, "qondrite" );
    engine.load(QUrl(QStringLiteral("qrc:/src/main.qml")));
    return app.exec();
}
