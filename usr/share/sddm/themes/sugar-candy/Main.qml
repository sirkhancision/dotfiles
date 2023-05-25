//
// This file is part of SDDM Sugar Candy.
// A theme for the Simple Display Desktop Manager.
//
// Copyright (C) 2018–2020 Marian Arlt
//
// SDDM Sugar Candy is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
//
// You are required to preserve this and any additional legal notices, either
// contained in this file or in other files that you received along with
// SDDM Sugar Candy that refer to the author(s) in accordance with
// sections §4, §5 and specifically §7b of the GNU General Public License.
//
// SDDM Sugar Candy is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SDDM Sugar Candy. If not, see <https://www.gnu.org/licenses/>
//

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "Components"

Pane {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true

    LayoutMirroring.enabled: config.ForceRightToLeft === "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding: config.ScreenPadding
    palette {
        button: "transparent"
        highlight: config.AccentColor
        text: config.MainColor
        buttonText: config.MainColor
        window: config.BackgroundColor
    }

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    property bool isBackgroundImageVisible: isFormBackgroundVisible && config.FormPosition != "center" && config.PartialBlur != "true"
    property bool isFormBackgroundVisible: config.HaveFormBackground === "true"
    property bool isLeftAlignment: config.FormPosition === "left"
    property bool isRightAlignment: config.FormPosition === "right"
    property bool isBlurFull: config.FullBlur === "true"
    property bool isBlurPartial: config.PartialBlur === "true"
    property bool isBlurVisible: isBlurFull || isBlurPartial ? true : false

    Item {
        id: sizeHelper

        anchors.fill: parent
        height: parent.height
        width: parent.width

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "black"
            opacity: config.DimBackgroundImage
            z: 1
        }

        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            color: root.palette.window
            visible: isFormBackgroundVisible
            opacity: isPartialBlur ? 0.3 : 1
            z: 1
        }

        LoginForm {
            id: form

            height: virtualKeyboard.state === "visible" ? parent.height - virtualKeyboard.implicitHeight : parent.height
            width: parent.width / 2.5
            anchors.horizontalCenter: config.FormPosition === "center" ? parent.horizontalCenter : undefined
            anchors.left: isLeftAlignment ? parent.left : undefined
            anchors.right: isRightAlignment ? parent.right : undefined
            virtualKeyboardActive: virtualKeyboard.state === "visible" ? true : false
            z: 1
        }

        Button {
            id: vkb
            onClicked: virtualKeyboard.switchState()
            visible: virtualKeyboard.status === Loader.Ready && config.ForceHideVirtualKeyboardButton === "false"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: implicitHeight
            anchors.horizontalCenter: form.horizontalCenter
            z: 1
            contentItem: Text {
                text: config.TranslateVirtualKeyboardButton || "Virtual Keyboard"
                color: parent.visualFocus ? palette.highlight : palette.text
                font.pointSize: root.font.pointSize * 0.8
            }
            background: Rectangle {
                id: vkbbg
                color: "transparent"
            }
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            state: "hidden"
            property bool keyboardActive: item ? item.active : false
            onKeyboardActiveChanged: keyboardActive ? state = "visible" : state = "hidden"
            width: parent.width
            z: 1
            function switchState() { state = state === "hidden" ? "visible" : "hidden" }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: form
                        systemButtonVisibility: false
                        clockVisibility: false
                    }
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height / 4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 50
                                easing.type: Easing.OutCubic
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 50
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 50
                                easing.type: Easing.InCubic
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 50
                                easing.type: Easing.InCubic
                            }
                        }
                        ScriptAction {
                            script: {
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }

        Image {
            id: backgroundImage

            height: parent.height
            width: isBackgroundImageVisible ? parent.width - formBackground.width : parent.width
            anchors.left: isLeftAlignment ? formBackground.right : undefined
            anchors.right: isRightAlignment ? formBackground.left : undefined

            horizontalAlignment: config.BackgroundImageHAlignment === "left" ? Image.AlignLeft :
                                 config.BackgroundImageHAlignment === "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundImageVAlignment === "top" ? Image.AlignTop :
                               config.BackgroundImageVAlignment === "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            source: config.background || config.Background
            fillMode: config.ScaleImageCropped === "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            sourceItem: backgroundImage
            width: form.width
            height: parent.height
            anchors.centerIn: form
            sourceRect: Qt.rect(x,y,width,height)
            visible: isBlurVisible
        }

        GaussianBlur {
            id: blur

            height: parent.height
            width: isBlurFull ? parent.width : form.width
            source: isBlurFull ? backgroundImage : blurMask
            radius: config.BlurRadius
            samples: config.BlurRadius * 2 + 1
            cached: true
            anchors.centerIn: isBlurFull ? parent : form
            visible: isBlurVisible
        }
    }
}
