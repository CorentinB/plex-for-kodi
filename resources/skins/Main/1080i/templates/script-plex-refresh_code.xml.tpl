{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block controls %}
{% include "includes/signin_background.xml.tpl" %}

<control type="label">
    <posx>160</posx>
    <posy>{{ vscale(306) }}</posy>
    <width>960</width>
    <height>{{ vscale(84) }}</height>
    <font>font60</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>FFFFFFFF</textcolor>
    <label>$ADDON[script.plexmod 35028]</label>
</control>
<control type="label">
    <posx>160</posx>
    <posy>{{ vscale(414) }}</posy>
    <width>880</width>
    <height>{{ vscale(58) }}</height>
    <font>font13</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>AAFFFFFF</textcolor>
    <label>$ADDON[script.plexmod 35029]</label>
</control>

<control type="button" id="100">
    <posx>160</posx>
    <posy>{{ vscale(560) }}</posy>
    <width>300</width>
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
    <texturenofocus colordiffuse="33FFFFFF" border="28">script.plex/white-square-rounded.png</texturenofocus>
    <label>$ADDON[script.plexmod 35031]</label>
</control>
{% endblock controls %}
