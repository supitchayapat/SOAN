TEMPLATE = app

TARGET = tst_wiamb

QT += qml quick

CONFIG += warn_on qmltestcase

SOURCES += \
    test_main.cpp

RESOURCES += \
    ../Qondrite/qondrite.qrc \
    ../Qure/qure.qrc

include(../qml-material/material.pri)

DISTFILES += \
    tst_PhoneTextField.qml
