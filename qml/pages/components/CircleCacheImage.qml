import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import com.stars.widgets 1.0

MyImage{
    id:thumbnail
    //asynchronous: true
    property string cacheurl
    property bool cacheimg: opencache

    Python{
        id:imgpy
         Component.onCompleted: {
         addImportPath(Qt.resolvedUrl('.././py')); // adds import path to the directory of the Python script
         imgpy.importModule('image', function () {
                call('image.cacheImg',[cacheurl],function(result){
                     thumbnail.source = result;
                     waitingIcon.visible = false;
                });
       })
      }
    }
    Image{
        id:waitingIcon
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: "image://theme/icon-m-refresh";
        //visible: parent.status==Image.Loading
    }
}
