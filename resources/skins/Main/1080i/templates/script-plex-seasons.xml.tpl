{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>302</defaultcontrol>{% endblock %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(seasons.background.blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <fadetime>450</fadetime>
    <texture background="true">$INFO[Window.Property(seasons.background.blurred)]</texture>
    {% include "includes/scale_background.xml.tpl" %}
</control>
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture>script.plex/home/tvos-background-wash.png</texture>
</control>
<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="33000000">script.plex/white-square.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <animation effect="slide" end="0,{{ vscale(-490) }}" time="220" tween="quadratic" easing="out" condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>
    <animation effect="slide" end="0,{{ vscale(-840) }}" time="220" tween="quadratic" easing="out" condition="String.IsEqual(Window.Property(hub.focus),2)">Conditional</animation>
    <animation effect="slide" end="0,{{ vscale(-1180) }}" time="220" tween="quadratic" easing="out" condition="String.IsEqual(Window.Property(hub.focus),3)">Conditional</animation>
    <posx>0</posx>
    <posy>{{ vscale(135) }}</posy>
    <width>1920</width>
    <height>{{ vscale(2200) }}</height>
    <defaultcontrol>302</defaultcontrol>

    <control type="group">
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
        <posx>160</posx>
        <posy>0</posy>
        <width>1600</width>
        <height>{{ vscale(440) }}</height>
        <control type="label">
            <posx>0</posx>
            <posy>0</posy>
            <width>1320</width>
            <height>{{ vscale(72) }}</height>
            <font>font60</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(title)]</label>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(76) }}</posy>
            <width>1320</width>
            <height>{{ vscale(38) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>E8FFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(duration)]$INFO[Window.Property(info),  •  ]$INFO[Window.Property(date),  •  ]$INFO[Window.Property(content.rating),  •  ]</label>
        </control>

        <control type="grouplist">
            <visible>!String.IsEmpty(Window.Property(rating)) | !String.IsEmpty(Window.Property(rating2))</visible>
            <posx>1325</posx>
            <posy>{{ vscale(78) }}</posy>
            <width>275</width>
            <height>{{ vscale(34) }}</height>
            <align>right</align>
            <itemgap>10</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="image">
                <visible>!String.IsEmpty(Window.Property(rating))</visible>
                <width>42</width>
                <height>{{ vscale(28) }}</height>
                <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(rating.image)]</texture>
                <aspectratio align="right">keep</aspectratio>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Window.Property(rating))</visible>
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(rating)]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Window.Property(rating2))</visible>
                <width>34</width>
                <height>{{ vscale(28) }}</height>
                <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(rating2.image)]</texture>
                <aspectratio align="right">keep</aspectratio>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Window.Property(rating2))</visible>
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(rating2)]</label>
            </control>
        </control>

        <control type="grouplist">
            <visible>!String.IsEmpty(Window.Property(creator.name))</visible>
            <posx>0</posx>
            <posy>{{ vscale(125) }}</posy>
            <width>1540</width>
            <height>{{ vscale(34) }}</height>
            <align>left</align>
            <itemgap>20</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>88FFFFFF</textcolor>
                <label>$INFO[Window.Property(creator.label)]</label>
            </control>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>D8FFFFFF</textcolor>
                <label>$INFO[Window.Property(creator.name)]</label>
            </control>
        </control>
        <control type="grouplist">
            <visible>!String.IsEmpty(Window.Property(cast.names))</visible>
            <posx>0</posx>
            <posy>{{ vscale(162) }}</posy>
            <width>1540</width>
            <height>{{ vscale(34) }}</height>
            <align>left</align>
            <itemgap>20</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>88FFFFFF</textcolor>
                <label>$ADDON[script.plexmod 32419]</label>
            </control>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>D8FFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Window.Property(cast.names)]</label>
            </control>
        </control>

        <control type="grouplist">
            <visible>!String.IsEmpty(Window.Property(wl_server_availability_verbose))</visible>
            <posx>0</posx>
            <posy>{{ vscale(198) }}</posy>
            <width>1540</width>
            <height>{{ vscale(32) }}</height>
            <align>left</align>
            <itemgap>18</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(32) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>88FFFFFF</textcolor>
                <label>$ADDON[script.plexmod 34005]</label>
            </control>
            <control type="label">
                <width>1360</width>
                <height>{{ vscale(32) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>D8FFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Window.Property(wl_server_availability_verbose)]</label>
            </control>
        </control>

        <control type="textbox">
            <posx>0</posx>
            <posy>{{ vscale(222) }}</posy>
            <width>1560</width>
            <height>{{ vscale(92) }}</height>
            <font>font13</font>
            <align>left</align>
            <textcolor>F2FFFFFF</textcolor>
            <autoscroll>false</autoscroll>
            <label>$INFO[Window.Property(summary.short)]</label>
        </control>

        <control type="grouplist" id="300">
            <visible>!String.IsEmpty(Window.Property(initialized))</visible>
            <defaultcontrol always="true">302</defaultcontrol>
            <posx>0</posx>
            <posy>{{ vscale(330) }}</posy>
            <width>1600</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>400</ondown>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <align>left</align>
            <scrolltime>160</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            {% with attr = theme.seasons.buttons & template = "includes/themed_button.xml.tpl" & seasons_style = True %}
                {% include template with name="play" & id=302 & visible="String.IsEmpty(Window.Property(disable_playback))" & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106 %}
                {% include "includes/wl_dynamic_buttons.xml.tpl" %}
                {% include template with name="info" & id=301 & action_label="$LOCALIZE[29915]" & action_width=154 & action_label_width=82 %}
                {% include "includes/wl_add_remove_buttons.xml.tpl" %}
                {% include template with name="shuffle" & id=303 & visible="String.IsEmpty(Window.Property(disable_playback))" & action_label="$ADDON[script.plexmod 32935]" & action_width=300 & action_label_width=228 %}
                {% include template with name="more" & id=304 & visible="String.IsEmpty(Window.Property(disable_playback))" & action_label="$ADDON[script.plexmod 32307]" & action_width=140 & action_label_width=68 %}
            {% endwith %}
        </control>
    </control>

    <control type="image" id="250">
        <posx>0</posx>
        <posy>{{ vscale(432) }}</posy>
        <width>1</width>
        <height>{{ vscale(4) }}</height>
        <texture colordiffuse="CCFFFFFF">script.plex/white-square.png</texture>
    </control>

    <!-- SEASONS -->
    <control type="group" id="500">
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
        <visible>Integer.IsGreater(Container(400).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>400</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(460) }}</posy>
        <width>1920</width>
        <height>{{ vscale(470) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(48) }}</height>
            <font>font30_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35035]</label>
        </control>
        <control type="list" id="400">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1722</width>
            <height>{{ vscale(440) }}</height>
            <onup>300</onup>
            <ondown condition="Control.IsVisible(401)">401</ondown>
            <ondown condition="!Control.IsVisible(401) + Control.IsVisible(402)">402</ondown>
            <ondown condition="!Control.IsVisible(401) + !Control.IsVisible(402) + Control.IsVisible(403)">403</ondown>
            <ondown condition="!Control.IsVisible(401) + !Control.IsVisible(402) + !Control.IsVisible(403)">400</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>3</preloaditems>
            {% include "includes/show_poster_card_layout.xml.tpl" with list_id=400 %}
        </control>
    </control>
    <!-- /SEASONS -->

    <!-- ROLES -->
    <control type="group" id="501">
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),1)">Conditional</animation>
        <visible>Integer.IsGreater(Container(401).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>401</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(950) }}</posy>
        <width>1920</width>
        <height>{{ vscale(320) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(48) }}</height>
            <font>font30_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35019]</label>
        </control>
        <control type="list" id="401">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1820</width>
            <height>{{ vscale(280) }}</height>
            <onup>400</onup>
            <ondown condition="Control.IsVisible(402)">402</ondown>
            <ondown condition="!Control.IsVisible(402) + Control.IsVisible(403)">403</ondown>
            <ondown condition="!Control.IsVisible(402) + !Control.IsVisible(403)">401</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>4</preloaditems>
            {% include "includes/show_role_card_layout.xml.tpl" %}
        </control>
    </control>
    <!-- /ROLES -->

    <!-- EXTRAS -->
    <control type="group" id="502">
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),2)">Conditional</animation>
        <visible>Integer.IsGreater(Container(402).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>402</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(1300) }}</posy>
        <width>1920</width>
        <height>{{ vscale(300) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(48) }}</height>
            <font>font30_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(extras.header)]</label>
        </control>
        <control type="list" id="402">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1700</width>
            <height>{{ vscale(253) }}</height>
            <onup condition="Control.IsVisible(401)">401</onup>
            <onup condition="!Control.IsVisible(401)">400</onup>
            <ondown condition="Control.IsVisible(403)">403</ondown>
            <ondown condition="!Control.IsVisible(403)">402</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>3</preloaditems>
            {% include "includes/show_landscape_card_layout.xml.tpl" %}
        </control>
    </control>
    <!-- /EXTRAS -->

    <!-- RELATED -->
    <control type="group" id="503">
        <visible>Integer.IsGreater(Container(403).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>403</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(1640) }}</posy>
        <width>1920</width>
        <height>{{ vscale(470) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>900</width>
            <height>{{ vscale(48) }}</height>
            <font>font30_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(related.header)]</label>
        </control>
        <control type="list" id="403">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1722</width>
            <height>{{ vscale(440) }}</height>
            <onup condition="Control.IsVisible(402)">402</onup>
            <onup condition="!Control.IsVisible(402) + Control.IsVisible(401)">401</onup>
            <onup condition="!Control.IsVisible(402) + !Control.IsVisible(401)">400</onup>
            <ondown>403</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>3</preloaditems>
            {% include "includes/show_poster_card_layout.xml.tpl" with list_id=403 %}
        </control>
    </control>
    <!-- /RELATED -->
</control>
{% endblock content %}
