<itemlayout width="330" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),square)">
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
                <width>270</width>
                <height>{{ vscale(270) }}</height>
                <texture diffuse="script.plex/square-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <posx>0</posx>
                <posy>0</posy>
                <width>270</width>
                <height>{{ vscale(270) }}</height>
                <texture background="true" diffuse="script.plex/square-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(280) }}</posy>
                <width>270</width>
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

<focusedlayout width="330" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),square)">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(64) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="106" time="110" center="140,{{ vscale(140) }}" reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional</animation>
            <posx>0</posx>
            <posy>0</posy>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>360</width>
                <height>{{ vscale(360) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>280</width>
                <height>{{ vscale(280) }}</height>
                <texture border="22">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Thumb)</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>270</width>
                    <height>{{ vscale(270) }}</height>
                    <texture diffuse="script.plex/square-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>270</width>
                    <height>{{ vscale(270) }}</height>
                    <texture background="true" diffuse="script.plex/square-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="label">
                    <scroll>false</scroll>
                    <posx>0</posx>
                    <posy>{{ vscale(280) }}</posy>
                    <width>270</width>
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
