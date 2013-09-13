APP_NAME = AmbientWeather

QT += network

CONFIG += qt warn_on cascades10

LIBS += -lbbdevice -lbbplatform -lQtLocationSubset
include(config.pri)
