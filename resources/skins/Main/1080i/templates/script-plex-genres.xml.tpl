{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>50</defaultcontrol>{% endblock %}

{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Container(101).ListItem.Property(background))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <fadetime>500</fadetime>
    <texture background="true">$INFO[Container(101).ListItem.Property(background)]</texture>
    <aspectratio>scale</aspectratio>
</control>
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
    <visible>!String.IsEmpty(Window.Property(initialized))</visible>
    <defaultcontrol always="true">101</defaultcontrol>
    <posx>160</posx>
    <posy>{{ vscale(145) }}</posy>
    <width>1600</width>
    <height>{{ vscale(935) }}</height>

    <control type="label">
        <posx>0</posx>
        <posy>0</posy>
        <width>1200</width>
        <height>{{ vscale(70) }}</height>
        <font>font45</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(screen.title)]</label>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>{{ vscale(72) }}</posy>
        <width>1200</width>
        <height>{{ vscale(38) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>AAFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(screen.context)]$INFO[Window.Property(items.count),  &#8226;  ]</label>
    </control>

    <control type="panel" id="101">
        <visible>String.IsEmpty(Window.Property(no.content))</visible>
        <posx>0</posx>
        <posy>{{ vscale(135) }}</posy>
        <width>1600</width>
        <height>{{ vscale(840) }}</height>
        <hitrect x="0" y="0" w="1600" h="840" />
        <onup>201</onup>
        <scrolltime>220</scrolltime>
        <orientation>vertical</orientation>
        <preloaditems>4</preloaditems>

        <itemlayout width="400" height="{{ vscale(280) }}">
            <control type="group">
                <posx>5</posx>
                <posy>0</posy>
                <control type="image">
                    <posx>5</posx>
                    <posy>{{ vscale(5) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <posx>5</posx>
                    <posy>{{ vscale(5) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture background="true" diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="label">
                    <posx>5</posx>
                    <posy>{{ vscale(242) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(31) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>CCFFFFFF</textcolor>
                    <scroll>false</scroll>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>
        </itemlayout>

        <focusedlayout width="400" height="{{ vscale(280) }}">
            <control type="group">
                <posx>5</posx>
                <posy>0</posy>
                <control type="group">
                    <animation effect="zoom" start="100" end="106" time="110" center="197.5,{{ vscale(113.5) }}" reversible="true" condition="Control.HasFocus(101)">Conditional</animation>
                    <control type="image">
                        <visible>Control.HasFocus(101)</visible>
                        <posx>-35</posx>
                        <posy>{{ vscale(-35) }}</posy>
                        <width>465</width>
                        <height>{{ vscale(297) }}</height>
                        <texture border="42">script.plex/drop-shadow.png</texture>
                    </control>
                    <control type="image">
                        <visible>Control.HasFocus(101)</visible>
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>395</width>
                        <height>{{ vscale(227) }}</height>
                        <texture>script.plex/landscape-hub-rounded-focus.png</texture>
                    </control>
                    <control type="image">
                        <posx>5</posx>
                        <posy>{{ vscale(5) }}</posy>
                        <width>385</width>
                        <height>{{ vscale(217) }}</height>
                        <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                    <control type="image">
                        <posx>5</posx>
                        <posy>{{ vscale(5) }}</posy>
                        <width>385</width>
                        <height>{{ vscale(217) }}</height>
                        <texture background="true" diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                </control>
                <!-- Keep the caption optically stable while only the artwork plate lifts. -->
                <control type="label">
                    <posx>5</posx>
                    <posy>{{ vscale(242) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(31) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <scroll>false</scroll>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>
        </focusedlayout>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(Window.Property(no.content))</visible>
        <posx>0</posx>
        <posy>{{ vscale(230) }}</posy>
        <width>1600</width>
        <height>{{ vscale(280) }}</height>
        <control type="image">
            <posx>280</posx>
            <posy>0</posy>
            <width>1040</width>
            <height>{{ vscale(240) }}</height>
            <texture border="34" colordiffuse="D90D0D10">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="label">
            <posx>330</posx>
            <posy>{{ vscale(70) }}</posy>
            <width>940</width>
            <height>{{ vscale(70) }}</height>
            <font>font13</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$ADDON[script.plexmod 32452]</label>
        </control>
    </control>
</control>
{% endblock content %}
