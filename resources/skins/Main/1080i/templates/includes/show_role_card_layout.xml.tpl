<itemlayout width="240">
    <control type="group">
        <posx>60</posx>
        <posy>{{ vscale(12) }}</posy>
        <control type="image">
            <width>200</width>
            <height>{{ vscale(200) }}</height>
            <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <width>200</width>
            <height>{{ vscale(200) }}</height>
            <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio aligny="top">scale</aspectratio>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(210) }}</posy>
            <width>200</width>
            <height>{{ vscale(34) }}</height>
            <font>font12</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(244) }}</posy>
            <width>200</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Label2]</label>
        </control>
    </control>
</itemlayout>
<focusedlayout width="240">
    <control type="group">
        <posx>60</posx>
        <posy>{{ vscale(12) }}</posy>
        <animation effect="zoom" start="100" end="105" time="110" center="100,{{ vscale(100) }}" reversible="true" condition="Control.HasFocus(401)">Conditional</animation>
        <control type="image">
            <visible>Control.HasFocus(401)</visible>
            <posx>-5</posx>
            <posy>{{ vscale(-5) }}</posy>
            <width>210</width>
            <height>{{ vscale(210) }}</height>
            <texture>script.plex/circle-rounded-focus.png</texture>
        </control>
        <control type="image">
            <width>200</width>
            <height>{{ vscale(200) }}</height>
            <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <width>200</width>
            <height>{{ vscale(200) }}</height>
            <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio aligny="top">scale</aspectratio>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(210) }}</posy>
            <width>200</width>
            <height>{{ vscale(34) }}</height>
            <font>font12</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(244) }}</posy>
            <width>200</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Label2]</label>
        </control>
    </control>
</focusedlayout>
