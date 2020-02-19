/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* Copyright 2013 - 2020, nymea GmbH
* Contact: contact@nymea.io
*
* This file is part of nymea.
* This project including source code and documentation is protected by
* copyright law, and remains the property of nymea GmbH. All rights, including
* reproduction, publication, editing and translation, are reserved. The use of
* this project is subject to the terms of a license agreement to be concluded
* with nymea GmbH in accordance with the terms of use of nymea GmbH, available
* under https://nymea.io/license
*
* GNU General Public License Usage
* Alternatively, this project may be redistributed and/or modified under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, GNU version 3. This project is distributed in the hope that it
* will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
* of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this project. If not, see <https://www.gnu.org/licenses/>.
*
* For any further details and any questions please contact us under
* contact@nymea.io or see our FAQ/Licensing Information on
* https://nymea.io/license/faq
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Nymea 1.0
import QtQuick.Controls.Material 2.2
import "../components"

MouseArea {
    id: root

    readonly property int count: interfacesGridView.count

    // Prevent scroll events to swipe left/right in case they fall through the grid
    preventStealing: true
    onWheel: wheel.accepted = true

    GridView {
        id: interfacesGridView
        anchors.fill: parent
        anchors.margins: app.margins / 2

        readonly property int minTileWidth: 172
        readonly property int tilesPerRow: root.width / minTileWidth

        model: RulesFilterModel {
            rules: engine.ruleManager.rules
            filterExecutable: true
        }
        cellWidth: width / tilesPerRow
        cellHeight: cellWidth

        delegate: MainPageTile {
            width: interfacesGridView.cellWidth
            height: interfacesGridView.cellHeight
            iconName: iconTag ? "../images/" + iconTag.value + ".svg" : "../images/slideshow.svg";
            fallbackIconName: "../images/slideshow.svg"
            iconColor: colorTag.value.length > 0 ? colorTag.value : app.accentColor;
            text: model.name.toUpperCase()

            property var colorTag: engine.tagsManager.tags.findRuleTag(model.id, "color")
            property var iconTag: engine.tagsManager.tags.findRuleTag(model.id, "icon")

            onClicked: engine.ruleManager.executeActions(model.id)

            Connections {
                target: engine.tagsManager.tags
                onCountChanged: {
                    colorTag = engine.tagsManager.tags.findRuleTag(model.id, "color")
                    iconTag = engine.tagsManager.tags.findRuleTag(model.id, "icon")
                }
            }
        }
    }
}
