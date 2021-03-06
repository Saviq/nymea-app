!win32:!nozeroconf {
    # To enable this on Windows we'd need to install Bonjour
    # https://support.apple.com/kb/DL999
    message("Building with QtZeroConf")
    DEFINES += QZEROCONF_STATIC
    DEFINES += WITH_ZEROCONF
    include(../QtZeroConf/qtzeroconf.pri)
} else {
    message("Building without QtZeroConf")
}

include(../nymea-remoteproxy/libnymea-remoteproxyclient/libnymea-remoteproxyclient.pri)


QT -= gui
QT += network websockets bluetooth charts quick

INCLUDEPATH += \
    $${PWD} \
    $$top_srcdir/QtZeroConf

SOURCES += \
    $$PWD/wifisetup/btwifisetup.cpp \
    $${PWD}/configuration/networkmanager.cpp \
    $${PWD}/engine.cpp \
    $${PWD}/models/barseriesadapter.cpp \
    $${PWD}/models/sortfilterproxymodel.cpp \
    $${PWD}/models/xyseriesadapter.cpp \
    $${PWD}/ruletemplates/calendaritemtemplate.cpp \
    $${PWD}/ruletemplates/timedescriptortemplate.cpp \
    $${PWD}/ruletemplates/timeeventitemtemplate.cpp \
    $${PWD}/scripting/scriptautosaver.cpp \
    $${PWD}/types/browseritem.cpp \
    $${PWD}/types/browseritems.cpp \
    $${PWD}/types/networkdevice.cpp \
    $${PWD}/types/networkdevices.cpp \
    $${PWD}/types/package.cpp \
    $${PWD}/types/packages.cpp \
    $${PWD}/types/repositories.cpp \
    $${PWD}/types/repository.cpp \
    $${PWD}/types/script.cpp \
    $${PWD}/types/scripts.cpp \
    $${PWD}/types/types.cpp \
    $${PWD}/types/vendor.cpp \
    $${PWD}/types/vendors.cpp \
    $${PWD}/types/deviceclass.cpp \
    $${PWD}/types/device.cpp \
    $${PWD}/types/param.cpp \
    $${PWD}/types/params.cpp \
    $${PWD}/types/paramtype.cpp \
    $${PWD}/types/paramtypes.cpp \
    $${PWD}/types/statetype.cpp \
    $${PWD}/types/statetypes.cpp \
    $${PWD}/types/statetypesproxy.cpp \
    $${PWD}/types/eventtype.cpp \
    $${PWD}/types/eventtypes.cpp \
    $${PWD}/types/actiontype.cpp \
    $${PWD}/types/actiontypes.cpp \
    $${PWD}/types/state.cpp \
    $${PWD}/types/states.cpp \
    $${PWD}/types/statesproxy.cpp \
    $${PWD}/types/plugin.cpp \
    $${PWD}/types/plugins.cpp \
    $${PWD}/types/rules.cpp \
    $${PWD}/types/rule.cpp \
    $${PWD}/types/eventdescriptor.cpp \
    $${PWD}/types/eventdescriptors.cpp \
    $${PWD}/types/ruleaction.cpp \
    $${PWD}/types/ruleactions.cpp \
    $${PWD}/types/ruleactionparams.cpp \
    $${PWD}/types/ruleactionparam.cpp \
    $${PWD}/types/logentry.cpp \
    $${PWD}/types/stateevaluators.cpp \
    $${PWD}/types/stateevaluator.cpp \
    $${PWD}/types/statedescriptor.cpp \
    $${PWD}/types/paramdescriptor.cpp \
    $${PWD}/types/paramdescriptors.cpp \
    $${PWD}/types/interface.cpp \
    $${PWD}/types/interfaces.cpp \
    $${PWD}/types/timedescriptor.cpp \
    $${PWD}/types/timeeventitem.cpp \
    $${PWD}/types/calendaritem.cpp \
    $${PWD}/types/timeeventitems.cpp \
    $${PWD}/types/calendaritems.cpp \
    $${PWD}/types/repeatingoption.cpp \
    $${PWD}/types/tag.cpp \
    $${PWD}/types/tags.cpp \
    $${PWD}/types/wirelessaccesspoint.cpp \
    $${PWD}/types/wirelessaccesspoints.cpp \
    $${PWD}/types/tokeninfo.cpp \
    $${PWD}/types/tokeninfos.cpp \
    $${PWD}/types/userinfo.cpp \
    $${PWD}/types/ioconnection.cpp \
    $${PWD}/types/ioconnections.cpp \
    $${PWD}/types/ioconnectionwatcher.cpp \
    $${PWD}/connection/nymeahost.cpp \
    $${PWD}/connection/nymeahosts.cpp  \
    $${PWD}/connection/nymeaconnection.cpp \
    $${PWD}/connection/nymeatransportinterface.cpp \
    $${PWD}/connection/websockettransport.cpp \
    $${PWD}/connection/tcpsockettransport.cpp \
    $${PWD}/connection/bluetoothtransport.cpp \
    $${PWD}/connection/awsclient.cpp \
    $${PWD}/connection/discovery/nymeadiscovery.cpp \
    $${PWD}/connection/discovery/upnpdiscovery.cpp \
    $${PWD}/connection/discovery/zeroconfdiscovery.cpp \
    $${PWD}/connection/discovery/bluetoothservicediscovery.cpp \
    $${PWD}/devicemanager.cpp \
    $${PWD}/jsonrpc/jsontypes.cpp \
    $${PWD}/jsonrpc/jsonrpcclient.cpp \
    $${PWD}/jsonrpc/jsonhandler.cpp \
    $${PWD}/devices.cpp \
    $${PWD}/devicesproxy.cpp \
    $${PWD}/deviceclasses.cpp \
    $${PWD}/deviceclassesproxy.cpp \
    $${PWD}/thingdiscovery.cpp \
    $${PWD}/models/packagesfiltermodel.cpp \
    $${PWD}/models/taglistmodel.cpp \
    $${PWD}/scripting/codecompletion.cpp \
    $${PWD}/scripting/completionmodel.cpp \
    $${PWD}/scriptmanager.cpp \
    $${PWD}/scriptsyntaxhighlighter.cpp \
    $${PWD}/usermanager.cpp \
    $${PWD}/vendorsproxy.cpp \
    $${PWD}/pluginsproxy.cpp \
    $${PWD}/interfacesmodel.cpp \
    $${PWD}/rulemanager.cpp \
    $${PWD}/models/rulesfiltermodel.cpp \
    $${PWD}/models/logsmodel.cpp \
    $${PWD}/logmanager.cpp \
    $${PWD}/wifisetup/bluetoothdevice.cpp \
    $${PWD}/wifisetup/bluetoothdeviceinfo.cpp \
    $${PWD}/wifisetup/bluetoothdeviceinfos.cpp \
    $${PWD}/wifisetup/bluetoothdiscovery.cpp \
    $${PWD}/models/logsmodelng.cpp \
    $${PWD}/models/interfacesproxy.cpp \
    $${PWD}/models/tagsproxymodel.cpp \
    $${PWD}/tagsmanager.cpp \
    $${PWD}/models/wirelessaccesspointsproxy.cpp \
    $${PWD}/ruletemplates/ruletemplate.cpp \
    $${PWD}/ruletemplates/ruletemplates.cpp \
    $${PWD}/ruletemplates/eventdescriptortemplate.cpp \
    $${PWD}/ruletemplates/ruleactiontemplate.cpp \
    $${PWD}/ruletemplates/stateevaluatortemplate.cpp \
    $${PWD}/ruletemplates/statedescriptortemplate.cpp \
    $${PWD}/connection/cloudtransport.cpp \
    $${PWD}/connection/sigv4utils.cpp \
    $${PWD}/ruletemplates/ruleactionparamtemplate.cpp \
    $${PWD}/configuration/serverconfiguration.cpp \
    $${PWD}/configuration/serverconfigurations.cpp \
    $${PWD}/configuration/nymeaconfiguration.cpp \
    $${PWD}/configuration/mqttpolicy.cpp \
    $${PWD}/configuration/mqttpolicies.cpp \
    $${PWD}/models/devicemodel.cpp \
    $${PWD}/system/systemcontroller.cpp \
    $${PWD}/thinggroup.cpp \
    $${PWD}/zigbee/zigbeeadapters.cpp \
    $${PWD}/zigbee/zigbeeadaptersproxy.cpp \
    $${PWD}/zigbee/zigbeemanager.cpp \
    $${PWD}/zigbee/zigbeeadapter.cpp \
    $${PWD}/zigbee/zigbeenetwork.cpp \
    $${PWD}/zigbee/zigbeenetworks.cpp



HEADERS += \
    $$PWD/wifisetup/btwifisetup.h \
    $${PWD}/configuration/networkmanager.h \
    $${PWD}/engine.h \
    $${PWD}/models/barseriesadapter.h \
    $${PWD}/models/sortfilterproxymodel.h \
    $${PWD}/models/xyseriesadapter.h \
    $${PWD}/ruletemplates/calendaritemtemplate.h \
    $${PWD}/ruletemplates/timedescriptortemplate.h \
    $${PWD}/ruletemplates/timeeventitemtemplate.h \
    $${PWD}/scripting/scriptautosaver.h \
    $${PWD}/types/browseritem.h \
    $${PWD}/types/browseritems.h \
    $${PWD}/types/networkdevice.h \
    $${PWD}/types/networkdevices.h \
    $${PWD}/types/package.h \
    $${PWD}/types/packages.h \
    $${PWD}/types/repositories.h \
    $${PWD}/types/repository.h \
    $${PWD}/types/script.h \
    $${PWD}/types/scripts.h \
    $${PWD}/types/types.h \
    $${PWD}/types/vendor.h \
    $${PWD}/types/vendors.h \
    $${PWD}/types/deviceclass.h \
    $${PWD}/types/device.h \
    $${PWD}/types/param.h \
    $${PWD}/types/params.h \
    $${PWD}/types/paramtype.h \
    $${PWD}/types/paramtypes.h \
    $${PWD}/types/statetype.h \
    $${PWD}/types/statetypes.h \
    $${PWD}/types/statetypesproxy.h \
    $${PWD}/types/eventtype.h \
    $${PWD}/types/eventtypes.h \
    $${PWD}/types/actiontype.h \
    $${PWD}/types/actiontypes.h \
    $${PWD}/types/state.h \
    $${PWD}/types/states.h \
    $${PWD}/types/statesproxy.h \
    $${PWD}/types/plugin.h \
    $${PWD}/types/plugins.h \
    $${PWD}/types/rules.h \
    $${PWD}/types/rule.h \
    $${PWD}/types/eventdescriptor.h \
    $${PWD}/types/eventdescriptors.h \
    $${PWD}/types/ruleaction.h \
    $${PWD}/types/ruleactions.h \
    $${PWD}/types/ruleactionparams.h \
    $${PWD}/types/ruleactionparam.h \
    $${PWD}/types/logentry.h \
    $${PWD}/types/stateevaluators.h \
    $${PWD}/types/stateevaluator.h \
    $${PWD}/types/statedescriptor.h \
    $${PWD}/types/paramdescriptor.h \
    $${PWD}/types/paramdescriptors.h \
    $${PWD}/types/interface.h \
    $${PWD}/types/interfaces.h \
    $${PWD}/types/timedescriptor.h \
    $${PWD}/types/timeeventitem.h \
    $${PWD}/types/calendaritem.h \
    $${PWD}/types/timeeventitems.h \
    $${PWD}/types/calendaritems.h \
    $${PWD}/types/repeatingoption.h \
    $${PWD}/types/tag.h \
    $${PWD}/types/tags.h \
    $${PWD}/types/wirelessaccesspoint.h \
    $${PWD}/types/wirelessaccesspoints.h \
    $${PWD}/types/tokeninfo.h \
    $${PWD}/types/tokeninfos.h \
    $${PWD}/types/userinfo.h \
    $${PWD}/types/ioconnection.h \
    $${PWD}/types/ioconnections.h \
    $${PWD}/types/ioconnectionwatcher.h \
    $${PWD}/connection/nymeahost.h \
    $${PWD}/connection/nymeahosts.h \
    $${PWD}/connection/nymeaconnection.h \
    $${PWD}/connection/nymeatransportinterface.h \
    $${PWD}/connection/websockettransport.h \
    $${PWD}/connection/tcpsockettransport.h \
    $${PWD}/connection/bluetoothtransport.h \
    $${PWD}/connection/awsclient.h \
    $${PWD}/connection/sigv4utils.h \
    $${PWD}/connection/discovery/nymeadiscovery.h \
    $${PWD}/connection/discovery/upnpdiscovery.h \
    $${PWD}/connection/discovery/zeroconfdiscovery.h \
    $${PWD}/connection/discovery/bluetoothservicediscovery.h \
    $${PWD}/devicemanager.h \
    $${PWD}/jsonrpc/jsontypes.h \
    $${PWD}/jsonrpc/jsonrpcclient.h \
    $${PWD}/jsonrpc/jsonhandler.h \
    $${PWD}/devices.h \
    $${PWD}/devicesproxy.h \
    $${PWD}/deviceclasses.h \
    $${PWD}/deviceclassesproxy.h \
    $${PWD}/thingdiscovery.h \
    $${PWD}/models/packagesfiltermodel.h \
    $${PWD}/models/taglistmodel.h \
    $${PWD}/scripting/codecompletion.h \
    $${PWD}/scripting/completionmodel.h \
    $${PWD}/scriptmanager.h \
    $${PWD}/scriptsyntaxhighlighter.h \
    $${PWD}/usermanager.h \
    $${PWD}/vendorsproxy.h \
    $${PWD}/pluginsproxy.h \
    $${PWD}/interfacesmodel.h \
    $${PWD}/rulemanager.h \
    $${PWD}/models/rulesfiltermodel.h \
    $${PWD}/models/logsmodel.h \
    $${PWD}/logmanager.h \
    $${PWD}/wifisetup/bluetoothdevice.h \
    $${PWD}/wifisetup/bluetoothdeviceinfo.h \
    $${PWD}/wifisetup/bluetoothdeviceinfos.h \
    $${PWD}/wifisetup/bluetoothdiscovery.h \
    $${PWD}/libnymea-app-core.h \
    $${PWD}/models/logsmodelng.h \
    $${PWD}/models/interfacesproxy.h \
    $${PWD}/tagsmanager.h \
    $${PWD}/models/tagsproxymodel.h \
    $${PWD}/models/wirelessaccesspointsproxy.h \
    $${PWD}/ruletemplates/ruletemplate.h \
    $${PWD}/ruletemplates/ruletemplates.h \
    $${PWD}/ruletemplates/eventdescriptortemplate.h \
    $${PWD}/ruletemplates/ruleactiontemplate.h \
    $${PWD}/ruletemplates/stateevaluatortemplate.h \
    $${PWD}/ruletemplates/statedescriptortemplate.h \
    $${PWD}/connection/cloudtransport.h \
    $${PWD}/ruletemplates/ruleactionparamtemplate.h \
    $${PWD}/configuration/serverconfiguration.h \
    $${PWD}/configuration/serverconfigurations.h \
    $${PWD}/configuration/nymeaconfiguration.h \
    $${PWD}/configuration/mqttpolicy.h \
    $${PWD}/configuration/mqttpolicies.h \
    $${PWD}/models/devicemodel.h \
    $${PWD}/system/systemcontroller.h \
    $${PWD}/thinggroup.h \
    $${PWD}/zigbee/zigbeeadapters.h \
    $${PWD}/zigbee/zigbeeadaptersproxy.h \
    $${PWD}/zigbee/zigbeemanager.h \
    $${PWD}/zigbee/zigbeeadapter.h \
    $${PWD}/zigbee/zigbeenetwork.h \
    $${PWD}/zigbee/zigbeenetworks.h

ubports: {
    DEFINES += UBPORTS
}

# https://bugreports.qt.io/browse/QTBUG-83165
android: {
    DESTDIR = $${ANDROID_TARGET_ARCH}
}
