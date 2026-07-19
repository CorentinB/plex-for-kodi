{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>150</defaultcontrol>{% endblock %}

{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture>script.plex/home/tvos-background-wash.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <defaultcontrol always="true">150</defaultcontrol>
    <posx>160</posx>
    <posy>{{ vscale(145) }}</posy>
    <width>1600</width>
    <height>{{ vscale(900) }}</height>

    <!-- Artwork column: each source keeps its native aspect-specific mask. -->
    <control type="group">
        <posx>0</posx>
        <posy>{{ vscale(50) }}</posy>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(is.poster))</visible>
            <control type="image">
                <posx>-18</posx>
                <posy>{{ vscale(-18) }}</posy>
                <width>416</width>
                <height>{{ vscale(603) }}</height>
                <texture border="48" colordiffuse="66000000">script.plex/square-rounded-shadow.png</texture>
            </control>
            <control type="image">
                <width>380</width>
                <height>{{ vscale(567) }}</height>
                <texture diffuse="script.plex/poster-rounded-mask.png">$INFO[Window.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>380</width>
                <height>{{ vscale(567) }}</height>
                <texture background="true" diffuse="script.plex/poster-rounded-mask.png">$INFO[Window.Property(thumb)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
        </control>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(is.square))</visible>
            <control type="image">
                <posx>-18</posx>
                <posy>{{ vscale(-18) }}</posy>
                <width>416</width>
                <height>{{ vscale(416) }}</height>
                <texture border="48" colordiffuse="66000000">script.plex/square-rounded-shadow.png</texture>
            </control>
            <control type="image">
                <width>380</width>
                <height>{{ vscale(380) }}</height>
                <texture diffuse="script.plex/square-rounded-mask.png">$INFO[Window.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>380</width>
                <height>{{ vscale(380) }}</height>
                <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[Window.Property(thumb)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
        </control>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(is.16x9))</visible>
            <control type="image">
                <posx>-18</posx>
                <posy>{{ vscale(-18) }}</posy>
                <width>556</width>
                <height>{{ vscale(329) }}</height>
                <texture border="48" colordiffuse="66000000">script.plex/square-rounded-shadow.png</texture>
            </control>
            <control type="image">
                <width>520</width>
                <height>{{ vscale(293) }}</height>
                <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[Window.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>520</width>
                <height>{{ vscale(293) }}</height>
                <texture background="true" diffuse="script.plex/landscape-rounded-mask.png">$INFO[Window.Property(thumb)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
        </control>
    </control>

    <!-- One stable text rail, shared by poster, square, and landscape info. -->
    <control type="textbox">
        <posx>600</posx>
        <posy>0</posy>
        <width>1000</width>
        <height>{{ vscale(118) }}</height>
        <font>font60</font>
        <align>left</align>
        <textcolor>FFFFFFFF</textcolor>
        <autoscroll>false</autoscroll>
        <label>$INFO[Window.Property(title.main)]</label>
    </control>
    <control type="label">
        <posx>600</posx>
        <posy>{{ vscale(122) }}</posy>
        <width>1000</width>
        <height>{{ vscale(42) }}</height>
        <font>font12</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>AAFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(title.sub)]</label>
    </control>

    <control type="textbox">
        <visible>!String.IsEmpty(Window.Property(info.media))</visible>
        <posx>600</posx>
        <posy>{{ vscale(185) }}</posy>
        <width>1000</width>
        <height>{{ vscale(150) }}</height>
        <font>font12</font>
        <align>left</align>
        <textcolor>EEFFFFFF</textcolor>
        <autoscroll>false</autoscroll>
        <label>$INFO[Window.Property(info.summary)]</label>
    </control>
    <control type="textbox">
        <visible>String.IsEmpty(Window.Property(info.media))</visible>
        <posx>600</posx>
        <posy>{{ vscale(185) }}</posy>
        <width>1000</width>
        <height>{{ vscale(500) }}</height>
        <font>font12</font>
        <align>left</align>
        <textcolor>EEFFFFFF</textcolor>
        <autoscroll>false</autoscroll>
        <label>$INFO[Window.Property(info.summary)]</label>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(Window.Property(info.media))</visible>
        <posx>600</posx>
        <posy>{{ vscale(365) }}</posy>
        <width>1000</width>
        <height>{{ vscale(390) }}</height>
        <control type="image">
            <width>1000</width>
            <height>{{ vscale(390) }}</height>
            <texture border="34" colordiffuse="D90D0D10">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="label">
            <posx>34</posx>
            <posy>{{ vscale(18) }}</posy>
            <width>900</width>
            <height>{{ vscale(48) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35039]</label>
        </control>
        <control type="textbox">
            <posx>34</posx>
            <posy>{{ vscale(76) }}</posy>
            <pagecontrol>152</pagecontrol>
            <width>890</width>
            <height>{{ vscale(280) }}</height>
            <font>font10</font>
            <align>left</align>
            <textcolor>CCFFFFFF</textcolor>
            <autoscroll>false</autoscroll>
            <label>$INFO[Window.Property(info.media)]</label>
        </control>
        <control type="scrollbar" id="152">
            <left>952</left>
            <top>76</top>
            <width>6</width>
            <height>{{ vscale(280) }}</height>
            <visible>true</visible>
            <texturesliderbackground colordiffuse="20FFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbackground>
            <texturesliderbar colordiffuse="88FFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbar>
            <texturesliderbarfocus colordiffuse="FFFFFFFF" border="5">script.plex/white-square-rounded.png</texturesliderbarfocus>
            <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
            <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
            <pulseonselect>false</pulseonselect>
            <orientation>vertical</orientation>
            <showonepage>false</showonepage>
            <onup>201</onup>
            <ondown>150</ondown>
            <onleft>150</onleft>
            <onright>152</onright>
        </control>
    </control>

    <control type="button" id="150">
        <posx>600</posx>
        <posy>{{ vscale(790) }}</posy>
        <width>190</width>
        <height>{{ vscale(66) }}</height>
        <font>font12</font>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>DDFFFFFF</textcolor>
        <focusedcolor>FF111111</focusedcolor>
        <texturefocus colordiffuse="FFF7F7F7" border="28">script.plex/white-square-rounded.png</texturefocus>
        <texturenofocus colordiffuse="33000000" border="28">script.plex/white-square-rounded.png</texturenofocus>
        <onleft>150</onleft>
        <onright>150</onright>
        <onup condition="!String.IsEmpty(Window.Property(info.media))">152</onup>
        <onup condition="String.IsEmpty(Window.Property(info.media))">201</onup>
        <ondown>150</ondown>
        <label>$ADDON[script.plexmod 35040]</label>
    </control>
</control>
{% endblock content %}
