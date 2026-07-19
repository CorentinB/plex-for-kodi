<control type="group">
    {% if focused %}
    <control type="image">
        <posx>8</posx>
        <posy>{{ vscale(5) }}</posy>
        <width>920</width>
        <height>{{ vscale(90) }}</height>
        <texture border="14">script.plex/white-square-rounded.png</texture>
        <colordiffuse>F5FFFFFF</colordiffuse>
    </control>
    {% endif %}
    <control type="label">
        <visible>String.IsEmpty(ListItem.Property(track.ID)) | !String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
        <posx>18</posx>
        <posy>0</posy>
        <width>58</width>
        <height>{{ vscale(100) }}</height>
        <font>font10</font>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>{% if focused %}B8111111{% else %}B8FFFFFF{% endif %}</textcolor>
        <label>$INFO[ListItem.Property(track.number)]</label>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(track.ID)) + String.IsEqual(ListItem.Property(track.ID),Window(10000).Property(script.plex.track.ID))</visible>
        <posx>30</posx>
        <posy>{{ vscale(32) }}</posy>
        <width>34</width>
        <height>{{ vscale(34) }}</height>
        <texture>script.plex/indicators/playing-circle.png</texture>
        <colordiffuse>{% if focused %}FF111111{% else %}FFFFFFFF{% endif %}</colordiffuse>
    </control>

    <control type="group">
        <visible>String.IsEmpty(ListItem.Property(video))</visible>
        <control type="image">
            <posx>88</posx>
            <posy>{{ vscale(13) }}</posy>
            <width>74</width>
            <height>{{ vscale(74) }}</height>
            <texture diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>88</posx>
            <posy>{{ vscale(13) }}</posy>
            <width>74</width>
            <height>{{ vscale(74) }}</height>
            <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="group">
            <posx>188</posx>
            <posy>0</posy>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(14) }}</posy>
                <width>560</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>{% if focused %}FF111111{% else %}FFFFFFFF{% endif %}</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(49) }}</posy>
                <width>560</width>
                <height>{{ vscale(30) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>{% if focused %}99111111{% else %}99FFFFFF{% endif %}</textcolor>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </control>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(ListItem.Property(video))</visible>
        <control type="image">
            <posx>88</posx>
            <posy>{{ vscale(13) }}</posy>
            <width>132</width>
            <height>{{ vscale(74) }}</height>
            <texture diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>88</posx>
            <posy>{{ vscale(13) }}</posy>
            <width>132</width>
            <height>{{ vscale(74) }}</height>
            <texture background="true" diffuse="script.plex/landscape-search-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        {% include "includes/watched_indicator.xml.tpl" with xoff=220 & yoff=13 & uw_posy=13 & uw_size=24 & with_count=True & scale="tiny" %}
        <control type="group">
            <posx>246</posx>
            <posy>0</posy>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(14) }}</posy>
                <width>502</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>{% if focused %}FF111111{% else %}FFFFFFFF{% endif %}</textcolor>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <scroll>false</scroll>
                <posx>0</posx>
                <posy>{{ vscale(49) }}</posy>
                <width>502</width>
                <height>{{ vscale(30) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>{% if focused %}99111111{% else %}99FFFFFF{% endif %}</textcolor>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </control>
    </control>

    <control type="label">
        <posx>760</posx>
        <posy>0</posy>
        <width>142</width>
        <height>{{ vscale(100) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>{% if focused %}B8111111{% else %}B8FFFFFF{% endif %}</textcolor>
        <label>$INFO[ListItem.Property(track.duration)]</label>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
        <posx>88</posx>
        <posy>{{ vscale(84) }}</posy>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>132</width>
            <height>{{ vscale(4) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>{% if focused %}40111111{% else %}40000000{% endif %}</colordiffuse>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>132</width>
            <height>{{ vscale(4) }}</height>
            <texture>$INFO[ListItem.Property(progress)]</texture>
            <colordiffuse>{% if focused %}FF111111{% else %}FFFFFFFF{% endif %}</colordiffuse>
        </control>
    </control>
    {% if not focused %}
    <control type="image">
        <visible>String.IsEmpty(ListItem.Property(is.footer))</visible>
        <posx>18</posx>
        <posy>{{ vscale(99) }}</posy>
        <width>884</width>
        <height>1</height>
        <texture>script.plex/white-square.png</texture>
        <colordiffuse>24111111</colordiffuse>
    </control>
    {% endif %}
</control>
