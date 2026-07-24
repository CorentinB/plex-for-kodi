{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>101</defaultcontrol>{% endblock %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(album.background.blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture background="true">$INFO[Window.Property(album.background.blurred)]</texture>
    <aspectratio>scale</aspectratio>
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
    <texture colordiffuse="22000000">script.plex/white-square.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <posx>0</posx>
    <posy>{{ vscale(145) }}</posy>
    <width>1920</width>
    <height>{{ vscale(875) }}</height>
    <defaultcontrol>101</defaultcontrol>

    <control type="group">
        <posx>160</posx>
        <posy>0</posy>
        <width>520</width>
        <height>{{ vscale(835) }}</height>
        <control type="label">
            <posx>0</posx>
            <posy>0</posy>
            <width>520</width>
            <height>{{ vscale(58) }}</height>
            <font>font_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(album.title)]</label>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(62) }}</posy>
            <width>430</width>
            <height>{{ vscale(35) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>B8FFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(artist.title)]</label>
        </control>
        <control type="label">
            <right>0</right>
            <posy>{{ vscale(62) }}</posy>
            <width>80</width>
            <height>{{ vscale(35) }}</height>
            <font>font12</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>88FFFFFF</textcolor>
            <label>$INFO[Window.Property(album.year)]</label>
        </control>

        <control type="image">
            <posx>-20</posx>
            <posy>{{ vscale(105) }}</posy>
            <width>540</width>
            <height>{{ vscale(540) }}</height>
            <texture border="40">script.plex/square-rounded-shadow.png</texture>
        </control>
        <control type="image">
            <posx>-4</posx>
            <posy>{{ vscale(121) }}</posy>
            <width>508</width>
            <height>{{ vscale(508) }}</height>
            <texture colordiffuse="34FFFFFF">script.plex/square-detail-rounded-plate.png</texture>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(125) }}</posy>
            <width>500</width>
            <height>{{ vscale(500) }}</height>
            <texture diffuse="script.plex/square-rounded-mask.png">script.plex/thumb_fallbacks/music.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(125) }}</posy>
            <width>500</width>
            <height>{{ vscale(500) }}</height>
            <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[Window.Property(album.thumb)]</texture>
            <aspectratio>scale</aspectratio>
        </control>

        <control type="grouplist" id="300">
            <defaultcontrol always="true">301</defaultcontrol>
            <posx>0</posx>
            <posy>{{ vscale(660) }}</posy>
            <width>600</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>101</ondown>
            <onright>101</onright>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <align>left</align>
            <scrolltime>160</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            {% with template = "includes/themed_button.xml.tpl" & playlist_style = True & light_plate = True %}
                {% include template with name="play" & id=301 & action_label="$LOCALIZE[208]" & action_width=140 & action_label_width=68 %}
                {% include template with name="shuffle" & id=302 & action_label="$ADDON[script.plexmod 32935]" & action_width=300 & action_label_width=228 %}
                {% include template with name="more" & id=303 & action_label="$ADDON[script.plexmod 32307]" & action_width=130 & action_label_width=58 %}
            {% endwith %}
        </control>
    </control>

    <control type="group" id="100">
        <visible>Integer.IsGreater(Container(101).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>101</defaultcontrol>
        <posx>760</posx>
        <posy>0</posy>
        <width>1000</width>
        <height>{{ vscale(835) }}</height>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1000</width>
            <height>{{ vscale(835) }}</height>
            <texture border="18">script.plex/white-square-rounded.png</texture>
            <colordiffuse>66151517</colordiffuse>
        </control>
        <control type="label">
            <posx>32</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(58) }}</height>
            <font>font_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35034]</label>
        </control>
        <control type="list" id="101">
            <posx>20</posx>
            <posy>{{ vscale(66) }}</posy>
            <width>950</width>
            <height>{{ vscale(750) }}</height>
            <onup>200</onup>
            <onright condition="Integer.IsGreater(Container(101).NumPages,1)">152</onright>
            <onright condition="!Integer.IsGreater(Container(101).NumPages,1)">noop</onright>
            <onleft>300</onleft>
            <scrolltime>180</scrolltime>
            <orientation>vertical</orientation>
            <preloaditems>4</preloaditems>
            <pagecontrol>152</pagecontrol>
            <itemlayout height="{{ vscale(68) }}">
                <control type="group">
                    <visible>String.IsEmpty(ListItem.Property(is.header))</visible>
                    <posx>12</posx>
                    <posy>{{ vscale(2) }}</posy>
                    <control type="label">
                        <visible>!String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
                        <posx>20</posx>
                        <posy>0</posy>
                        <width>55</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(track.number)]</label>
                    </control>
                    <control type="image">
                        <visible>String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
                        <posx>34</posx>
                        <posy>{{ vscale(21) }}</posy>
                        <width>22</width>
                        <height>{{ vscale(22) }}</height>
                        <texture colordiffuse="FFFFFFFF">script.plex/indicators/playing-circle.png</texture>
                    </control>
                    <control type="label">
                        <posx>95</posx>
                        <posy>0</posy>
                        <width>690</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font12</font>
                        <align>left</align>
                        <aligny>center</aligny>
                        <textcolor>E8FFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                    <control type="label">
                        <posx>800</posx>
                        <posy>0</posy>
                        <width>100</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>right</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(track.duration)]</label>
                    </control>
                    <control type="image">
                        <visible>String.IsEmpty(ListItem.Property(is.footer))</visible>
                        <posx>18</posx>
                        <posy>{{ vscale(66) }}</posy>
                        <width>880</width>
                        <height>{{ vscale(1) }}</height>
                        <texture colordiffuse="18FFFFFF">script.plex/white-square-1px.png</texture>
                    </control>
                </control>
                <control type="label">
                    <visible>!String.IsEmpty(ListItem.Property(is.header))</visible>
                    <posx>32</posx>
                    <posy>{{ vscale(2) }}</posy>
                    <width>860</width>
                    <height>{{ vscale(64) }}</height>
                    <font>font12</font>
                    <align>left</align>
                    <aligny>center</aligny>
                    <textcolor>B8FFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </itemlayout>
            <focusedlayout height="{{ vscale(68) }}">
                <control type="group">
                    <visible>String.IsEmpty(ListItem.Property(is.header)) + !Control.HasFocus(101)</visible>
                    <posx>12</posx>
                    <posy>{{ vscale(2) }}</posy>
                    <control type="image">
                        <posx>8</posx>
                        <posy>{{ vscale(3) }}</posy>
                        <width>890</width>
                        <height>{{ vscale(58) }}</height>
                        <texture border="16">script.plex/white-square-rounded.png</texture>
                        <colordiffuse>18FFFFFF</colordiffuse>
                    </control>
                    <control type="label">
                        <posx>20</posx>
                        <width>55</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(track.number)]</label>
                    </control>
                    <control type="label">
                        <posx>95</posx>
                        <width>690</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font12</font>
                        <align>left</align>
                        <aligny>center</aligny>
                        <textcolor>E8FFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                    <control type="label">
                        <posx>800</posx>
                        <width>100</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>right</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(track.duration)]</label>
                    </control>
                </control>
                <control type="group">
                    <visible>String.IsEmpty(ListItem.Property(is.header)) + Control.HasFocus(101)</visible>
                    <posx>12</posx>
                    <posy>{{ vscale(2) }}</posy>
                    <animation effect="zoom" start="100" end="102" time="100" center="458,{{ vscale(32) }}" reversible="true" condition="Control.HasFocus(101)">Conditional</animation>
                    <control type="image">
                        <posx>8</posx>
                        <posy>{{ vscale(3) }}</posy>
                        <width>890</width>
                        <height>{{ vscale(58) }}</height>
                        <texture border="16">script.plex/white-square-rounded.png</texture>
                        <colordiffuse>F2FFFFFF</colordiffuse>
                    </control>
                    <control type="label">
                        <visible>!String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
                        <posx>20</posx>
                        <width>55</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>AA111111</textcolor>
                        <label>$INFO[ListItem.Property(track.number)]</label>
                    </control>
                    <control type="image">
                        <visible>String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
                        <posx>34</posx>
                        <posy>{{ vscale(21) }}</posy>
                        <width>22</width>
                        <height>{{ vscale(22) }}</height>
                        <texture colordiffuse="FF111111">script.plex/indicators/playing-circle.png</texture>
                    </control>
                    <control type="label">
                        <posx>95</posx>
                        <width>690</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font12</font>
                        <align>left</align>
                        <aligny>center</aligny>
                        <textcolor>FF111111</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                    <control type="label">
                        <posx>800</posx>
                        <width>100</width>
                        <height>{{ vscale(64) }}</height>
                        <font>font10</font>
                        <align>right</align>
                        <aligny>center</aligny>
                        <textcolor>AA111111</textcolor>
                        <label>$INFO[ListItem.Property(track.duration)]</label>
                    </control>
                </control>
                <control type="label">
                    <visible>!String.IsEmpty(ListItem.Property(is.header))</visible>
                    <posx>32</posx>
                    <posy>{{ vscale(2) }}</posy>
                    <width>860</width>
                    <height>{{ vscale(64) }}</height>
                    <font>font12</font>
                    <align>left</align>
                    <aligny>center</aligny>
                    <textcolor>B8FFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </focusedlayout>
        </control>
        <control type="scrollbar" id="152">
            <posx>972</posx>
            <posy>{{ vscale(72) }}</posy>
            <width>6</width>
            <height>{{ vscale(735) }}</height>
            <onleft>101</onleft>
            <visible>Integer.IsGreater(Container(101).NumPages,1)</visible>
            <texturesliderbackground colordiffuse="22000000" border="3">script.plex/white-square-rounded.png</texturesliderbackground>
            <texturesliderbar colordiffuse="55FFFFFF" border="3">script.plex/white-square-rounded.png</texturesliderbar>
            <texturesliderbarfocus colordiffuse="FFFFFFFF" border="3">script.plex/white-square-rounded.png</texturesliderbarfocus>
            <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
            <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
            <pulseonselect>false</pulseonselect>
            <orientation>vertical</orientation>
            <showonepage>false</showonepage>
        </control>
    </control>
</control>
{% endblock content %}
