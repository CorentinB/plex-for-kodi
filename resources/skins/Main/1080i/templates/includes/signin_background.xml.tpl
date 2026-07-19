<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture background="true">script.plex/home/background-fallback_black.png</texture>
</control>
<control type="image">
    <posx>0</posx>
    <posy>{% if core.needs_scaling %}{{ vperc(vscale(1080)) }}{% else %}0{% endif %}</posy>
    <width>1920</width>
    <height>{{ vscale(1080) }}</height>
    <texture background="true">script.plex/sign_in/back.jpg</texture>
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
<control type="image">
    <posx>160</posx>
    <posy>{{ vscale(88) }}</posy>
    <width>186</width>
    <height>{{ vscale(86) }}</height>
    <texture>script.plex/home/plex.png</texture>
    <aspectratio>keep</aspectratio>
</control>
