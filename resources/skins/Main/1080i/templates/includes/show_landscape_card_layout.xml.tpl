<itemlayout width="340">
    <control type="group">
        <posx>60</posx>
        <posy>{{ vscale(12) }}</posy>
        <control type="image">
            <width>300</width>
            <height>{{ vscale(169) }}</height>
            <texture diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <width>300</width>
            <height>{{ vscale(169) }}</height>
            <texture background="true" diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(179) }}</posy>
            <width>300</width>
            <height>{{ vscale(36) }}</height>
            <font>font12</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(215) }}</posy>
            <width>300</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Label2]</label>
        </control>
    </control>
</itemlayout>
<focusedlayout width="340">
    <control type="group">
        <posx>60</posx>
        <posy>{{ vscale(12) }}</posy>
        <animation effect="zoom" start="100" end="106" time="110" center="150,{{ vscale(84.5) }}" reversible="true" condition="Control.HasFocus(402)">Conditional</animation>
        <control type="image">
            <visible>Control.HasFocus(402)</visible>
            <posx>-5</posx>
            <posy>{{ vscale(-5) }}</posy>
            <width>310</width>
            <height>{{ vscale(179) }}</height>
            <texture>script.plex/landscape-search-rounded-focus.png</texture>
        </control>
        <control type="image">
            <width>300</width>
            <height>{{ vscale(169) }}</height>
            <texture diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <width>300</width>
            <height>{{ vscale(169) }}</height>
            <texture background="true" diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(179) }}</posy>
            <width>300</width>
            <height>{{ vscale(36) }}</height>
            <font>font12</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <scroll>false</scroll>
            <posy>{{ vscale(215) }}</posy>
            <width>300</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[ListItem.Label2]</label>
        </control>
    </control>
</focusedlayout>
