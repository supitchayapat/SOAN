#include "appaction.h"
#include "appactions.h"
#include <QDebug>

AppAction::AppAction(QObject *parent) :
    QObject(parent)
{
    qDebug() << "=====creating action :" << _name << " with job" << _job.toString();
//    qDebug() << "AppActions container exists ? :" <<  AppActions.instance().exists();;
}

QString AppAction::name() const
{
    return _name;
}

void AppAction::setName(const QString &name)
{
    if(name !=""){
        qDebug() << "=====setting action :" << name ;
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
    qDebug() << "=========invoking call from c++";
    _job.call();
    qDebug() << "=========calling successed ? " << (!_job.isError());
}
