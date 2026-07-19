{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>301</defaultcontrol>{% endblock %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture>script.plex/home/tvos-background-wash.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <posx>0</posx>
    <posy>{{ vscale(145) }}</posy>
    <defaultcontrol>301</defaultcontrol>

    <control type="group">
        <posx>160</posx>
        <posy>0</posy>
        <width>520</width>
        <height>{{ vscale(820) }}</height>
        <control type="label">
            <posx>0</posx>
            <posy>0</posy>
            <width>520</width>
            <height>{{ vscale(55) }}</height>
            <font>font_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(playlist.title)]</label>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(58) }}</posy>
            <width>520</width>
            <height>{{ vscale(35) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>AAFFFFFF</textcolor>
            <label>$INFO[Window.Property(playlist.duration)]</label>
        </control>
        <control type="image">
            <posx>-20</posx>
            <posy>{{ vscale(100) }}</posy>
            <width>540</width>
            <height>{{ vscale(540) }}</height>
            <texture border="40">script.plex/square-rounded-shadow.png</texture>
        </control>
        <control type="image">
            <posx>-4</posx>
            <posy>{{ vscale(116) }}</posy>
            <width>508</width>
            <height>{{ vscale(508) }}</height>
            <texture colordiffuse="34FFFFFF">script.plex/square-detail-rounded-plate.png</texture>
        </control>
        <control type="image">
            <visible>String.IsEqual(Window.Property(playlist.type),audio)</visible>
            <posx>0</posx>
            <posy>{{ vscale(120) }}</posy>
            <width>500</width>
            <height>{{ vscale(500) }}</height>
            <texture diffuse="script.plex/square-rounded-mask.png">script.plex/thumb_fallbacks/music.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <visible>!String.IsEqual(Window.Property(playlist.type),audio)</visible>
            <posx>0</posx>
            <posy>{{ vscale(120) }}</posy>
            <width>500</width>
            <height>{{ vscale(500) }}</height>
            <texture diffuse="script.plex/square-rounded-mask.png">script.plex/thumb_fallbacks/movie.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(120) }}</posy>
            <width>500</width>
            <height>{{ vscale(500) }}</height>
            <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[Window.Property(playlist.thumb)]</texture>
            <aspectratio>scale</aspectratio>
        </control>

        {% block buttons %}
        <control type="grouplist" id="300">
            <defaultcontrol always="true">301</defaultcontrol>
            <posx>0</posx>
            <posy>{{ vscale(655) }}</posy>
            <width>520</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>101</ondown>
            <onright>101</onright>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <align>left</align>
            <scrolltime>160</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            {% with template = "includes/themed_button.xml.tpl" & playlist_style = True & light_plate = True %}
                {% include template with name="play" & id=301 %}
                {% include template with name="shuffle" & id=302 %}
                {% include template with name="more" & id=303 & visible="!String.IsEmpty(Window.Property(show.options)) | Player.HasAudio" %}
            {% endwith %}
        </control>
        {% endblock buttons %}
    </control>

    <control type="group" id="100">
        <visible>Integer.IsGreater(Container(101).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>101</defaultcontrol>
        <posx>760</posx>
        <posy>0</posy>
        <width>1000</width>
        <height>{{ vscale(835) }}</height>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1000</width>
            <height>{{ vscale(835) }}</height>
            <texture border="18">script.plex/white-square-rounded.png</texture>
            <colordiffuse>52151517</colordiffuse>
        </control>
        <control type="label">
            <posx>32</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(55) }}</height>
            <font>font_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35038]</label>
        </control>
        <control type="list" id="101">
            <posx>20</posx>
            <posy>{{ vscale(66) }}</posy>
            <width>950</width>
            <height>{{ vscale(700) }}</height>
            <onup>200</onup>
            <onright condition="Integer.IsGreater(Container(101).NumPages,1)">152</onright>
            <onright condition="!Integer.IsGreater(Container(101).NumPages,1)">noop</onright>
            <onleft>300</onleft>
            <scrolltime>180</scrolltime>
            <orientation>vertical</orientation>
            <preloaditems>4</preloaditems>
            <pagecontrol>152</pagecontrol>
            <itemlayout height="{{ vscale(100) }}">
                {% include "includes/playlist_row_layout.xml.tpl" with focused=False %}
            </itemlayout>
            <focusedlayout height="{{ vscale(100) }}">
                <control type="group">
                    <visible>!Control.HasFocus(101)</visible>
                    {% include "includes/playlist_row_layout.xml.tpl" with focused=False %}
                </control>
                <control type="group">
                    <visible>Control.HasFocus(101)</visible>
                    {% include "includes/playlist_row_layout.xml.tpl" with focused=True %}
                </control>
            </focusedlayout>
        </control>
        <control type="scrollbar" id="152">
            <hitrect x="950" y="72" w="50" h="688" />
            <left>970</left>
            <top>{{ vscale(72) }}</top>
            <width>8</width>
            <height>{{ vscale(688) }}</height>
            <onleft>101</onleft>
            <visible>Integer.IsGreater(Container(101).NumPages,1)</visible>
            <texturesliderbackground colordiffuse="3018181A" border="4">script.plex/white-square-rounded-4r.png</texturesliderbackground>
            <texturesliderbar colordiffuse="70FFFFFF" border="4">script.plex/white-square-rounded-4r.png</texturesliderbar>
            <texturesliderbarfocus colordiffuse="FFFFFFFF" border="4">script.plex/white-square-rounded-4r.png</texturesliderbarfocus>
            <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
            <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
            <pulseonselect>false</pulseonselect>
            <orientation>vertical</orientation>
            <showonepage>false</showonepage>
        </control>
    </control>
</control>
{% endblock content %}
