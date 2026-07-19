{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>101</defaultcontrol>{% endblock %}
{% block controls %}
{% include "includes/default_background.xml.tpl" with background_source="$INFO[Player.Art(landscape)]" %}
<control type="image">
    <visible>String.IsEmpty(Player.Art(landscape))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture background="true">script.plex/home/background-fallback.png</texture>
    {% include "includes/scale_background.xml.tpl" %}
</control>

<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture>script.plex/home/tvos-background-wash.png</texture>
</control>
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="44000000">script.plex/white-square.png</texture>
</control>

<!-- NOW PLAYING -->
<control type="group">
    <posx>90</posx>
    <posy>0</posy>
    <width>630</width>
    <height>1080</height>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(58) }}</posy>
        <width>630</width>
        <height>{{ vscale(54) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35037]</label>
    </control>
    <control type="image">
        <posx>-26</posx>
        <posy>{{ vscale(109) }}</posy>
        <width>592</width>
        <height>{{ vscale(592) }}</height>
        <texture border="48" colordiffuse="88000000">script.plex/square-rounded-shadow.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>{{ vscale(135) }}</posy>
        <width>540</width>
        <height>{{ vscale(540) }}</height>
        <texture fallback="script.plex/thumb_fallbacks/music.png" diffuse="script.plex/square-rounded-mask.png">$INFO[Player.Art(thumb)]</texture>
        <aspectratio>scale</aspectratio>
    </control>
    <control type="image">
        <posx>-11</posx>
        <posy>{{ vscale(124) }}</posy>
        <width>562</width>
        <height>{{ vscale(562) }}</height>
        <texture colordiffuse="24FFFFFF">script.plex/square-rounded-outline.png</texture>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(708) }}</posy>
        <width>630</width>
        <height>{{ vscale(42) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[MusicPlayer.Artist]</label>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(750) }}</posy>
        <width>630</width>
        <height>{{ vscale(34) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>99FFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[MusicPlayer.Album]</label>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(792) }}</posy>
        <width>630</width>
        <height>{{ vscale(42) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[MusicPlayer.Title]</label>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(834) }}</posy>
        <width>630</width>
        <height>{{ vscale(30) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>B8FFFFFF</textcolor>
        <label>$INFO[Player.Time]$INFO[MusicPlayer.Duration,  /  ]</label>
    </control>
</control>

<!-- QUEUE PANEL -->
<control type="group" id="100">
    <visible>Integer.IsGreater(Container(101).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
    <defaultcontrol>101</defaultcontrol>
    <posx>770</posx>
    <posy>{{ vscale(60) }}</posy>
    <width>1100</width>
    <height>{{ vscale(950) }}</height>
    <control type="image">
        <posx>-28</posx>
        <posy>{{ vscale(-28) }}</posy>
        <width>1156</width>
        <height>{{ vscale(1006) }}</height>
        <texture border="48" colordiffuse="88000000">script.plex/square-rounded-shadow.png</texture>
    </control>
    <control type="image">
        <width>1100</width>
        <height>{{ vscale(950) }}</height>
        <texture border="42" colordiffuse="E5111114">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <posx>48</posx>
        <posy>{{ vscale(28) }}</posy>
        <width>960</width>
        <height>{{ vscale(52) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35036]</label>
    </control>
    <control type="list" id="101">
        <posx>30</posx>
        <posy>{{ vscale(96) }}</posy>
        <width>1000</width>
        <height>{{ vscale(810) }}</height>
        <onleft>411</onleft>
        <onright>152</onright>
        <onup>101</onup>
        <ondown>500</ondown>
        <scrolltime>160</scrolltime>
        <orientation>vertical</orientation>
        <preloaditems>4</preloaditems>
        <pagecontrol>152</pagecontrol>
        {% include "includes/current_playlist_audio_row.xml.tpl" %}
    </control>
    <control type="scrollbar" id="152">
        <left>1052</left>
        <top>{{ vscale(104) }}</top>
        <width>10</width>
        <height>{{ vscale(792) }}</height>
        <onleft>101</onleft>
        <visible>true</visible>
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

<!-- SEEK -->
<control type="group">
    <posx>90</posx>
    <posy>{{ vscale(885) }}</posy>
    <control type="button" id="500">
        <enable>Player.HasAudio</enable>
        <hitrect x="0" y="-14" w="630" h="36" />
        <width>630</width>
        <height>{{ vscale(12) }}</height>
        <onup>101</onup>
        <ondown>406</ondown>
        <texturefocus colordiffuse="30000000">script.plex/white-square-rounded.png</texturefocus>
        <texturenofocus colordiffuse="30000000">script.plex/white-square-rounded.png</texturenofocus>
    </control>
    <control type="image" id="510">
        <visible>Control.HasFocus(500)</visible>
        <posy>{{ vscale(2) }}</posy>
        <width>1</width>
        <height>{{ vscale(8) }}</height>
        <texture colordiffuse="FFFFFFFF">script.plex/white-square-6px.png</texture>
    </control>
    <control type="progress">
        <visible>!Control.HasFocus(500)</visible>
        <posy>{{ vscale(3) }}</posy>
        <width>630</width>
        <height>{{ vscale(6) }}</height>
        <texturebg>script.plex/transparent-6px.png</texturebg>
        <lefttexture>script.plex/transparent-6px.png</lefttexture>
        <midtexture colordiffuse="FFFFFFFF">script.plex/white-square-6px.png</midtexture>
        <righttexture>script.plex/transparent-6px.png</righttexture>
        <overlaytexture>script.plex/transparent-6px.png</overlaytexture>
        <info>Player.Progress</info>
    </control>
    <control type="progress">
        <visible>Control.HasFocus(500)</visible>
        <posy>{{ vscale(3) }}</posy>
        <width>630</width>
        <height>{{ vscale(6) }}</height>
        <texturebg>script.plex/transparent-6px.png</texturebg>
        <lefttexture>script.plex/transparent-6px.png</lefttexture>
        <midtexture colordiffuse="FFFFFFFF">script.plex/white-square-6px.png</midtexture>
        <righttexture>script.plex/transparent-6px.png</righttexture>
        <overlaytexture>script.plex/transparent-6px.png</overlaytexture>
        <info>Player.Progress</info>
    </control>
</control>

<!-- PLAYER CONTROLS -->
<control type="grouplist" id="400">
    <defaultcontrol>406</defaultcontrol>
    <posx>18</posx>
    <posy>{{ vscale(925) }}</posy>
    <width>756</width>
    <height>{{ vscale(124) }}</height>
    <align>center</align>
    <itemgap>-40</itemgap>
    <orientation>horizontal</orientation>
    <scrolltime tween="quadratic" easing="out">160</scrolltime>
    <usecontrolcoords>false</usecontrolcoords>
    {% include "includes/music_player_buttons.xml.tpl" with queue_style=True %}
</control>

<control type="group" id="202">
    <visible>Control.HasFocus(500) + !String.IsEmpty(Window.Property(time.selection))</visible>
    <posx>0</posx>
    <posy>{{ vscale(842) }}</posy>
    <control type="group" id="203">
        <posx>-50</posx>
        <control type="image">
            <width>101</width>
            <height>{{ vscale(39) }}</height>
            <texture colordiffuse="E5111114">script.plex/indicators/player-selection-time_box.png</texture>
        </control>
        <control type="label">
            <width>101</width>
            <height>{{ vscale(39) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(time.selection)]</label>
        </control>
    </control>
    <control type="image">
        <posx>-6</posx>
        <posy>{{ vscale(38) }}</posy>
        <width>15</width>
        <height>{{ vscale(7) }}</height>
        <texture colordiffuse="E5111114">script.plex/indicators/player-selection-time_arrow.png</texture>
    </control>
</control>
{% endblock controls %}
