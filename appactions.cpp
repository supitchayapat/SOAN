#include "appactions.h"
#include <QDebug>

AppActions::AppActions()
{
    qDebug() << "==========creating appActions";
    _actionsCaller = QSharedPointer<QHash<QString, AppAction*>>(new QHash<QString, AppAction*>);
}

void AppActions::callAction(QString action)
{
    qDebug() << "========callAction called from AmbuplusActions:" << action;
    QHash<QString,AppAction*>::const_iterator i = _actionsCaller.data()->find(action);
    if(i != _actionsCaller.data()->end())
        _actionsCaller.data()->value(action)->trigger();
    qDebug() << "========callAction found ?" << (i != _actionsCaller.data()->end()) ;
}


QSharedPointer< QHash<QString, AppAction*> > AppActions::actionsCaller() const
{
    return _actionsCaller;
}

void AppActions::setActionsCaller(const QSharedPointer<QHash<QString, AppAction*>> &actionsCaller)
{
    _actionsCaller = actionsCaller;
}

AppActions::~AppActions()
{
    qDebug() << "======= Destroying appActions";
}

Q_GLOBAL_STATIC(AppActions,appActions)

AppActions *AppActions::instance()
{
    return appActions();
}
