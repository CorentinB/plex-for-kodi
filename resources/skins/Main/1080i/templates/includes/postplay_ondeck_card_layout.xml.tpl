<itemlayout width="420">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(48) }}</posy>
        <control type="group">
            <posx>5</posx>
            <posy>5</posy>
            <control type="image">
                <width>385</width>
                <height>{{ vscale(217) }}</height>
                <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>385</width>
                <height>{{ vscale(217) }}</height>
                <texture background="true" diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                <posy>{{ vscale(207) }}</posy>
                <control type="image">
                    <width>385</width>
                    <height>{{ vscale(10) }}</height>
                    <texture>script.plex/white-square.png</texture>
                    <colordiffuse>C0000000</colordiffuse>
                </control>
                <control type="image">
                    <posy>1</posy>
                    <width>385</width>
                    <height>{{ vscale(8) }}</height>
                    <texture>$INFO[ListItem.Property(progress)]</texture>
                    <colordiffuse>FFFFFFFF</colordiffuse>
                </control>
            </control>
            {% include "includes/watched_indicator.xml.tpl" with xoff=385 & uw_size=48 & wbw_w=52 & scale="medium" %}
            <control type="label">
                <scroll>false</scroll>
                <posy>{{ vscale(227) }}</posy>
                <width>385</width>
                <height>{{ vscale(36) }}</height>
                <font>font10</font>
                <align>center</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <scroll>false</scroll>
                <posy>{{ vscale(263) }}</posy>
                <width>385</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <textcolor>99FFFFFF</textcolor>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </control>
    </control>
</itemlayout>

<focusedlayout width="420">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(48) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="105" time="110" center="197.5,{{ vscale(113.5) }}" reversible="true" condition="Control.HasFocus(400)">Conditional</animation>
            <control type="image">
                <visible>Control.HasFocus(400)</visible>
                <posx>-40</posx>
                <posy>{{ vscale(-40) }}</posy>
                <width>475</width>
                <height>{{ vscale(307) }}</height>
                <texture border="42">script.plex/drop-shadow.png</texture>
            </control>
            <control type="image">
                <visible>Control.HasFocus(400)</visible>
                <width>395</width>
                <height>{{ vscale(227) }}</height>
                <texture>script.plex/landscape-hub-rounded-focus.png</texture>
            </control>
            <control type="group">
                <posx>5</posx>
                <posy>5</posy>
                <control type="image">
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <width>385</width>
                    <height>{{ vscale(217) }}</height>
                    <texture background="true" diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                    <posy>{{ vscale(207) }}</posy>
                    <control type="image">
                        <width>385</width>
                        <height>{{ vscale(10) }}</height>
                        <texture>script.plex/white-square.png</texture>
                        <colordiffuse>C0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posy>1</posy>
                        <width>385</width>
                        <height>{{ vscale(8) }}</height>
                        <texture>$INFO[ListItem.Property(progress)]</texture>
                        <colordiffuse>FFFFFFFF</colordiffuse>
                    </control>
                </control>
                {% include "includes/watched_indicator.xml.tpl" with xoff=385 & uw_size=48 & wbw_w=52 & scale="medium" %}
                <control type="label">
                    <scroll>false</scroll>
                    <posy>{{ vscale(227) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(36) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
                <control type="label">
                    <scroll>false</scroll>
                    <posy>{{ vscale(263) }}</posy>
                    <width>385</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <textcolor>99FFFFFF</textcolor>
                    <label>$INFO[ListItem.Label2]</label>
                </control>
            </control>
        </control>
    </control>
</focusedlayout>
