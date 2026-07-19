{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block controls %}
{% include "includes/signin_background.xml.tpl" %}

<control type="image">
    <posx>160</posx>
    <posy>{{ vscale(270) }}</posy>
    <width>1040</width>
    <height>{{ vscale(480) }}</height>
    <texture colordiffuse="E60B0B0B" border="30">script.plex/white-square-rounded.png</texture>
</control>
<control type="label">
    <posx>214</posx>
    <posy>{{ vscale(316) }}</posy>
    <width>920</width>
    <height>{{ vscale(64) }}</height>
    <font>font30_title</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>FFFFFFFF</textcolor>
    <label>$ADDON[script.plexmod 35030]</label>
</control>

<control type="textbox">
    <posx>214</posx>
    <posy>{{ vscale(410) }}</posy>
    <width>920</width>
    <height>{{ vscale(180) }}</height>
    <font>font13</font>
    <textcolor>CCFFFFFF</textcolor>
    <align>left</align>
    <autoscroll>false</autoscroll>
    <label>$INFO[Window.Property(message)]</label>
</control>

<control type="button" id="100">
    <posx>214</posx>
    <posy>{{ vscale(626) }}</posy>
    <width>190</width>
    <height>{{ vscale(70) }}</height>
    <onleft>100</onleft>
    <onright>100</onright>
    <onup>100</onup>
    <ondown>100</ondown>
    <font>font13</font>
    <textcolor>FFFFFFFF</textcolor>
    <focusedcolor>FF111111</focusedcolor>
    <align>center</align>
    <aligny>center</aligny>
    <texturefocus colordiffuse="F2FFFFFF" border="28">script.plex/white-square-rounded.png</texturefocus>
    <texturenofocus colordiffuse="33FFFFFF" border="28">script.plex/white-square-rounded.png</texturenofocus>
    <label>$LOCALIZE[186]</label>
</control>
{% endblock %}
