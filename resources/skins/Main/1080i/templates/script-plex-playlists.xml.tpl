{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block header_bgfade %}{% endblock %}
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
{% block topleft_add %}
<control type="label">
    <width max="500">auto</width>
    <height>{{ vscale(40) }}</height>
    <font>font12</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>FFFFFFFF</textcolor>
    <label>$ADDON[script.plexmod 32333]</label>
</control>
{% endblock %}
{% block content %}
<control type="group" id="50">
    <posx>0</posx>
    <posy>{{ vscale(145) }}</posy>
    <defaultcontrol always="true">101</defaultcontrol>

    <control type="group" id="100">
        <visible>Integer.IsGreater(Container(101).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>101</defaultcontrol>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>{{ vscale(380) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>1600</width>
            <height>{{ vscale(80) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32048]</label>
        </control>
        <control type="list" id="101">
            <posx>100</posx>
            <posy>{{ vscale(30) }}</posy>
            <width>1740</width>
            <height>{{ vscale(390) }}</height>
            <onup>200</onup>
            <ondown condition="Integer.IsGreater(Container(301).NumItems,0)">301</ondown>
            <ondown condition="!Integer.IsGreater(Container(301).NumItems,0)">101</ondown>
            <scrolltime>200</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>2</preloaditems>
            <!-- ITEM LAYOUT ########################################## -->
            <itemlayout width="287">
                <control type="group">
                    <posx>55</posx>
                    <posy>{{ vscale(40) }}</posy>
                    <control type="group">
                        <posx>5</posx>
                        <posy>{{ vscale(5) }}</posy>
                        <control type="image">
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>238</width>
                            <height>{{ vscale(238) }}</height>
                            <texture diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="image">
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>238</width>
                            <height>{{ vscale(238) }}</height>
                            <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="label">
                            <scroll>false</scroll>
                            <posx>0</posx>
                            <posy>{{ vscale(248) }}</posy>
                            <width>238</width>
                            <height>{{ vscale(40) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[ListItem.Label]</label>
                        </control>
                        <control type="label">
                            <scroll>false</scroll>
                            <posx>0</posx>
                            <posy>{{ vscale(278) }}</posy>
                            <width>238</width>
                            <height>{{ vscale(40) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[ListItem.Label2]</label>
                        </control>
                    </control>
                </control>
            </itemlayout>

            <!-- FOCUSED LAYOUT ####################################### -->
            <focusedlayout width="287">
                <control type="group">
                    <posx>55</posx>
                    <posy>{{ vscale(40) }}</posy>
                    <control type="group">
                        <animation effect="zoom" start="100" end="106" time="120" center="124,{{ vscale(124) }}" reversible="false">Focus</animation>
                        <animation effect="zoom" start="106" end="100" time="100" center="124,{{ vscale(124) }}" reversible="false">UnFocus</animation>
                        <posx>0</posx>
                        <posy>0</posy>
                        <control type="image">
                            <visible>Control.HasFocus(101)</visible>
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>248</width>
                            <height>{{ vscale(248) }}</height>
                            <texture>script.plex/square-playlist-rounded-focus.png</texture>
                        </control>
                        <control type="group">
                            <posx>5</posx>
                            <posy>{{ vscale(5) }}</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>238</width>
                                <height>{{ vscale(238) }}</height>
                                <texture diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>238</width>
                                <height>{{ vscale(238) }}</height>
                                <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(248) }}</posy>
                                <width>238</width>
                                <height>{{ vscale(40) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(278) }}</posy>
                                <width>238</width>
                                <height>{{ vscale(40) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                        </control>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>

    <control type="group" id="300">
        <visible>Integer.IsGreater(Container(301).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <animation effect="slide" end="0,{{ vscale(-420) }}" condition="!Control.IsVisible(100)">Conditional</animation>
        <defaultcontrol>301</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(440) }}</posy>
        <width>1920</width>
        <height>{{ vscale(360) }}</height>
        <control type="image">
            <visible>Control.IsVisible(100)</visible>
            <posx>160</posx>
            <posy>0</posy>
            <width>1600</width>
            <height>{{ vscale(2) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>661F1F1F</colordiffuse>
        </control>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>1600</width>
            <height>{{ vscale(80) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32053]</label>
        </control>
        <control type="list" id="301">
            <posx>100</posx>
            <posy>{{ vscale(30) }}</posy>
            <width>1740</width>
            <height>{{ vscale(515) }}</height>
            <onup condition="Integer.IsGreater(Container(101).NumItems,0)">101</onup>
            <onup condition="!Integer.IsGreater(Container(101).NumItems,0)">200</onup>
            <ondown>301</ondown>
            <scrolltime>200</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>2</preloaditems>
            <!-- ITEM LAYOUT ########################################## -->
            <itemlayout width="550">
                <control type="group">
                    <posx>35</posx>
                    <posy>{{ vscale(40) }}</posy>
                    <control type="group">
                        <posx>25</posx>
                        <posy>{{ vscale(25.5) }}</posy>
                        <control type="image">
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>520</width>
                            <height>{{ vscale(293) }}</height>
                            <texture diffuse="script.plex/episode-hero-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="image">
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>520</width>
                            <height>{{ vscale(293) }}</height>
                            <texture background="true" diffuse="script.plex/episode-hero-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="label">
                            <scroll>false</scroll>
                            <posx>0</posx>
                            <posy>{{ vscale(303) }}</posy>
                            <width>520</width>
                            <height>{{ vscale(40) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[ListItem.Label]</label>
                        </control>
                        <control type="label">
                            <scroll>false</scroll>
                            <posx>0</posx>
                            <posy>{{ vscale(333) }}</posy>
                            <width>520</width>
                            <height>{{ vscale(40) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[ListItem.Label2]</label>
                        </control>
                    </control>
                </control>
            </itemlayout>

            <!-- FOCUSED LAYOUT ####################################### -->
            <focusedlayout width="550">
                <control type="group">
                    <posx>35</posx>
                    <posy>{{ vscale(40) }}</posy>
                    <control type="group">
                        <animation effect="zoom" start="100" end="106" time="120" center="285,{{ vscale(172) }}" reversible="false">Focus</animation>
                        <animation effect="zoom" start="106" end="100" time="100" center="285,{{ vscale(172) }}" reversible="false">UnFocus</animation>
                        <posx>0</posx>
                        <posy>0</posy>
                        <control type="image">
                            <visible>Control.HasFocus(301)</visible>
                            <posx>20</posx>
                            <posy>{{ vscale(20.5) }}</posy>
                            <width>530</width>
                            <height>{{ vscale(303) }}</height>
                            <texture>script.plex/landscape-playlist-rounded-focus.png</texture>
                        </control>
                        <control type="group">
                            <posx>25</posx>
                            <posy>{{ vscale(25.5) }}</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>520</width>
                                <height>{{ vscale(293) }}</height>
                                <texture diffuse="script.plex/episode-hero-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>520</width>
                                <height>{{ vscale(293) }}</height>
                                <texture background="true" diffuse="script.plex/episode-hero-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(303) }}</posy>
                                <width>520</width>
                                <height>{{ vscale(40) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(333) }}</posy>
                                <width>520</width>
                                <height>{{ vscale(40) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                        </control>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>
</control>
{% endblock content %}
