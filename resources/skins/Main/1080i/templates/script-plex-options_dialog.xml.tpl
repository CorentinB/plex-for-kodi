{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>1001</defaultcontrol>{% endblock %}
{% block backgroundcolor %}{% endblock %}
{% block controls %}
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="B3000000">script.plex/white-square.png</texture>
</control>
<control type="group">
    <visible>!String.IsEmpty(Window.Property(initialized))</visible>
    <posx>580</posx>
    <posy>{{ vperc(vscale(480)) }}</posy>
    <control type="image">
        <posx>-40</posx>
        <posy>{{ vscale(-40) }}</posy>
        <width>840</width>
        <height>{{ vscale(480) }}</height>
        <texture border="42">script.plex/drop-shadow.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>760</width>
        <height>{{ vscale(400) }}</height>
        <texture colordiffuse="F20B0B0B" border="28">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>760</width>
        <height>{{ vscale(80) }}</height>
        <texture colordiffuse="DD151515" border="28">script.plex/white-square-top-rounded.png</texture>
    </control>

    <control type="label">
        <posx>48</posx>
        <posy>0</posy>
        <width>664</width>
        <height>{{ vscale(80) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(header)]</label>
    </control>

    <control type="textbox">
        <posx>48</posx>
        <posy>{{ vscale(108) }}</posy>
        <width>664</width>
        <height>{{ vscale(130) }}</height>
        <font>font10</font>
        <align>left</align>
        <textcolor>FFFFFFFF</textcolor>
        <scrolltime>200</scrolltime>
        <autoscroll>false</autoscroll>
        <label>$INFO[Window.Property(info)]</label>
    </control>

    <control type="grouplist" id="100">
        <defaultcontrol always="true">1001</defaultcontrol>
        <posx>48</posx>
        <posy>{{ vscale(288) }}</posy>
        <width>664</width>
        <height>{{ vscale(64) }}</height>
        <align>center</align>
        <itemgap>18</itemgap>
        <orientation>horizontal</orientation>
        <scrolltime>0</scrolltime>
        <usecontrolcoords>true</usecontrolcoords>
        {% include "includes/options_dialog_button.xml.tpl" with id=1001 & index=0 %}
        {% include "includes/options_dialog_button.xml.tpl" with id=1002 & index=1 %}
        {% include "includes/options_dialog_button.xml.tpl" with id=1003 & index=2 %}
    </control>

</control>
{% endblock controls %}
