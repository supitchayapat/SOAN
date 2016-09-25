#include "appactions.h"
#include <QDebug>

AppActions::AppActions()
{
    qDebug() << "==========creating appActions";
}

void AppActions::callAction(QString action)
{
    qDebug() << "========callAction called from AmbuplusActions:" << action;
    QHash<QString,AppAction*>::const_iterator i = _actionsCaller.find(action);
    if(i != _actionsCaller.end())
        _actionsCaller.value(action)->trigger();
    qDebug() << "========callAction found ?" << (i != _actionsCaller.end()) ;
}


QHash<QString, AppAction*> AppActions::actionsCaller() const
{
    return _actionsCaller;
}

void AppActions::setActionsCaller(const QHash<QString, AppAction*> &actionsCaller)
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
