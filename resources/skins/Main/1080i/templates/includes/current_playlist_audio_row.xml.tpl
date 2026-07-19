<itemlayout height="{{ vscale(90) }}">
    <control type="group">
        <posx>20</posx>
        <posy>{{ vscale(4) }}</posy>
        <control type="label">
            <visible>!String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
            <posx>8</posx>
            <width>46</width>
            <height>{{ vscale(82) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Property(track.number)]</label>
        </control>
        <control type="image">
            <visible>String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
            <posx>17</posx>
            <posy>{{ vscale(27) }}</posy>
            <width>28</width>
            <height>{{ vscale(28) }}</height>
            <texture colordiffuse="FFFFFFFF">script.plex/indicators/playing-circle.png</texture>
        </control>
        <control type="image">
            <posx>68</posx>
            <posy>{{ vscale(9) }}</posy>
            <width>64</width>
            <height>{{ vscale(64) }}</height>
            <texture fallback="script.plex/thumb_fallbacks/music.png" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="label">
            <posx>154</posx>
            <posy>{{ vscale(9) }}</posy>
            <width>650</width>
            <height>{{ vscale(32) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <posx>154</posx>
            <posy>{{ vscale(42) }}</posy>
            <width>650</width>
            <height>{{ vscale(28) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label2]</label>
        </control>
        <control type="label">
            <posx>830</posx>
            <width>100</width>
            <height>{{ vscale(82) }}</height>
            <font>font10</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>B8FFFFFF</textcolor>
            <label>$INFO[ListItem.Property(track.duration)]</label>
        </control>
        <control type="image">
            <posx>68</posx>
            <posy>{{ vscale(81) }}</posy>
            <width>862</width>
            <height>1</height>
            <texture colordiffuse="18FFFFFF">script.plex/white-square.png</texture>
        </control>
    </control>
</itemlayout>

<focusedlayout height="{{ vscale(90) }}">
    <control type="group">
        <posx>20</posx>
        <posy>{{ vscale(4) }}</posy>
        <control type="image">
            <width>950</width>
            <height>{{ vscale(82) }}</height>
            <texture border="22">script.plex/white-square-rounded.png</texture>
            <colordiffuse>FFF7F7F7</colordiffuse>
        </control>
        <control type="label">
            <visible>!String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
            <posx>8</posx>
            <width>46</width>
            <height>{{ vscale(82) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99000000</textcolor>
            <label>$INFO[ListItem.Property(track.number)]</label>
        </control>
        <control type="image">
            <visible>String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
            <posx>17</posx>
            <posy>{{ vscale(27) }}</posy>
            <width>28</width>
            <height>{{ vscale(28) }}</height>
            <texture colordiffuse="FF111111">script.plex/indicators/playing-circle.png</texture>
        </control>
        <control type="image">
            <posx>68</posx>
            <posy>{{ vscale(9) }}</posy>
            <width>64</width>
            <height>{{ vscale(64) }}</height>
            <texture fallback="script.plex/thumb_fallbacks/music.png" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="label">
            <posx>154</posx>
            <posy>{{ vscale(9) }}</posy>
            <width>650</width>
            <height>{{ vscale(32) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>EE000000</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <posx>154</posx>
            <posy>{{ vscale(42) }}</posy>
            <width>650</width>
            <height>{{ vscale(28) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>99000000</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label2]</label>
        </control>
        <control type="label">
            <posx>830</posx>
            <width>100</width>
            <height>{{ vscale(82) }}</height>
            <font>font10</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>AA000000</textcolor>
            <label>$INFO[ListItem.Property(track.duration)]</label>
        </control>
    </control>
</focusedlayout>
