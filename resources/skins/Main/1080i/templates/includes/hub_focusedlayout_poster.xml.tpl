<!-- Poster focused layout (244x361) - uses hub_id variable -->
<focusedlayout width="287" condition="String.IsEqual(Window.Property(hub.display.{{ hub_id }}),poster)">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(22) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="106" time="110" center="127,{{ vscale(185.5) }}" reversible="true" condition="Control.HasFocus({{ hub_id }})">Conditional</animation>
            <posx>0</posx>
            <posy>0</posy>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>334</width>
                <height>{{ vscale(451) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus({{ hub_id }})</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>254</width>
                <height>{{ vscale(371) }}</height>
                <texture>script.plex/poster-home-rounded-focus.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(is.end))</visible>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>244</width>
                        <height>{{ vscale(361) }}</height>
                        <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="FF404040">script.plex/white-square.png</texture>
                    </control>
                    <control type="image">
                        <visible>String.IsEmpty(ListItem.Property(is.updating))</visible>
                        <posx>91.5</posx>
                        <posy>{{ vscale(130.5) }}</posy>
                        <width>61</width>
                        <height>{{ vscale(100) }}</height>
                        <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                    </control>
                    <control type="image">
                        <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                        <posx>58</posx>
                        <posy>{{ vscale(116.5) }}</posy>
                        <width>128</width>
                        <height>{{ vscale(128) }}</height>
                        <texture>script.plex/home/busy.gif</texture>
                    </control>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>244</width>
                    <height>{{ vscale(361) }}</height>
                    <texture diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>244</width>
                    <height>{{ vscale(361) }}</height>
                    <texture background="true" diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(351) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>244</width>
                        <height>{{ vscale(10) }}</height>
                        <texture>script.plex/white-square.png</texture>
                        <colordiffuse>C0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>1</posy>
                        <width>244</width>
                        <height>{{ vscale(8) }}</height>
                        <texture>$INFO[ListItem.Property(progress)]</texture>
                        <colordiffuse>FFCC7B19</colordiffuse>
                    </control>
                </control>
                <control type="textbox">
                    <autoscroll>false</autoscroll>
                    <posx>0</posx>
                    <posy>{{ vscale(371) }}</posy>
                    <width>244</width>
                    <height>{{ vscale(60) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
                <control type="label">
                    <scroll>false</scroll>
                    <visible>!String.IsEmpty(Window.Property(hub.text2lines.{{ hub_id }}))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(431) }}</posy>
                    <width>244</width>
                    <height>{{ vscale(35) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label2]</label>
                </control>
                {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
            </control>
        </control>
    </control>
</focusedlayout>
