TEMPLATE = subdirs

QT += qml quick svg websockets

SOURCES += main.cpp

RESOURCES += \
    main.qrc \
    wiamb-icons/icons.qrc \
    Qondrite/qondrite.qrc \
    Qure/qure.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
# use QML_IMPORT_TRACE environment variable to debug imports issues
# TODO : to resolve QtCreator imports we need to make the following line work
# by resolving import issue and adding generating a ,qmltypes file using qmlplugindump
# for matrial module ( see both qmldir files for material and Qure)
#QML2_IMPORT_PATH += qml-material/src
QML_IMPORT_PATH += Qure
QML2_IMPORT_PATH += Qure

OPTIONS += roboto

# Default rules for deployment.
include(deployment.pri)
include(qml-material/material.pri)

CONFIG += c++11

#to use when need to debug qml
#CONFIG += qml_debug

SUBDIRS += tests
