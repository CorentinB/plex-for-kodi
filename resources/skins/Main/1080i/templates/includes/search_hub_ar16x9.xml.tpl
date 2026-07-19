<itemlayout width="360" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),ar16x9)">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(64) }}</posy>
        <control type="group">
            <posx>5</posx>
            <posy>5</posy>
            <control type="image">
                <visible>String.IsEmpty(ListItem.Thumb)</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>300</width>
                <height>{{ vscale(169) }}</height>
                <texture diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <posx>0</posx>
                <posy>0</posy>
                <width>300</width>
                <height>{{ vscale(169) }}</height>
                <texture background="true" diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(179) }}</posy>
                <width>300</width>
                <height>{{ vscale(35) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
        </control>
    </control>
</itemlayout>

<focusedlayout width="360" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),ar16x9)">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(64) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="106" time="110" center="155,{{ vscale(89.5) }}" reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional</animation>
            <posx>0</posx>
            <posy>0</posy>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>390</width>
                <height>{{ vscale(259) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>310</width>
                <height>{{ vscale(179) }}</height>
                <texture border="22">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Thumb)</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>300</width>
                    <height>{{ vscale(169) }}</height>
                    <texture diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>300</width>
                    <height>{{ vscale(169) }}</height>
                    <texture background="true" diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="label">
                    <scroll>false</scroll>
                    <posx>0</posx>
                    <posy>{{ vscale(179) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(35) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>
        </control>
    </control>
</focusedlayout>
