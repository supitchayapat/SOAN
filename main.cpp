#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopWidget>
#include <QQmlContext>
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/Signin.qml")));
    QRect rec = QApplication::desktop()->screenGeometry();
    return app.exec();
}
