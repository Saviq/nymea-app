include(config.pri)
message("APP_VERSION: $${APP_VERSION} ($${APP_REVISION})")
TEMPLATE=subdirs

SUBDIRS = libnymea-common libnymea-app-core nymea-app plugin
libnymea-app-core.depends = libnymea-common
nymea-app.depends = libnymea-app-core
plugin.depends = libnymea-app-core

#QML_IMPORT_PATH=/home/micha/Develop/Qt/5.11.0/gcc_64/qml/

withtests: {
    SUBDIRS += tests
    tests.depends = libnymea-app-core
}

# Building a Windows installer:
# Qt MinGW including the Qt Install Framework and MinGW runtime from Qt Installer
# Add QT_INSTALL_DIR/bin, QT_IFW_INSTALL_DIR/bin and MINGW_INSTALL_DIR/bin to PATH
# run "make wininstaller"
wininstaller.depends = nymea-app
!equals(STYLES_PATH, ""):!equals(BRANDING, "") {
    PACKAGE_BASE_DIR = $${STYLES_PATH}\packaging
} else {
    PACKAGE_BASE_DIR = $$shell_path($$PWD)\packaging
}
equals(BRANDING, "") {
    APP_NAME = nymea-app
    PACKAGE_URN = io.guh.nymeaapp
    PACKAGE_NAME = nymea-app-win-installer
    PACKAGE_DIR = $${PACKAGE_BASE_DIR}\windows
} else {
    APP_NAME = $${BRANDING}
    PACKAGE_URN = io.guh.$${APP_NAME}
    PACKAGE_NAME = $${BRANDING}-win-installer
    PACKAGE_DIR = $${PACKAGE_BASE_DIR}\windows_$${APP_NAME}
}
OLDSTRING="<Version>.*</Version>"
NEWSTRING="<Version>$${APP_VERSION}</Version>"
wininstaller.commands += @powershell -Command \"(gc $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\meta\package.xml) -replace \'$${OLDSTRING}\',\'$${NEWSTRING}\' | sc $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\meta\package.xml\" &&
wininstaller.commands += rmdir /S /Q $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data & mkdir $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data &&
wininstaller.commands += copy $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\meta\logo.ico $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data\logo.ico &&
CONFIG(debug,debug|release):wininstaller.commands += copy nymea-app\debug\nymea-app.exe $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data\\$${APP_NAME}.exe &&
CONFIG(release,debug|release):wininstaller.commands += copy nymea-app\release\nymea-app.exe $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data\\$${APP_NAME}.exe &&
!equals(SSL_LIBS, "") {
message("Deploying SSL libs from $${SSL_LIBS} to package.")
wininstaller.commands += copy $${SSL_LIBS}\libeay32.dll $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data &&
wininstaller.commands += copy $${SSL_LIBS}\ssleay32.dll $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data &&
}
wininstaller.commands += windeployqt --compiler-runtime --qmldir \"$${top_srcdir}\"\nymea-app\ui $${PACKAGE_DIR}\packages\\$${PACKAGE_URN}\data\ &&
wininstaller.commands += binarycreator -c $${PACKAGE_DIR}\config\config.xml -p $${PACKAGE_DIR}\packages\ $${PACKAGE_NAME}-$${APP_VERSION}
win32:message("Windows installer package directory: $${PACKAGE_DIR}")
QMAKE_EXTRA_TARGETS += wininstaller



# OS X installer bundle
# Install XCode and Qt clang64, add qmake directory to PATH
# run "make osxbundle"
osxbundle.depends = nymea-app
osxbundle.commands += cd nymea-app && rm -f nymea-app.dmg nymea-app_writable.dmg nymea-app-osx-bundle*.dmg || true &&
osxbundle.commands += hdiutil eject /Volumes/nymea-app || true &&
osxbundle.commands += macdeployqt nymea-app.app -qmldir=$$top_srcdir/nymea-app/ui -dmg &&
osxbundle.commands += hdiutil convert nymea-app.dmg -format UDRW -o nymea-app_writable.dmg &&
osxbundle.commands += hdiutil attach -readwrite -noverify nymea-app_writable.dmg && sleep 2 &&
osxbundle.commands += mv /Volumes/nymea-app/nymea-app.app /Volumes/nymea-app/nymea\:app.app &&
osxbundle.commands += tar -xpf $$top_srcdir/packaging/osx/template.tar -C /Volumes/nymea-app/ &&
osxbundle.commands += hdiutil eject /Volumes/nymea-app &&
osxbundle.commands += hdiutil convert nymea-app_writable.dmg -format UDRO -o ../nymea-app-osx-bundle-$${APP_VERSION}.dmg &&
osxbundle.commands += rm nymea-app.dmg nymea-app_writable.dmg
QMAKE_EXTRA_TARGETS += osxbundle

# Generic linux desktop
linux:!android: {
desktopfile.files = packaging/linux-common/nymea-app.desktop
desktopfile.path = /usr/share/applications/
icons.files = packaging/linux-common/icons/
icons.path = /usr/share/
INSTALLS += desktopfile icons
}

# Linux desktop (snap package)
snap: {
desktopfile.files = packaging/linux/nymea-app.desktop
desktopfile.path = /usr/share/applications/
INSTALLS += desktopfile
}

click: {
ubuntu_files.path += /
ubuntu_files.files += manifest.json nymea-app.apparmor nymea-app.desktop packaging/android/appicon.svg
INSTALLS += ubuntu_files
}

# Translations support
TRANSLATIONS += $$files($$absolute_path(nymea-app)/translations/*.ts, true)
system("lrelease $$TRANSLATIONS")
lrelease.commands = lrelease $$TRANSLATIONS
QMAKE_EXTRA_TARGETS += lrelease
