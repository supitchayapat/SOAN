TEMPLATE = app

QT += qml quick svg

SOURCES += main.cpp

RESOURCES += \
    main.qrc \
    wiamb-icons/icons.qrc \
    Qondrite/qondrite.qrc \
    Qure/qure.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
# use QML_IMPORT_TRACE environment variable to debug imports issues
QML_IMPORT_PATH += Qure
QML2_IMPORT_PATH += Qure

OPTIONS += roboto

# Default rules for deployment.
include(deployment.pri)
include(qml-material/material.pri)

CONFIG += c++11

#to use when need to debug qml
#CONFIG += qml_debug
