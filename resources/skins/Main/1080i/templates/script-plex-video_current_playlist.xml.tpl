{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>101</defaultcontrol>{% endblock %}
{% block controls %}
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="55000000">script.plex/white-square.png</texture>
</control>

<control type="group" id="100">
    <defaultcontrol>101</defaultcontrol>
    <posx>830</posx>
    <posy>{{ vscale(70) }}</posy>
    <width>1040</width>
    <height>{{ vscale(940) }}</height>
    <control type="image">
        <posx>-28</posx>
        <posy>{{ vscale(-28) }}</posy>
        <width>1096</width>
        <height>{{ vscale(996) }}</height>
        <texture border="48" colordiffuse="99000000">script.plex/square-rounded-shadow.png</texture>
    </control>
    <control type="image">
        <width>1040</width>
        <height>{{ vscale(940) }}</height>
        <texture border="42" colordiffuse="ED111114">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <posx>40</posx>
        <posy>{{ vscale(34) }}</posy>
        <width>650</width>
        <height>{{ vscale(58) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35036]</label>
    </control>
    <control type="label">
        <posx>730</posx>
        <posy>{{ vscale(42) }}</posy>
        <width>250</width>
        <height>{{ vscale(42) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>88FFFFFF</textcolor>
        <label>$INFO[Container(101).NumItems]  $ADDON[script.plexmod 35038]</label>
    </control>
    <control type="list" id="101">
        <posx>30</posx>
        <posy>{{ vscale(112) }}</posy>
        <width>960</width>
        <height>{{ vscale(756) }}</height>
        <onleft>Close</onleft>
        <onright condition="Integer.IsGreater(Container(101).NumItems,7)">152</onright>
        <onright>101</onright>
        <scrolltime>160</scrolltime>
        <orientation>vertical</orientation>
        <preloaditems>4</preloaditems>
        <pagecontrol>152</pagecontrol>
        {% include "includes/current_playlist_video_row.xml.tpl" %}
    </control>
    <control type="scrollbar" id="152">
        <left>1000</left>
        <top>{{ vscale(122) }}</top>
        <width>10</width>
        <height>{{ vscale(736) }}</height>
        <onleft>101</onleft>
        <visible>Integer.IsGreater(Container(101).NumItems,7)</visible>
        <texturesliderbackground colordiffuse="20FFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbackground>
        <texturesliderbar colordiffuse="88FFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbar>
        <texturesliderbarfocus colordiffuse="FFFFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbarfocus>
        <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
        <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
        <pulseonselect>false</pulseonselect>
        <orientation>vertical</orientation>
        <showonepage>false</showonepage>
    </control>
</control>
{% endblock controls %}
