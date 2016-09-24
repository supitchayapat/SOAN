#include <jni.h>

#include <QMetaObject>
#include <QAndroidJniObject>
#include <QDebug>

#include "appactions.h"

// TODO : remane this file to ambuplusNative as it specific to this project.
// define our native static functions
// these are the functions that Java part will call directly from Android UI thread

static void callAction(JNIEnv /*env*/, jobject /*obj*/, jstring action)
{
    QAndroidJniObject jniaction(action);
    QString action_ = jniaction.toString();
    qDebug() << "========convertin jstring to String : " << action_;
//    qDebug() << "================AmbuplusActions is aLive : " << AppActions::instance()->exists()
//    AmbuplusActions::instance().dumpObjectInfo();
    qDebug() << "================calling method succed : " <<
    QMetaObject::invokeMethod(AppActions::instance()
                              , "callAction"
                              , Qt::DirectConnection
                              , Q_ARG(QString,action_));
}

//create a vector with all our JNINativeMethod(s)
static JNINativeMethod methods[] = {
    {"callAction", "(Ljava/lang/String;)V", (void *)callAction},
};

// this method is called automatically by Java after the .so file is loaded
JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
{
    JNIEnv* env;
    // get the JNIEnv pointer.
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
      return JNI_ERR;

    // search for Java class which declares the native methods

    jclass javaClass = env->FindClass("spateof/io/qure/android/bindings/QureAppActionsProvider");
    if (!javaClass)
      return JNI_ERR;

    // register our native methods
    if (env->RegisterNatives(javaClass, methods,
                          sizeof(methods) / sizeof(methods[0])) < 0) {
      return JNI_ERR;
    }

    return JNI_VERSION_1_6;
}


