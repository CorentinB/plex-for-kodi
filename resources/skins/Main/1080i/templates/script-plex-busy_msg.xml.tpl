{% extends "base.xml.tpl" %}
{% block backgroundcolor %}{% endblock %}
{% block controls %}
<control type="group">
    <posx>0</posx>
    <posy>0</posy>
    <animation effect="fade" start="0" end="100">WindowOpen</animation>
    <control type="image">
        <posx>690</posx>
        <posy>{{ vperc(vscale(170)) }}</posy>
        <width>540</width>
        <height>{{ vscale(170) }}</height>
        <texture colordiffuse="E60B0B0B" border="32">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <posx>730</posx>
        <posy>{{ vperc(vscale(170)) }}</posy>
        <width>460</width>
        <height>{{ vscale(170) }}</height>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$INFO[Window.Property(message)]</label>
        <font>font13</font>
    </control>
</control>
{% endblock controls %}
