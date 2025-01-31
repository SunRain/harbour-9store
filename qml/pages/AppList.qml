/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/login.js" as UserData
import "../js/main.js" as Script
import "components"
import "model"
Page{
    id:showlist
    property int operationType: PageStackAction.Animated
    property string prepage
    property string nextpage
    property bool display:false
    property int listsum:0
    property int pagesize:12
    property string category
    property string developer
    property string sort:""
    property alias listmodel:listModel
    property bool showsearch: false

    ListModel {
        id:listModel
    }
    enabled: !loading
    onShowsearchChanged: {
            if (showsearch) {
                searchfield.forceActiveFocus()
            }else{
                showlist.focus=true
            }
        }

  Column {
        id: headerContainer

        width: showlist.width

        PageHeader {
            id:header
            title: qsTr("NewList")
            description: sort == ""?qsTr("Sort by Timeline"):
                                     (sort =="comment_num"?qsTr("Sort by Comments")
                                                          :qsTr("Sort by Download"))
        }
        SearchField {
            id: searchfield
            visible: showsearch
            width: parent.width
            y:showsearch?(header.y + Theme.paddingMedium):0
            Binding {
                target: showlist
                property: "searchString"
                value: searchfield.text
            }
            EnterKey.onClicked: {
                //asklistmodel.clear();
                Script.getSearch(sysinfo.osType,searchfield.text,category,nextpage)
                parent.focus=true
            }
        }
    }

        SilicaListView {
            id:view
            anchors.fill: parent
            PullDownMenu{
                   MenuItem{
                       id:pulldown
                       text:showsearch?qsTr("Hide Search"):qsTr("Show Search")
                       onClicked: {
                           showsearch?(showsearch=false):(showsearch=true)
                       }
                   }
                   MenuItem{
                       //timeline--->download_num--->comment_num--->timeline
                       text:sort == ""?qsTr("Sort by Download"):
                                                    (sort =="comment_num"?qsTr("Sort by Timeline"):
                                                                           qsTr("Sort by Comments"))

                       onClicked: {
                            switch(sort){
                            case "download_num":
                                sort ="comment_num"
                                break;
                            case "comment_num":
                                sort = "";
                                break;
                            default:
                                sort = "download_num";
                                break;
                            }
                            console.log("sort:"+sort)
                            Script.getlist(sysinfo.osType, category, developer, "", pagesize, sort)
                       }
                   }
               }
          header:PageHeader{
               id:head
               width:headerContainer.width
               height: headerContainer.height
               Component.onCompleted:headerContainer.parent = head
           }

            model: listModel
            clip: true
            delegate:AppListComponent{}
            VerticalScrollDecorator {}
            footer:Component{

                Item {
                    id: loadMoreID
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }
                    height: Theme.itemSizeMedium
                    Row {
                        id:footItem
                        spacing: Theme.paddingLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            text: qsTr("Prev Page")
                            visible: prepage != ""
                            onClicked: {
                                Script.getlist(sysinfo.osType, category, developer, prepage, pagesize, sort);
                                view.scrollToTop()
                            }
                        }
                        Button{
                            text:qsTr("Next Page")
                            visible:nextpage != ""
                            onClicked: {
                                console.log("nextpage:"+nextpage)
                                Script.getlist(sysinfo.osType, category, developer, nextpage, pagesize, sort);
                                view.scrollToTop()
                            }
                        }
                    }
                }

            }

            ViewPlaceholder{
                enabled: view.count == 0
                text: qsTr("No more apps")

            }

    }

    Component.onCompleted: {
        Script.mainPage = showlist;
        if(showsearch){
            searchfield.forceActiveFocus();
            return;
        }

        Script.getlist(sysinfo.osType, category, developer, nextpage, pagesize, sort)
    }

}
