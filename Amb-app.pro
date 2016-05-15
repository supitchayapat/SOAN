TEMPLATE = app

QT += qml quick svg websockets

SOURCES += main.cpp

RESOURCES += \
    main.qrc \
    wiamb-icons/icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
# use QML_IMPORT_TRACE environment variable to debug imports issues
# TODO : to resolve QtCreator imports we need to make the following line work
#QML2_IMPORT_PATH += qml-material/src

OPTIONS += roboto

# Default rules for deployment.
include(deployment.pri)
include(qml-material/material.pri)

CONFIG += c++11
