{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block controls %}
{% include "includes/signin_background.xml.tpl" %}

<control type="group">
    <visible>String.IsEmpty(Window.Property(pin.image.0)) + String.IsEmpty(Window.Property(linking))</visible>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(330) }}</posy>
        <width>980</width>
        <height>{{ vscale(84) }}</height>
        <font>font60</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35026]</label>
    </control>
    <control type="image">
        <posx>160</posx>
        <posy>{{ vscale(455) }}</posy>
        <width>76</width>
        <height>{{ vscale(76) }}</height>
        <texture>script.plex/busy.gif</texture>
    </control>
</control>

<control type="group">
    <visible>!String.IsEmpty(Window.Property(linking))</visible>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(330) }}</posy>
        <width>980</width>
        <height>{{ vscale(84) }}</height>
        <font>font60</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35027]</label>
    </control>
    <control type="image">
        <posx>160</posx>
        <posy>{{ vscale(455) }}</posy>
        <width>76</width>
        <height>{{ vscale(76) }}</height>
        <texture>script.plex/busy.gif</texture>
    </control>
</control>

<control type="group">
    <visible>!String.IsEmpty(Window.Property(pin.image.0))</visible>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(280) }}</posy>
        <width>1100</width>
        <height>{{ vscale(84) }}</height>
        <font>font60</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35023]</label>
    </control>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(382) }}</posy>
        <width>1100</width>
        <height>{{ vscale(54) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>BBFFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35024]</label>
    </control>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(455) }}</posy>
        <width>720</width>
        <height>{{ vscale(44) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>88FFFFFF</textcolor>
        <label>$ADDON[script.plexmod 35025]</label>
    </control>

    <control type="grouplist" id="400">
        <posx>160</posx>
        <posy>{{ vscale(515) }}</posy>
        <width>740</width>
        <height>{{ vscale(174) }}</height>
        <align>left</align>
        <itemgap>20</itemgap>
        <orientation>horizontal</orientation>
        {% for digit in range(4) %}
        <control type="group">
            <width>150</width>
            <height>{{ vscale(174) }}</height>
            <control type="image">
                <posx>0</posx>
                <posy>0</posy>
                <width>150</width>
                <height>{{ vscale(174) }}</height>
                <texture colordiffuse="D9121212" border="28">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="image">
                <posx>22</posx>
                <posy>{{ vscale(34) }}</posy>
                <width>106</width>
                <height>{{ vscale(106) }}</height>
                <texture>$INFO[Window.Property(pin.image.{{ digit }})]</texture>
                <aspectratio>keep</aspectratio>
            </control>
        </control>
        {% endfor %}
    </control>
</control>

<control type="button" id="100">
    <posx>160</posx>
    <posy>{{ vscale(770) }}</posy>
    <width>220</width>
    <height>{{ vscale(68) }}</height>
    <onleft>100</onleft>
    <onright>100</onright>
    <onup>100</onup>
    <ondown>100</ondown>
    <font>font12</font>
    <textcolor>CCFFFFFF</textcolor>
    <focusedcolor>FF111111</focusedcolor>
    <align>center</align>
    <aligny>center</aligny>
    <texturefocus colordiffuse="F2FFFFFF" border="28">script.plex/white-square-rounded.png</texturefocus>
    <texturenofocus colordiffuse="26000000" border="28">script.plex/white-square-rounded.png</texturenofocus>
    <label>$LOCALIZE[222]</label>
</control>
{% endblock controls %}
