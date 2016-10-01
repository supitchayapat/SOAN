#include "appaction.h"
#include "appactions.h"
#include <QDebug>

QString AppAction::name() const
{
    return _name;
}

void AppAction::setName(const QString &name)
{
    if(name !=""){
        _name = name;
        Q_ASSERT( AppActions::instance()->actionsCaller().data() != nullptr);
        AppActions::instance()->actionsCaller().data()->insert(_name,this);
        Q_ASSERT(AppActions::instance()->actionsCaller().data()->size() > 0);
    }
}

QJSValue AppAction::job() const
{
    return _job;
}

void AppAction::setJob(const QJSValue &job)
{
    _job = job;
    AppActions::instance()->actionsCaller().data()->insert(_name,this);
}

void AppAction::trigger()
{
    _job.call();
    emit triggered();
}
