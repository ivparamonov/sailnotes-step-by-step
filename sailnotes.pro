# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = sailnotes

CONFIG += sailfishapp
PKGCONFIG += nemonotifications-qt5

QT += dbus multimedia

SOURCES += src/sailnotes.cpp \
    src/filehelper.cpp \
    src/audiorecorder.cpp

DISTFILES += qml/sailnotes.qml \
    qml/cover/CoverPage.qml \
    rpm/sailnotes.changes.in \
    rpm/sailnotes.changes.run.in \
    rpm/sailnotes.spec \
    rpm/sailnotes.yaml \
    translations/*.ts \
    sailnotes.desktop \
    qml/pages/MainPage.qml \
    qml/pages/NoteDetailsPage.qml \
    qml/persistence/NotesDao.qml \
    qml/persistence/NoteListModel.qml \
    qml/dialogs/EditNoteDialog.qml \
    qml/dialogs/AddPictureDialog.qml \
    qml/components/AudioPlayer.qml \
    qml/components/NotificationManager.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

HEADERS += \
    src/filehelper.h \
    src/audiorecorder.h

dbus.files = dbus/org.fruct.yar.sailnotes.service
dbus.path = /usr/share/dbus-1/services/

INSTALLS += dbus
