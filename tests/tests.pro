TEMPLATE = app

TARGET = tst_wiamb

CONFIG += warn_on qmltestcase

QT += qml quick
CONFIG += c++11

SOURCES += \
    test_main.cpp

RESOURCES += ../Qondrite/qondrite.qrc \
../Qure/qure.qrc

IMPORTPATH += $$PWD/../Qondrite $$PWD/../Qure

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += ../Qure
QML2_IMPORT_PATH += ../Qure

# Default rules for deployment.
include(../deployment.pri)
include(../qml-material/material.pri)

DISTFILES += \
    tst_PhoneTextField.qml
