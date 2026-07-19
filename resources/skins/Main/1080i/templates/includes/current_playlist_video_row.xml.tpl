<itemlayout height="{{ vscale(108) }}">
    <control type="group">
        <posx>10</posx>
        <posy>{{ vscale(4) }}</posy>
        <control type="label">
            <visible>String.IsEmpty(ListItem.Property(playing))</visible>
            <posx>8</posx>
            <width>38</width>
            <height>{{ vscale(100) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Property(track.number)]</label>
        </control>
        <control type="image">
            <visible>!String.IsEmpty(ListItem.Property(playing))</visible>
            <posx>13</posx>
            <posy>{{ vscale(36) }}</posy>
            <width>28</width>
            <height>{{ vscale(28) }}</height>
            <texture colordiffuse="FFFFFFFF">script.plex/indicators/playing-circle.png</texture>
        </control>
        <control type="image">
            <posx>58</posx>
            <posy>{{ vscale(7) }}</posy>
            <width>154</width>
            <height>{{ vscale(86) }}</height>
            <texture fallback="script.plex/thumb_fallbacks/show.png" diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="group">
            <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
            <posx>58</posx>
            <posy>{{ vscale(87) }}</posy>
            <control type="image">
                <width>154</width>
                <height>{{ vscale(6) }}</height>
                <texture colordiffuse="C0000000">script.plex/white-square.png</texture>
            </control>
            <control type="image">
                <posy>1</posy>
                <width>154</width>
                <height>{{ vscale(4) }}</height>
                <texture colordiffuse="FFFFFFFF">$INFO[ListItem.Property(progress)]</texture>
            </control>
        </control>
        {% include "includes/watched_indicator.xml.tpl" with xoff=212 & yoff=7 & uw_posy=7 & uw_size=28 & scale="tiny" %}
        <control type="label">
            <posx>232</posx>
            <posy>{{ vscale(15) }}</posy>
            <width>520</width>
            <height>{{ vscale(34) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <posx>232</posx>
            <posy>{{ vscale(52) }}</posy>
            <width>520</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label2]</label>
        </control>
        <control type="label">
            <posx>790</posx>
            <width>105</width>
            <height>{{ vscale(100) }}</height>
            <font>font10</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>B8FFFFFF</textcolor>
            <label>$INFO[ListItem.Property(track.duration)]</label>
        </control>
    </control>
</itemlayout>

<focusedlayout height="{{ vscale(108) }}">
    <control type="group">
        <posx>10</posx>
        <posy>{{ vscale(4) }}</posy>
        <control type="image">
            <width>910</width>
            <height>{{ vscale(100) }}</height>
            <texture border="24">script.plex/white-square-rounded.png</texture>
            <colordiffuse>FFF7F7F7</colordiffuse>
        </control>
        <control type="label">
            <visible>String.IsEmpty(ListItem.Property(playing))</visible>
            <posx>8</posx>
            <width>38</width>
            <height>{{ vscale(100) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99000000</textcolor>
            <label>$INFO[ListItem.Property(track.number)]</label>
        </control>
        <control type="image">
            <visible>!String.IsEmpty(ListItem.Property(playing))</visible>
            <posx>13</posx>
            <posy>{{ vscale(36) }}</posy>
            <width>28</width>
            <height>{{ vscale(28) }}</height>
            <texture colordiffuse="FF111111">script.plex/indicators/playing-circle.png</texture>
        </control>
        <control type="image">
            <posx>58</posx>
            <posy>{{ vscale(7) }}</posy>
            <width>154</width>
            <height>{{ vscale(86) }}</height>
            <texture fallback="script.plex/thumb_fallbacks/show.png" diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="group">
            <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
            <posx>58</posx>
            <posy>{{ vscale(87) }}</posy>
            <control type="image">
                <width>154</width>
                <height>{{ vscale(6) }}</height>
                <texture colordiffuse="66000000">script.plex/white-square.png</texture>
            </control>
            <control type="image">
                <posy>1</posy>
                <width>154</width>
                <height>{{ vscale(4) }}</height>
                <texture colordiffuse="FF111111">$INFO[ListItem.Property(progress)]</texture>
            </control>
        </control>
        {% include "includes/watched_indicator.xml.tpl" with xoff=212 & yoff=7 & uw_posy=7 & uw_size=28 & scale="tiny" %}
        <control type="label">
            <posx>232</posx>
            <posy>{{ vscale(15) }}</posy>
            <width>520</width>
            <height>{{ vscale(34) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>EE000000</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <posx>232</posx>
            <posy>{{ vscale(52) }}</posy>
            <width>520</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>99000000</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label2]</label>
        </control>
        <control type="label">
            <posx>790</posx>
            <width>105</width>
            <height>{{ vscale(100) }}</height>
            <font>font10</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>AA000000</textcolor>
            <label>$INFO[ListItem.Property(track.duration)]</label>
        </control>
    </control>
</focusedlayout>
