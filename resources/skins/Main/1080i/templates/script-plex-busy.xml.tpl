{% extends "base.xml.tpl" %}
{% block backgroundcolor %}{% endblock %}
{% block controls %}
<control type="group">
    <animation effect="fade" start="0" end="100">WindowOpen</animation>
    <control type="image">
        <posx>856</posx>
        <posy>{{ vperc(vscale(168)) }}</posy>
        <width>208</width>
        <height>{{ vscale(168) }}</height>
        <texture colordiffuse="E60B0B0B" border="32">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <posx>915</posx>
        <posy>{{ vperc(vscale(76)) }}</posy>
        <width>90</width>
        <height>{{ vscale(76) }}</height>
        <texture diffuse="script.plex/busy-diffuse.png">script.plex/busy.gif</texture>
    </control>
</control>
{% endblock controls %}
