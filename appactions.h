#ifndef APPACTIONS_H
#define APPACTIONS_H

#include <QObject>
#include <QVariant>
#include "appaction.h"

class AppActions : public QObject
{
    Q_OBJECT
public:
    AppActions();
    ~AppActions();
//    using QObject::QObject;

    static AppActions* instance();
    QSharedPointer<QHash<QString, AppAction*>> actionsCaller() const;
    void setActionsCaller(const QSharedPointer<QHash<QString, AppAction *> > &actionsCaller);

signals:

public slots:
    Q_INVOKABLE void callAction(QString action);

private :
    QSharedPointer< QHash<QString,AppAction*>> _actionsCaller;
};

#endif // AMBUPLUSACTIONS_H
