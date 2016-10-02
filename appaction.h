#ifndef APPACTION_H
#define APPACTION_H

#include <QObject>
#include <QtQml>
#include <QVariant>

class AppAction : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QJSValue jobCallback READ job WRITE setJob NOTIFY jobChanged)

public:
    using QObject::QObject;

    QString name() const;
    void setName(const QString &name);

    QJSValue job() const;
    void setJob(const QJSValue &job);

signals:
    void triggered();
    void nameChanged();
    void jobChanged();

public slots:
    Q_INVOKABLE void trigger() ;

private :
    QString _name;
    QJSValue _job;
};

#endif // APPACTION_H
