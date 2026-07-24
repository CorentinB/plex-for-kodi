<!-- 16x9 focused layout (385x217) - uses hub_id variable -->
<focusedlayout width="420" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),ar16x9)">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(20) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="106" time="110" center="197.5,{{ vscale(113.5) }}" reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional</animation>
            <posx>0</posx>
            <posy>0</posy>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>475</width>
                <height>{{ vscale(307) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>395</width>
                <height>{{ vscale(227) }}</height>
                <texture>script.plex/landscape-hub-rounded-focus.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(is.end))</visible>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>385</width>
                        <height>{{ vscale(217) }}</height>
                        <texture diffuse="script.plex/landscape-hub-rounded-mask.png" colordiffuse="FF404040">script.plex/white-square.png</texture>
                    </control>
                    <control type="image">
                        <visible>String.IsEmpty(ListItem.Property(is.updating))</visible>
                        <posx>162</posx>
                        <posy>{{ vscale(58.5) }}</posy>
                        <width>61</width>
                        <height>{{ vscale(100) }}</height>
                        <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                    </control>
                    <control type="image">
                        <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                        <posx>128.5</posx>
                        <posy>{{ vscale(44.5) }}</posy>
                        <width>128</width>
                        <height>{{ vscale(128) }}</height>
                        <texture>script.plex/home/busy.gif</texture>
                    </control>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture background="true" diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(207) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>385</width>
                        <height>{{ vscale(10) }}</height>
                        <texture>script.plex/white-square.png</texture>
                        <colordiffuse>C0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>1</posy>
                        <width>385</width>
                        <height>{{ vscale(8) }}</height>
                        <texture>$INFO[ListItem.Property(progress)]</texture>
                        <colordiffuse>FFCC7B19</colordiffuse>
                    </control>
                </control>
                {% include "includes/watched_indicator.xml.tpl" with xoff=385 & uw_size=48 & with_count=True & scale="medium" %}
            </control>
        </control>
    </control>
</focusedlayout>
