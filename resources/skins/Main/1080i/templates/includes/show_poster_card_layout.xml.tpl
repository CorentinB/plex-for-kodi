<itemlayout width="287">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(12) }}</posy>
        <control type="group">
            <posx>5</posx>
            <posy>5</posy>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(364) }}</height>
                <texture diffuse="script.plex/poster-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(364) }}</height>
                <texture background="true" diffuse="script.plex/poster-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                <posy>{{ vscale(354) }}</posy>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(10) }}</height>
                    <texture colordiffuse="B8000000">script.plex/white-square.png</texture>
                </control>
                <control type="image">
                    <posy>1</posy>
                    <width>244</width>
                    <height>{{ vscale(8) }}</height>
                    <texture colordiffuse="FFFFFFFF">$INFO[ListItem.Property(progress)]</texture>
                </control>
            </control>
            {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(is.boundary)) | !String.IsEmpty(ListItem.Property(is.end))</visible>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(364) }}</height>
                    <texture diffuse="script.plex/poster-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
                </control>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + [!String.IsEmpty(ListItem.Property(right.boundary)) | !String.IsEmpty(ListItem.Property(is.end))]</visible>
                    <posx>91</posx>
                    <posy>{{ vscale(130) }}</posy>
                    <width>61</width>
                    <height>{{ vscale(100) }}</height>
                    <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white.png</texture>
                </control>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                    <posx>91</posx>
                    <posy>{{ vscale(130) }}</posy>
                    <width>61</width>
                    <height>{{ vscale(100) }}</height>
                    <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white-l.png</texture>
                </control>
                <control type="image">
                    <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                    <posx>82</posx>
                    <posy>{{ vscale(141) }}</posy>
                    <width>80</width>
                    <height>{{ vscale(80) }}</height>
                    <texture>script.plex/home/busy.gif</texture>
                </control>
            </control>
            <control type="label">
                <visible>String.IsEmpty(ListItem.Property(is.boundary)) + String.IsEmpty(ListItem.Property(is.end))</visible>
                <scroll>false</scroll>
                <posy>{{ vscale(374) }}</posy>
                <width>244</width>
                <height>{{ vscale(38) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>String.IsEmpty(ListItem.Property(is.boundary)) + String.IsEmpty(ListItem.Property(is.end))</visible>
                <scroll>false</scroll>
                <posy>{{ vscale(410) }}</posy>
                <width>244</width>
                <height>{{ vscale(30) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>99FFFFFF</textcolor>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </control>
    </control>
</itemlayout>
<focusedlayout width="287">
    <control type="group">
        <posx>55</posx>
        <posy>{{ vscale(12) }}</posy>
        <control type="group">
            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180) }}" reversible="true" condition="Control.HasFocus({{ list_id }})">Conditional</animation>
            <posx>5</posx>
            <posy>5</posy>
            <control type="image">
                <visible>Control.HasFocus({{ list_id }})</visible>
                <posx>-5</posx>
                <posy>{{ vscale(-5) }}</posy>
                <width>254</width>
                <height>{{ vscale(374) }}</height>
                <texture>script.plex/poster-medium-rounded-focus.png</texture>
            </control>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(364) }}</height>
                <texture diffuse="script.plex/poster-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <width>244</width>
                <height>{{ vscale(364) }}</height>
                <texture background="true" diffuse="script.plex/poster-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                <posy>{{ vscale(354) }}</posy>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(10) }}</height>
                    <texture colordiffuse="B8000000">script.plex/white-square.png</texture>
                </control>
                <control type="image">
                    <posy>1</posy>
                    <width>244</width>
                    <height>{{ vscale(8) }}</height>
                    <texture colordiffuse="FFFFFFFF">$INFO[ListItem.Property(progress)]</texture>
                </control>
            </control>
            {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(is.boundary)) | !String.IsEmpty(ListItem.Property(is.end))</visible>
                <control type="image">
                    <width>244</width>
                    <height>{{ vscale(364) }}</height>
                    <texture diffuse="script.plex/poster-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
                </control>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + [!String.IsEmpty(ListItem.Property(right.boundary)) | !String.IsEmpty(ListItem.Property(is.end))]</visible>
                    <posx>91</posx>
                    <posy>{{ vscale(130) }}</posy>
                    <width>61</width>
                    <height>{{ vscale(100) }}</height>
                    <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white.png</texture>
                </control>
                <control type="image">
                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                    <posx>91</posx>
                    <posy>{{ vscale(130) }}</posy>
                    <width>61</width>
                    <height>{{ vscale(100) }}</height>
                    <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white-l.png</texture>
                </control>
                <control type="image">
                    <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                    <posx>82</posx>
                    <posy>{{ vscale(141) }}</posy>
                    <width>80</width>
                    <height>{{ vscale(80) }}</height>
                    <texture>script.plex/home/busy.gif</texture>
                </control>
            </control>
            <control type="label">
                <visible>String.IsEmpty(ListItem.Property(is.boundary)) + String.IsEmpty(ListItem.Property(is.end))</visible>
                <scroll>false</scroll>
                <posy>{{ vscale(374) }}</posy>
                <width>244</width>
                <height>{{ vscale(38) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>String.IsEmpty(ListItem.Property(is.boundary)) + String.IsEmpty(ListItem.Property(is.end))</visible>
                <scroll>false</scroll>
                <posy>{{ vscale(410) }}</posy>
                <width>244</width>
                <height>{{ vscale(30) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>99FFFFFF</textcolor>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </control>
    </control>
</focusedlayout>
