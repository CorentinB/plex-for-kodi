{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block controls %}
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture background="true" fallback="script.plex/home/background-fallback.png">$INFO[Window.Property(background)]</texture>
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
    <texture colordiffuse="55000000">script.plex/white-square.png</texture>
</control>

<control type="group">
    <posx>210</posx>
    <posy>{{ vscale(125) }}</posy>
    <width>1500</width>
    <height>{{ vscale(830) }}</height>
    <control type="image">
        <posx>-28</posx>
        <posy>{{ vscale(-28) }}</posy>
        <width>1556</width>
        <height>{{ vscale(886) }}</height>
        <texture border="48" colordiffuse="99000000">script.plex/square-rounded-shadow.png</texture>
    </control>
    <control type="image">
        <width>1500</width>
        <height>{{ vscale(830) }}</height>
        <texture border="44" colordiffuse="E5111114">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(track.thumb))</visible>
        <posx>70</posx>
        <posy>{{ vscale(88) }}</posy>
        <width>480</width>
        <height>{{ vscale(480) }}</height>
        <texture fallback="script.plex/thumb_fallbacks/music.png" diffuse="script.plex/square-rounded-mask.png">$INFO[Window.Property(track.thumb)]</texture>
        <aspectratio>scale</aspectratio>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(track.thumb))</visible>
        <posx>60</posx>
        <posy>{{ vscale(78) }}</posy>
        <width>500</width>
        <height>{{ vscale(500) }}</height>
        <texture colordiffuse="44FFFFFF">script.plex/square-rounded-outline.png</texture>
    </control>
    <control type="textbox">
        <posx>640</posx>
        <posy>{{ vscale(100) }}</posy>
        <width>760</width>
        <height>{{ vscale(540) }}</height>
        <font>font13</font>
        <textcolor>FFFFFFFF</textcolor>
        <align>left</align>
        <autoscroll>false</autoscroll>
        <label>$INFO[Window.Property(message)]</label>
    </control>
    <control type="label">
        <posx>640</posx>
        <posy>{{ vscale(690) }}</posy>
        <width>760</width>
        <height>{{ vscale(40) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>88FFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35037]</label>
    </control>
</control>

<control type="button" id="100">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texturefocus>script.plex/transparent-6px.png</texturefocus>
    <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
    <label> </label>
</control>
{% endblock controls %}
