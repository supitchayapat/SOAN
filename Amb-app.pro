TEMPLATE = app

QT += qml quick svg

SOURCES += main.cpp

RESOURCES += \
    main.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML2_IMPORT_PATH = .

OPTIONS += roboto

# Default rules for deployment.
include(deployment.pri)
include(qml-material/material.pri)

CONFIG += c++11
