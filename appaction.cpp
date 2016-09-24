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
    qDebug() << "=====setting action :" << name ;
//    AppActions::instance()->actionsCaller().remove(_name);
    _name = name;
    AppActions::instance()->actionsCaller().insert(_name,this);
}

QJSValue AppAction::job() const
{
    return _job;
}

void AppAction::setJob(const QJSValue &job)
{
    _job = job;
    AppActions::instance()->actionsCaller().insert(_name,this);
}

void AppAction::trigger()
{
    qDebug() << "=========invoking call from c++";
    QJSValue ret = _job.call();
    qDebug() << "=========calling successed ? " << (ret.isError());
//    QVariant arg;
//    QMetaObject::invokeMethod(this, "jobCallback"
//                              ,Qt::AutoConnection
//                              ,Q_ARG(QVariant, arg));
}
