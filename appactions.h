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
    static QPointer<AppActions> instance();

    QSharedPointer<QHash<QString, QPointer<AppAction> > > actionsCaller() const;
    void setActionsCaller(const QSharedPointer<QHash<QString, QPointer<AppAction> > > &actionsCaller);

public slots:
    Q_INVOKABLE void callAction(QString action);

private :
    QSharedPointer< QHash<QString,QPointer<AppAction>>> _actionsCaller;
};

#endif // AMBUPLUSACTIONS_H
