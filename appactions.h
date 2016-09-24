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

//    void init(){}
    static AppActions* instance();
    QHash<QString, AppAction*> actionsCaller() const;
    void setActionsCaller(const QHash<QString, AppAction*> &actionsCaller);

signals:

public slots:
    Q_INVOKABLE void callAction(QString action);

private :
    QHash<QString,AppAction*> _actionsCaller;
};

#endif // AMBUPLUSACTIONS_H
