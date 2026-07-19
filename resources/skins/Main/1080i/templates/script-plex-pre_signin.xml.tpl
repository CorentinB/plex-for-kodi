{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block controls %}
{% include "includes/signin_background.xml.tpl" %}

<control type="label">
    <posx>160</posx>
    <posy>{{ vscale(278) }}</posy>
    <width>1030</width>
    <height>{{ vscale(92) }}</height>
    <font>font60</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>FFFFFFFF</textcolor>
    <label>$ADDON[script.plexmod 35020]</label>
</control>
<control type="textbox">
    <posx>160</posx>
    <posy>{{ vscale(390) }}</posy>
    <width>820</width>
    <height>{{ vscale(150) }}</height>
    <font>font13</font>
    <align>left</align>
    <textcolor>CCFFFFFF</textcolor>
    <autoscroll>false</autoscroll>
    <label>$ADDON[script.plexmod 35021]</label>
</control>
<control type="label">
    <posx>160</posx>
    <posy>{{ vscale(704) }}</posy>
    <width>720</width>
    <height>{{ vscale(48) }}</height>
    <font>font10</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>99FFFFFF</textcolor>
    <label>$ADDON[script.plexmod 35022]</label>
</control>

<control type="button" id="100">
    <posx>160</posx>
    <posy>{{ vscale(770) }}</posy>
    <width>330</width>
    <height>{{ vscale(72) }}</height>
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
    <texturenofocus colordiffuse="33000000" border="28">script.plex/white-square-rounded.png</texturenofocus>
    <label>$ADDON[script.plexmod 32460]</label>
</control>
{% endblock controls %}
