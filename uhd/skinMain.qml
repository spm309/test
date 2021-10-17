import QtQuick 2.6                      // items - Text, Image, Rectangle
import QtQuick.Layouts 1.14           // layouts - SwipeView, RowLayout, ColumnLayout
import QtQuick.Controls 2.15          // controls - Button, RadioButton...
import QtGraphicalEffects 1.0         // graphicals - DropShadow
import Enums 1.0
import YKQuick 0.1 // Essential, Don't Emit
import YKCommon 0.1 // Essential, Don't Emit

Item {
    id: idMain

    property real currentSpeed: skinData.currentSpeed
    property real topSpeed: skinData.topSpeed
    property real recordingTime: skinData.recordingTime
    property real travelDistance: skinData.travelDistance
    property real averageSpeed: skinData.averageSpeed
    property real travelCalorie: skinData.travelCalorie
    property int ridingState: skinData.ridingState
    property int windDegree: skinData.windDegree
    property real temperature: skinData.temperature
    property real currentAlt: skinData.currentPosition.altitude
    property int gpsStat: skinData.gpsStatus

    property var gradientFirstColor : '#000'
    property var gradientSecondColor : '#FFF'

    property int phoneWidth: idMain.width
    property int phoneHeight: idMain.height

    FontLoader {
        id: idFontFontName
        //source: "fontname.url"
    }
    FontLoader {
            id: idFontNotoB
            source: "NotoSansKR-Bold.otf"
        }
    FontLoader {
            id: idFontNotoR
            source: "NotoSansKR-Regular.otf"
        }
    FontLoader {
            id: idFontPEPSI
            source: "PEPSI_pl.ttf"
        }
    FontLoader {
            id: idFontViceCitySans
            source: "ViceCitySans.otf"
        }



    function fp (e){
        if (idMain.height>idMain.width) {
            //Portrait Mode
            return dp(e/dp(360) * idMain.width)
        } else {
            //Landscape Mode
            return dp(e/dp(360) * idMain.height)
        }
    }

    function secToStr(seconds) {
        var pad = function(x) { return (x < 10) ? "0"+x : x; }
        return pad(parseInt(seconds / (60*60))) + ":" +
                pad(parseInt(seconds / 60 % 60)) + ":" +
                pad(seconds % 60)
    }

    function colorcheck (e){

        if(e<1){
            gradientFirstColor='#000';
            gradientSecondColor='#FFF';
        }

        else if(e>=1 && e<20){
            gradientFirstColor='#61FF3C';
            gradientSecondColor='#36FFE0';
        }

        else if(e>=20 && e<40){
            gradientFirstColor='#FC3188';
            gradientSecondColor='#FF8DF2';
        }
        else if(e>=40){
            gradientFirstColor='#9757FF';
            gradientSecondColor='#E65DFF';
        }
    }
    onRidingStateChanged: {
        switch(skinData.ridingState)
        {
        case Enums.E_RIDING_REC: barAni.start();
        case Enums.E_RIDING_PAUSE:
        case Enums.E_RIDING_STOP:
            idbtnAni2.start();
            break;
        case Enums.E_RIDING_USER_PAUSE:
            idbtnAni1.start();
            break;
        default:
            break;
        }
    }

    Component{
        id: idMapComponent
        YKMap {
            mapStyleURL: "mapbox://styles/devyellowknife/ckekyff470oyi19nyk18xouvt"
            currentMapStyleIndex: 0
            onDoBack: idSwipeView.currentIndex = 1

            Button {
                anchors.left: parent.left
                anchors.leftMargin: dp(15)
                anchors.top: btnSearch.bottom
                anchors.topMargin: dp(20)
                width: dp(80)
                height: dp(80)
                background: Rectangle{
                    width: dp(80)
                    height: dp(80)
                    radius: width/2
                    color: "#2f57ff"
                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: dp(32)
                        color: "white"
                        text: currentSpeed.toFixed(1)
                    }
                }
                onClicked: {
                    if(idSwipeView.currentIndex === 0)
                        idSwipeView.currentIndex = 1
                }
            }

        }

    }

    Loader {
        anchors.fill: parent
        id: idMapLoader
    }

    SwipeView {
        id: idSwipeView
        anchors.fill: parent
        currentIndex: 1

        onCurrentItemChanged: {
            if(currentIndex == 1 || currentIndex == 2)
            {
                Qt.callLater(function() {
                    interactive = true
                    visible = true
                })
            }
            else if(currentIndex == 0)
            {
                Qt.callLater(function() {
                    interactive = false
                    visible = false
                })
            }
        }

        Item {
            // Map Area, Leave Blank
        }
        Item {
            // Skin Area
            Rectangle {
                id:idRectBackgroundColor
                anchors.fill: parent
                color:"#fff"
            }
            Rectangle {
                id:idCurrentSpeedWrap
                width: parent.width
                height: dp(200)
                anchors.top:parent.top
                anchors.topMargin: YKUtils.getStatusBarHeight()
                anchors.bottom:idDetailWrap.top
                color:'transparent'
                Rectangle{
                    id: idCurrentSpeedBox // 현재속도 숫자 부분만 상자
                    clip: false
                    height:idCurrentSpeedtext.height
                    width:parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    color:'transparent'
                    anchors.topMargin: fp(30)
                    border.color: '#000' // 내가 구분하려고 만든거

              /*  Rectangle {
                    id : idBackStripe // 가운데 띠 부분
                    width: parent.width
                    height: fp(15-(idMain.currentSpeed)/10)
                    color: '#ff8080'
                    anchors.verticalCenter: currentSpeedBox.verticalCenter

                    property real speed: idMain.currentSpeed

                    onSpeedChanged: {
                        colorcheck(currentSpeed);
                        if(barAni.running)
                            barAni.stop()
                        else
                            barAni.reCycle()
                    }

                    }*/
                Text{
                    id: idCurrentSpeedtext
                      anchors.centerIn: parent
                    text: currentSpeed.toFixed(1)
                    font.pixelSize: fp(100)
                    font.family: idFontPEPSI.name
                    color: "#000000"

                    }
                Text {
                    id:idCurrentSpeedUnit
                    anchors.top:idCurrentSpeedtext.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignHCenter
                    font.family: idFontNotoB.name
                    text: qsTr("Km/h")
                    font.pixelSize: fp(20)
                    color: "#000000"
                }
              }

            }

            Rectangle {
                id: idDetailWrap
                width: parent.width
                height: dp(260)
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: YKUtils.getStatusBarHeight()+fp(5)
                anchors.left: parent.left
                anchors.leftMargin: fp(20)
                anchors.right: parent.right
                anchors.rightMargin: fp(20)
                color: 'transparent'

                Rectangle {
                    id:idHline1
                    width: parent.width
                    height: dp(2)
                    color: "#000"
                    anchors.top: idDetailWrap.top
                }
                Item {
                    id:idTimeWrap
                    width: parent.width
                    height: fp(80)
                    anchors.top:idHline1.bottom
                    opacity: 1
                    clip:true
                    Text {
                        id: idTimetext
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignHCenter
                        text: secToStr(parseInt(recordingTime)) //상단에 secToStr함수줘야됨
                        font.pixelSize: fp(50)
                        font.family: idFontViceCitySans.name
                        color: "#000000"

                    }
                }
                Rectangle {
                    id:idHline2
                    height: dp(2)
                    width: parent.width
                    anchors.top:idTimeWrap.bottom
                    color: "#000"
                }

                Rectangle {
                    id: idSpeedsWrap
                    width: parent.width
                    height: fp(80)
                    anchors.left:parent.left
                    anchors.top:idHline2.bottom
                    color: 'transparent'

                    Item {
                        id: idAvgSpeed
                        width: parent.width/2
                        height: idAvgSpeedtext1.height + idAvgSpeedtext2.height
                        anchors.left:parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 1
                        clip:true
                        Text {
                            id: idAvgSpeedtext1
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr("Avg. Speed(km/h)")
                            font.pixelSize: fp(14)
                            font.family: idFontNotoR.name
                            color: '#000'
                        }
                        Text {
                            id: idAvgSpeedtext2
                            anchors.top: idAvgSpeedtext1.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr(averageSpeed.toFixed(1))
                            font.pixelSize: fp(36)
                            font.family: idFontViceCitySans.name
                            color: '#000'
                        }
                  }
                    Rectangle {
                        id:idVline1
                        height:parent.height
                        width: dp(2)
                        anchors.top:parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: '#000'
                    }
                    Item {
                        id: idTopSpeed
                        width: parent.width/2
                        height:idTopSpeedtext1.height + idTopSpeedtext2.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right:parent.right
                        opacity: 1
                        clip:true
                        Text {
                            id: idTopSpeedtext1
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr("Max. Speed(km/h)")
                            font.pixelSize: fp(14)
                            font.family: idFontNotoR.name
                            color: '#000'
                        }
                        Text {
                            id: idTopSpeedtext2
                            anchors.top: idTopSpeedtext1.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr(topSpeed.toFixed(1))
                            font.pixelSize: fp(36)
                            font.family: idFontViceCitySans.name
                            color: '#000'
                        }
                    }
                }
                Rectangle {
                    id:idHline3
                    height: dp(2)
                    width: parent.width
                    anchors.top:idSpeedsWrap.bottom
                    color: '#000'
                }
                Rectangle {
                    id:idInfoWrap
                    width: parent.width
                    height: fp(80)
                    anchors.left:parent.left
                    anchors.top:idHline3.bottom
                    color: 'transparent'

                    Item {
                        id: idDist
                        width: parent.width/2
                        height:idDisttext1.height + idDisttext2.height
                        anchors.left:parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 1
                        clip:true
                        Text {
                            id: idDisttext1
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr("Distance(km)")
                            font.pixelSize: fp(14)
                            font.family: idFontNotoR.name
                            color: '#000'
                        }
                        Text {
                            id: idDisttext2
                            anchors.top: idDisttext1.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr(travelDistance.toFixed(1))
                            font.pixelSize: fp(36)
                            font.family: idFontViceCitySans.name
                            color: '#000'
                        }
                    }
                    Rectangle {
                        id:idVline2
                        height: parent.height
                        width: dp(2)
                        anchors.top:parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: '#000'
                    }
                    Item {
                        id: idWind
                        width: parent.width/2
                        height:idWindtext1.height + idWindtext2.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right:parent.right
                        opacity: 1
                        clip:true
                        Text {
                            id: idWindtext1
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: qsTr("Wind Direction")
                            font.pixelSize: fp(14)
                            font.family: idFontNotoR.name
                            color: '#000'
                        }
                        Text {
                            id: idWindtext2
                            anchors.top: idWindtext1.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignHCenter
                            text: YKUtils.windDirection(windDegree)
                            font.pixelSize: fp(36)
                            font.family: idFontViceCitySans.name
                            color: '#000'
                        }
                    }
                    Rectangle {
                        id:idHline4
                        height: dp(2)
                        width: parent.width
                        anchors.top:idInfoWrap.bottom
                        color: '#000'
                    }
                }

            }

            Rectangle {
                id:idbuttonWrap
                width: parent.width
                anchors.top: idDetailWrap.bottom
                anchors.bottom:parent.bottom
                color: 'transparent'
                Rectangle {
                    id: idButtonCircle2 // 정사각 버튼(중지)
                    width: fp(90)
                    height: fp(90)
                    clip : true // ?
                    radius: height/2
                    x: (phoneWidth/2)-(width/2)//(phoneWidth*3/4)-(width/2)-fp(20) //? 폰가로길이/2 - fp(90)(?)/2

                    anchors.verticalCenter: parent.verticalCenter
                    color:"black"
                    border.width: fp(2)
                    border.color:"red" //black
                    opacity: 1 // Initial 0

                    Rectangle{ // 정사각 버튼(중지)

                        width: fp(80)
                        height: fp(80)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color:'transparent'

                        Image {
                            id: idResumeButton
                            width: parent.width
                            height: parent.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: skinImageSource("btn_stop")

                            ColorOverlay{
                                color:"#fff" //#fff
                                source: parent
                                anchors.fill:parent
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: idPopupAskStop.open()
                        }
                    }
                }
                Rectangle {
                    id: idButtonCircle // play랑 정지버튼
                    width: fp(90)
                    height: fp(90)
                    clip : true //?
                    radius: height/2
                    anchors.verticalCenter: parent.verticalCenter
                    x: (phoneWidth/2)-(width/2)//(phoneWidth/4)-(width/2)+fp(20)
                    color:"black"
                    border.width: fp(2)
                    border.color:"blue"

                    opacity: 1// Initial 0

                    Rectangle {
                        width: fp(80)
                        height: fp(80)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color:'transparent'

                        Image {
                            id: idButton

                            anchors.fill: parent
                            source: changeImage(idMain.ridingState)//skinImageSource("btn_play")

                            function changeImage(ridingState) // 이미지 바뀌기? // ===: 두값이 같은 데이터 타입인지 여부를 비교 ||: 둘중하나라도 맞으면 true
                            {
                                if (idMain.ridingState === Enums.E_RIDING_REC||idMain.ridingState === Enums.E_RIDING_PAUSE) // 만약 라이딩상태가 멈춤이면 pause이미지 가져와라
                                {
                                    return skinImageSource("pause")
                                }
                                if (idMain.ridingState === Enums.E_RIDING_READY || idMain.ridingState === Enums.E_RIDING_STOP|| idMain.ridingState === Enums.E_RIDING_USER_PAUSE)
                                {
                                    return skinImageSource("rec") //아니면 만약 라이딩상태가 ready이면 recd이미지 가져와라
                                }
                            }

                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                switch(skinData.ridingState)
                                {
                                case Enums.E_RIDING_REC:
                                case Enums.E_RIDING_PAUSE:
                                    appEngine.doPauseRecording()
                                    break;
                                case Enums.E_RIDING_USER_PAUSE:
                                    appEngine.doResumeRecording()
                                    break;
                                default:
                                case Enums.E_RIDING_READY:
                                case Enums.E_RIDING_STOP:
                                    appEngine.doStartRecording()
                                    break;
                                }

                            }
                        }
                    }
                }
            }

          /*Rectangle {
                  id : stopButton
                  width: dp(90)
                  height:dp(90)
                  color: "#000"
                  radius: height/2
                  anchors.bottom: parent.bottom
                  anchors.bottomMargin: fp(45)
                  anchors.horizontalCenter: parent.horizontalCenter
                  Rectangle{
                      id: stop1
                      width: dp(8)
                      height:dp(30)
                      color: "#fff"
                      anchors.left: parent.left
                      anchors.leftMargin: dp(30)
                      anchors.top: parent.top
                      anchors.topMargin: dp(32)
                      Rectangle {
                           id: stop2
                           width: dp(8)
                           height:dp(30)
                           color: "#fff"
                           anchors.left: parent.left
                           anchors.leftMargin: dp(20)
                      }
                  }
              }*/


        }
    }

    Component.onCompleted: {
        setIsShowSkinSetting(true)
        setIsHasStartStopControl(true)
        setIsHasGpsSkin(true)
    }

    // Intro Animation
    SequentialAnimation {
        id: idInAnimation
        running: false

        ScriptAction {
            script: {
                idMapLoader.sourceComponent = idMapComponent

            }
        }
    }

    //Outro Animation
    SequentialAnimation {
        id: idOutAnimation
        running: false

        ScriptAction{script: appEngine.skinAnimationFinished()}
    }

    Connections {
        id: idConnectionForOutAnimation
        target: appEngine
        function onBeforeSkinChanged() {
            idOutAnimation.running = true
        }
        function onAfterSkinChanged() {
            console.log(">>>>")
            idInAnimation.running = true
        }
    }
}
