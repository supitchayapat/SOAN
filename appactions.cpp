#include "appactions.h"
#include <QDebug>

AppActions::AppActions()
{
    _actionsCaller = QSharedPointer<QHash<QString, QPointer<AppAction>>>(new QHash<QString, QPointer<AppAction>>);
}

void AppActions::callAction(QString action)
{
    QHash<QString,QPointer<AppAction>>::const_iterator i = _actionsCaller.data()->find(action);
    if(i != _actionsCaller.data()->end())
        _actionsCaller.data()->value(action)->trigger();
}

QSharedPointer< QHash<QString, QPointer<AppAction>>> AppActions::actionsCaller() const
{
    return _actionsCaller;
}

void AppActions::setActionsCaller(const QSharedPointer<QHash<QString, QPointer<AppAction>>> &actionsCaller)
{
    _actionsCaller = actionsCaller;
}

Q_GLOBAL_STATIC(AppActions,appActions)

QPointer<AppActions> AppActions::instance()
{
    return appActions();
}
