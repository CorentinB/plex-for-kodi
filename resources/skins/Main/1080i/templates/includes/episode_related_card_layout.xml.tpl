<itemlayout width="287">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(72) }}</posy>
        <control type="group">
            <posx>5</posx>
            <posy>5</posy>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(361) }}</height>
                <texture diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
            </control>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(361) }}</height>
                <texture background="true" diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                <posy>{{ vscale(351) }}</posy>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(10) }}</height>
                    <texture>script.plex/white-square.png</texture>
                    <colordiffuse>C0000000</colordiffuse>
                </control>
                <control type="image">
                    <posy>1</posy>
                    <width>244</width>
                    <height>{{ vscale(8) }}</height>
                    <texture>$INFO[ListItem.Property(progress)]</texture>
                    <colordiffuse>FFCC7B19</colordiffuse>
                </control>
            </control>
            {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
            <control type="label">
                <scroll>false</scroll>
                <posy>{{ vscale(369) }}</posy>
                <width>244</width>
                <height>{{ vscale(38) }}</height>
                <font>font10</font>
                <align>center</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
        </control>
    </control>
</itemlayout>

<focusedlayout width="287">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(72) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180.5) }}" reversible="true" condition="Control.HasFocus(404)">Conditional</animation>
            <control type="image">
                <visible>Control.HasFocus(404)</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>324</width>
                <height>{{ vscale(441) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus(404)</visible>
                <width>254</width>
                <height>{{ vscale(371) }}</height>
                <texture>script.plex/poster-home-rounded-focus.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(361) }}</height>
                    <texture diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                </control>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(361) }}</height>
                    <texture background="true" diffuse="script.plex/poster-home-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                    <posy>{{ vscale(351) }}</posy>
                    <control type="image">
                        <width>244</width>
                        <height>{{ vscale(10) }}</height>
                        <texture>script.plex/white-square.png</texture>
                        <colordiffuse>C0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posy>1</posy>
                        <width>244</width>
                        <height>{{ vscale(8) }}</height>
                        <texture>$INFO[ListItem.Property(progress)]</texture>
                        <colordiffuse>FFCC7B19</colordiffuse>
                    </control>
                </control>
                {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
                <control type="label">
                    <scroll>false</scroll>
                    <posy>{{ vscale(369) }}</posy>
                    <width>244</width>
                    <height>{{ vscale(38) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>
        </control>
    </control>
</focusedlayout>
