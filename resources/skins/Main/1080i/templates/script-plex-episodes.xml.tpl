{% extends "default.xml.tpl" %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(episodes.background.blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <fadetime>450</fadetime>
    <texture background="true">$INFO[Window.Property(episodes.background.blurred)]</texture>
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
    <texture colordiffuse="24000000">script.plex/white-square.png</texture>
</control>
{% endblock background %}
{% block content %}
<control type="group" id="50">
    <animation effect="slide" end="0,{{ vscale(-125) }}" time="200" tween="quadratic" easing="out" condition="!String.IsEmpty(Window.Property(on.extras))">Conditional</animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + Control.IsVisible(500)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-330) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),1) + Control.IsVisible(501)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-380) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),2) + Control.IsVisible(502)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-400) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),3) + Control.IsVisible(503)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-360) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <ondown condition="!String.IsEmpty(Window.Property(disable_playback))">400</ondown>

    <posx>0</posx>
    <posy>{{ vscale(155) }}</posy>
    <!--<defaultcontrol>101</defaultcontrol>-->

    {% block buttons %}
        {% if theme.episodes.use_button_bg %}
            <control type="image">
                <visible>false</visible>
                <posx>60</posx>
                <posy>{{ vscale(369) }}</posy>
                <width>657</width>
                <height>{{ vscale(104) }}</height>
                <texture>script.plex/white-square.png</texture>
                <colordiffuse>{{ theme.episodes.button_bg_color|default(66000000) }}</colordiffuse>
            </control>
        {% endif %}
        <control type="grouplist" id="300">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
            <visible allowhiddenfocus="!String.IsEmpty(Container(400).ListItem.Property(media.multiple))">String.IsEmpty(Container(400).ListItem.Property(media.multiple)) + !String.IsEmpty(Window.Property(initialized)) + String.IsEmpty(Window.Property(disable_playback))</visible>
            <defaultcontrol always="true">301</defaultcontrol>
            <posx>155</posx>
            <posy>{{ vscale(315) }}</posy>
            <width>1600</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>400</ondown>
            <align>left</align>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <scrolltime tween="quadratic" easing="out">200</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>

            {% with attr = theme.episodes.buttons & template = "includes/themed_button.xml.tpl" & episode_style = True %}
                {% include template with name="play" & id=301 &
                    enable="!String.IsEmpty(Window.Property(current_item.loaded))" & visible="!String.IsEmpty(Window.Property(current_item.loaded))" &
                    allowhiddenfocus=True & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106
                %}
                {% include template with name="play" & id=306 &
                                    visible="String.IsEmpty(Window.Property(current_item.loaded))" &
                                    action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106
                %}
                {% include template with name="info" & id=304 & action_label="$LOCALIZE[29915]" & action_width=154 & action_label_width=82 %}
                {% include template with name="settings" & id=305 & action_label="$ADDON[script.plexmod 35064]" & action_width=175 & action_label_width=103 %}
                {% include template with name="more" & id=303 & action_label="$ADDON[script.plexmod 32307]" & action_width=140 & action_label_width=68 %}
                {% include template with name="shuffle" & id=302 & action_label="$ADDON[script.plexmod 32935]" & action_width=300 & action_label_width=228 %}
            {% endwith %}
        </control>
        <control type="grouplist" id="1300">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
            <visible>!String.IsEmpty(Container(400).ListItem.Property(media.multiple)) + !String.IsEmpty(Window.Property(initialized)) + String.IsEmpty(Window.Property(disable_playback))</visible>
            <defaultcontrol always="true">1301</defaultcontrol>
            <posx>155</posx>
            <posy>{{ vscale(315) }}</posy>
            <width>1600</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>400</ondown>
            <align>left</align>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <scrolltime tween="quadratic" easing="out">200</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>

            {% with attr = theme.episodes.buttons_1300 & template = "includes/themed_button.xml.tpl" & episode_style = True %}
                {% include template with name="play" & id=1301 &
                    enable="!String.IsEmpty(Window.Property(current_item.loaded))" & visible="!String.IsEmpty(Window.Property(current_item.loaded))" &
                    allowhiddenfocus=True & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106
                %}
                {% include template with name="play" & id=1306 &
                                    visible="String.IsEmpty(Window.Property(current_item.loaded))" &
                                    action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106
                %}
                {% include template with name="info" & id=1304 & action_label="$LOCALIZE[29915]" & action_width=154 & action_label_width=82 %}
                {% include template with name="media" & id=1307 & action_label="$ADDON[script.plexmod 35063]" & action_width=180 & action_label_width=108 %}
                {% include template with name="settings" & id=1305 & action_label="$ADDON[script.plexmod 35064]" & action_width=175 & action_label_width=103 %}
                {% include template with name="more" & id=1303 & action_label="$ADDON[script.plexmod 32307]" & action_width=140 & action_label_width=68 %}
                {% include template with name="shuffle" & id=1302 & action_label="$ADDON[script.plexmod 32935]" & action_width=300 & action_label_width=228 %}
            {% endwith %}

        </control>
    {% endblock %}

    <control type="group">
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>{{ vscale(600) }}</height>
        <control type="group">
            <control type="image">
                <visible>false</visible>
                <posx>160</posx>
                <posy>0</posy>
                <width>520</width>
                <height>{{ vscale(293) }}</height>
                <texture background="true" diffuse="script.plex/episode-hero-rounded-mask.png">script.plex/home/background-fallback_black.png</texture>
                <aspectratio>scale</aspectratio>
            </control>
            <control type="image">
                <posx>160</posx>
                <posy>0</posy>
                <width>520</width>
                <height>{{ vscale(293) }}</height>
                <texture background="true" fallback="script.plex/thumb_fallbacks/show.png" diffuse="script.plex/episode-hero-rounded-mask.png">$INFO[Container(400).ListItem.Thumb]</texture>
                <aspectratio>scale</aspectratio>
            </control>
            {% include "includes/watched_indicator.xml.tpl" with itemref="Container(400).ListItem" & xoff=520+160 & uw_size=35 & scale="large" %}
        </control>

        <control type="grouplist">
            <posx>740</posx>
            <posy>0</posy>
            <width>880</width>
            <height>{{ vscale(60) }}</height>
            <align>left</align>
            <itemgap>0</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <visible>String.IsEmpty(Container(400).ListItem.Property(remainingTime))</visible>
                <width max="880">auto</width>
                <height>{{ vscale(60) }}</height>
                <font>font13</font>
                <align>left</align>
                <aligny>top</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Container(400).ListItem.Property(title)]</label>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(remainingTime))</visible>
                <width max="700">auto</width>
                <height>{{ vscale(60) }}</height>
                <font>font13</font>
                <align>left</align>
                <aligny>top</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Container(400).ListItem.Property(title)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(remainingTime))</visible>
                <posx>10</posx>
                <posy>6</posy>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>15</textoffsetx>
                <texturefocus colordiffuse="40000000" border="12">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="12">script.plex/white-square-rounded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(remainingTime)]</label>
            </control>
        </control>
        <control type="label">
            <posx>740</posx>
            <posy>{{ vscale(50) }}</posy>
            <width>714</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>top</aligny>
            <scroll>false</scroll>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Container(400).ListItem.Property(show.title)]</label>
        </control>

        <control type="grouplist">
            <posx>740</posx>
            <posy>{{ vscale(100) }}</posy>
            <width>1360</width>
            <height>{{ vscale(30) }}</height>
            <align>left</align>
            <itemgap>0</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>left</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Container(400).ListItem.Property(season)]$INFO[Container(400).ListItem.Property(episode), &#8226; , / ]$INFO[Container(400).ListItem.Property(date)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(unavailable))</visible>
                <posx>10</posx>
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>15</textoffsetx>
                <texturefocus colordiffuse="FFAC3223" border="12">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus colordiffuse="FFAC3223" border="12">script.plex/white-square-rounded.png</texturenofocus>
                <label>$ADDON[script.plexmod 32312]</label>
            </control>
        </control>
        <control type="grouplist">
            <posx>740</posx>
            <posy>{{ vscale(148) }}</posy>
            <width>1360</width>
            <height>{{ vscale(34) }}</height>
            <align>left</align>
            <itemgap>10</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="label">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Container(400).ListItem.Property(duration)]$INFO[Container(400).ListItem.Property(genre), &#8226; ]$INFO[Container(400).ListItem.Property(year), &#8226; ]$INFO[Container(400).ListItem.Property(content.rating), &#8226; ]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(rating))</visible>
                <posy>2</posy>
                <width>63</width>
                <height>{{ vscale(30) }}</height>
                <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Container(400).ListItem.Property(rating.image)]</texture>
                <aspectratio align="right">keep</aspectratio>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(rating))</visible>
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>left</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Container(400).ListItem.Property(rating)]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(rating2))</visible>
                <posy>2</posy>
                <width>40</width>
                <height>{{ vscale(30) }}</height>
                <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Container(400).ListItem.Property(rating2.image)]</texture>
                <aspectratio align="right">keep</aspectratio>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(rating2))</visible>
                <width>auto</width>
                <height>{{ vscale(30) }}</height>
                <font>font12</font>
                <align>left</align>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Container(400).ListItem.Property(rating2)]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(rating.stars))</visible>
                <width>134</width>
                <height>{{ vscale(22) }}</height>
                <texture>script.plex/stars/$INFO[Container(400).ListItem.Property(rating.stars)].png</texture>
                <aspectratio align="left">keep</aspectratio>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(video.res))</visible>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>14</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(video.res)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(video.rendering))</visible>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>14</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(video.rendering)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(video.codec))</visible>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>14</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(video.codec)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(audio.codec))</visible>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>14</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(audio.codec)]</label>
            </control>
            <control type="button">
                <visible>!String.IsEmpty(Container(400).ListItem.Property(audio.channels))</visible>
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>14</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$INFO[Container(400).ListItem.Property(audio.channels)]</label>
            </control>
        </control>

        <control type="label">
            <visible>!String.IsEmpty(Container(400).ListItem.Property(creators))</visible>
            <posx>740</posx>
            <posy>{{ vscale(194) }}</posy>
            <width>1360</width>
            <height>{{ vscale(30) }}</height>
            <font>font12</font>
            <align>left</align>
            <textcolor>99FFFFFF</textcolor>
            <label>$INFO[Container(400).ListItem.Property(creators)]</label>
        </control>

        <control type="grouplist">
            <visible>!String.IsEmpty(Container(400).ListItem.Property(audio))</visible>
            <posx>740</posx>
            <posy>{{ vscale(263) }}</posy>
            <width>500</width>
            <height>{{ vscale(34) }}</height>
            <align>left</align>
            <itemgap>15</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="button">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>top</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>15</textoffsetx>
                <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$ADDON[script.plexmod 32395]</label>
            </control>
            <control type="label">
                <width>360</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>top</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Container(400).ListItem.Property(audio)]</label>
            </control>
        </control>
        <control type="grouplist">
            <visible>!String.IsEmpty(Container(400).ListItem.Property(subtitles))</visible>
            <posx>1280</posx>
            <posy>{{ vscale(263) }}</posy>
            <width>544</width>
            <height>{{ vscale(34) }}</height>
            <align>left</align>
            <itemgap>15</itemgap>
            <orientation>horizontal</orientation>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="button">
                <width>auto</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>center</align>
                <aligny>top</aligny>
                <focusedcolor>FFFFFFFF</focusedcolor>
                <textcolor>FFFFFFFF</textcolor>
                <textoffsetx>15</textoffsetx>
                <texturefocus colordiffuse="40000000" border="12">script.plex/white-square-rounded-top-padded.png</texturefocus>
                <texturenofocus colordiffuse="40000000" border="12">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                <label>$ADDON[script.plexmod 32396]</label>
            </control>
            <control type="label">
                <width>330</width>
                <height>{{ vscale(34) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>top</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Container(400).ListItem.Property(subtitles)]</label>
            </control>
        </control>
        <control type="textbox">
            <posx>740</posx>
            <posy>{{ vscale(420) }}</posy>
            <width>1084</width>
            <height>{{ vscale(110) }}</height>
            <font>font12</font>
            <align>left</align>
            <textcolor>FFFFFFFF</textcolor>
            <scrolltime>200</scrolltime>
            <autoscroll>false</autoscroll>
            <label>$INFO[Container(400).ListItem.Property(summary)]</label>
        </control>

        <control type="image" id="250">
            <visible>!String.IsEmpty(Window.Property(current_item.loaded))</visible>
            <animation effect="zoom" start="0,100" end="100,100" time="1000" center="-1,561" reversible="false" tween="circle" easing="out">Visible</animation>
            <posx>-1</posx>
            <posy>{{ vscale(557) }}</posy>
            <width>1</width>
            <height>{{ vscale(8) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>FFCC7B19</colordiffuse>
        </control>
    </control>

    <!-- EPISODES -->
    <control type="grouplist" id="60">
        <visible>!String.IsEmpty(Window.Property(initialized))</visible>
        <posx>0</posx>
        <posy>{{ vscale(565) }}</posy>
        <width>1920</width>
        <height>{{ vscale(1800) }}</height>

        <onup condition="Control.IsVisible(300)">300</onup>
        <onup condition="Control.IsVisible(1300)">1300</onup>
        <onup condition="!Control.IsVisible(1300) + !Control.IsVisible(300)">200</onup>
        <itemgap>0</itemgap>

        <!-- EPISODES -->
        <control type="group" id="500">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
            <visible>Integer.IsGreater(Container(400).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <height>{{ vscale(330) }}</height>
            <width>1920</width>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1600</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(episodes.header)]</label>
            </control>
            <control type="list" id="400">
                <posx>100</posx>
                <posy>{{ vscale(30) }}</posy>
                <width>1740</width>
                <height>{{ vscale(320) }}</height>
                <onup condition="Control.IsVisible(300)">300</onup>
                <onup condition="Control.IsVisible(1300)">1300</onup>
                <ondown>401</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                {% include "includes/episode_card_layout.xml.tpl" %}
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="359" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>299</width>
                                <height>{{ vscale(168) }}</height>
                                <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>299</width>
                                <height>{{ vscale(168) }}</height>
                                <texture background="true">$INFO[ListItem.Thumb]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(158) }}</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(10) }}</height>
                                    <texture>script.plex/white-square.png</texture>
                                    <colordiffuse>C0000000</colordiffuse>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>1</posy>
                                    <width>299</width>
                                    <height>{{ vscale(8) }}</height>
                                    <texture>$INFO[ListItem.Property(progress)]</texture>
                                    <colordiffuse>FFCC7B19</colordiffuse>
                                </control>
                            </control>
                            {% include "includes/watched_indicator.xml.tpl" with xoff=299 & uw_size=35 & wbw_w=40 %}

                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(175) }}</posy>
                                <width>299</width>
                                <height>{{ vscale(60) }}</height>
                                <font>font12</font>
                                <align>center</align>
                                <textcolor>AAFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(210) }}</posy>
                                <width>299</width>
                                <height>{{ vscale(60) }}</height>
                                <font>font12</font>
                                <align>center</align>
                                <textcolor>AAFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(168) }}</height>
                                    <texture colordiffuse="FF404040">script.plex/white-square.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                    <posx>119</posx>
                                    <posy>{{ vscale(34) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                    <posx>119</posx>
                                    <posy>{{ vscale(34) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white-l.png</texture>
                                </control>
                                <control type="image">
                                    <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                                    <posx>85.5</posx>
                                    <posy>{{ vscale(20) }}</posy>
                                    <width>128</width>
                                    <height>{{ vscale(128) }}</height>
                                    <texture>script.plex/home/busy.gif</texture>
                                </control>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="359" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="110" time="100" center="154.5,{{ vscale(87.5) }}" reversible="false">Focus</animation>
                            <animation effect="zoom" start="110" end="100" time="100" center="154.5,{{ vscale(87.5) }}" reversible="false">UnFocus</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(400)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>389</width>
                                <height>{{ vscale(258) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(168) }}</height>
                                    <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                                    <aspectratio>scale</aspectratio>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(168) }}</height>
                                    <texture background="true">$INFO[ListItem.Thumb]</texture>
                                    <aspectratio>scale</aspectratio>
                                </control>
                                <control type="group">
                                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(158) }}</posy>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>299</width>
                                        <height>{{ vscale(10) }}</height>
                                        <texture>script.plex/white-square.png</texture>
                                        <colordiffuse>C0000000</colordiffuse>
                                    </control>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>1</posy>
                                        <width>299</width>
                                        <height>{{ vscale(8) }}</height>
                                        <texture>$INFO[ListItem.Property(progress)]</texture>
                                        <colordiffuse>FFCC7B19</colordiffuse>
                                    </control>
                                </control>
                                {% include "includes/watched_indicator.xml.tpl" with xoff=299 & uw_size=35 & wbw_w=40 %}

                                <control type="group">
                                    <visible>Control.HasFocus(400)</visible>
                                    <control type="label">
                                        <scroll>true</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(175) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font12</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label]</label>
                                    </control>
                                    <control type="label">
                                        <scroll>true</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(210) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font12</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label2]</label>
                                    </control>
                                </control>
                                <control type="group">
                                    <visible>!Control.HasFocus(400)</visible>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(175) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font12</font>
                                        <align>center</align>
                                        <textcolor>FFCC7B19</textcolor>
                                        <label>$INFO[ListItem.Label]</label>
                                    </control>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(210) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font12</font>
                                        <align>center</align>
                                        <textcolor>FFCC7B19</textcolor>
                                        <label>$INFO[ListItem.Label2]</label>
                                    </control>
                                </control>
                                <control type="group">
                                    <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>299</width>
                                        <height>{{ vscale(168) }}</height>
                                        <texture colordiffuse="FF404040">script.plex/white-square.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                        <posx>119</posx>
                                        <posy>{{ vscale(34) }}</posy>
                                        <width>61</width>
                                        <height>{{ vscale(100) }}</height>
                                        <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                        <posx>119</posx>
                                        <posy>{{ vscale(34) }}</posy>
                                        <width>61</width>
                                        <height>{{ vscale(100) }}</height>
                                        <texture colordiffuse="40000000">script.plex/indicators/chevron-white-l.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                                        <posx>85.5</posx>
                                        <posy>{{ vscale(20) }}</posy>
                                        <width>128</width>
                                        <height>{{ vscale(128) }}</height>
                                        <texture>script.plex/home/busy.gif</texture>
                                    </control>
                                </control>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(400)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>309</width>
                                <height>{{ vscale(178) }}</height>
                                <texture border="10">script.plex/home/selected.png</texture>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- EPISODES -->

        <!-- Seasons -->
        <control type="group" id="501">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),1)">Conditional</animation>
            <visible>Integer.IsGreater(Container(401).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <height>{{ vscale(380) }}</height>
            <width>1920</width>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>800</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(seasons.header)]</label>
            </control>
            <control type="list" id="401">
                <posx>100</posx>
                <posy>{{ vscale(36) }}</posy>
                <width>1740</width>
                <height>{{ vscale(380) }}</height>
                <onup>400</onup>
                <ondown>402</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="218">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(29) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>158</width>
                                <height>{{ vscale(236) }}</height>
                                <texture diffuse="script.plex/poster-season-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>158</width>
                                <height>{{ vscale(236) }}</height>
                                <texture background="true" diffuse="script.plex/poster-season-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            {% include "includes/watched_indicator.xml.tpl" with with_count=True %}

                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(230) }}</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>158</width>
                                    <height>{{ vscale(6) }}</height>
                                    <texture>script.plex/white-square.png</texture>
                                    <colordiffuse>C0000000</colordiffuse>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>1</posy>
                                    <width>158</width>
                                    <height>{{ vscale(4) }}</height>
                                    <texture>$INFO[ListItem.Property(progress)]</texture>
                                    <colordiffuse>FFCC7B19</colordiffuse>
                                </control>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(240) }}</posy>
                                <width>158</width>
                                <height>{{ vscale(54) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="218">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(29) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="106" time="110" center="84,{{ vscale(123) }}" reversible="true" condition="Control.HasFocus(401)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(401)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>248</width>
                                <height>{{ vscale(326) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(401)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>168</width>
                                <height>{{ vscale(246) }}</height>
                                <texture>script.plex/poster-season-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                    <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>158</width>
                                    <height>{{ vscale(236) }}</height>
                                    <texture diffuse="script.plex/poster-season-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>158</width>
                                    <height>{{ vscale(236) }}</height>
                                    <texture background="true" diffuse="script.plex/poster-season-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                                    <aspectratio>scale</aspectratio>
                                </control>
                                {% include "includes/watched_indicator.xml.tpl" with with_count=True %}

                                <control type="group">
                                    <visible>!String.IsEmpty(ListItem.Property(progress))</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(230) }}</posy>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>158</width>
                                        <height>{{ vscale(6) }}</height>
                                        <texture>script.plex/white-square.png</texture>
                                        <colordiffuse>C0000000</colordiffuse>
                                    </control>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>1</posy>
                                        <width>158</width>
                                        <height>{{ vscale(4) }}</height>
                                        <texture>$INFO[ListItem.Property(progress)]</texture>
                                        <colordiffuse>FFCC7B19</colordiffuse>
                                    </control>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>0</posx>
                                    <posy>{{ vscale(240) }}</posy>
                                    <width>158</width>
                                    <height>{{ vscale(54) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>FFFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- Seasons -->

        <!-- ROLES -->
        <control type="group" id="502">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),2)">Conditional</animation>
            <visible>Integer.IsGreater(Container(402).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>402</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(400) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$ADDON[script.plexmod 35019]</label>
            </control>
            <control type="list" id="402">
                <posx>100</posx>
                <posy>{{ vscale(48) }}</posy>
                <width>1740</width>
                <height>{{ vscale(400) }}</height>
                <onup>401</onup>
                <ondown>403</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                {% include "includes/role_card_layout.xml.tpl" with role_focus_id=402 %}
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="304" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>244</width>
                                <height>{{ vscale(244) }}</height>
                                <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>244</width>
                                <height>{{ vscale(244) }}</height>
                                <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                                <aspectratio scalediffuse="false" aligny="top">scale</aspectratio>
                            </control>
                            <control type="group">
                                <posx>0</posx>
                                <posy>{{ vscale(253) }}</posy>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(60) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>AAFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>0</posx>
                                    <posy>{{ vscale(30) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(60) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>AAFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="304" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="110" time="100" center="127,{{ vscale(127) }}" reversible="false">Focus</animation>
                            <animation effect="zoom" start="110" end="100" time="100" center="127,{{ vscale(127) }}" reversible="false">UnFocus</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(402)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>334</width>
                                <height>{{ vscale(334) }}</height>
                                <texture border="42">script.plex/buttons/role-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(402)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(254) }}</height>
                                <texture>script.plex/circle-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(244) }}</height>
                                    <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(244) }}</height>
                                    <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                                    <aspectratio scalediffuse="false" aligny="top">scale</aspectratio>
                                </control>
                                <control type="group">
                                    <posx>0</posx>
                                    <posy>{{ vscale(253) }}</posy>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>244</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label]</label>
                                    </control>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(30) }}</posy>
                                        <width>244</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label2]</label>
                                    </control>
                                </control>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- ROLES -->

        <!-- EXTRAS -->
        <control type="group" id="503">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),3)">Conditional</animation>
            <visible>Integer.IsGreater(Container(403).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <height>{{ vscale(360) }}</height>
            <width>1920</width>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>800</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(extras.header)]</label>
            </control>
            <control type="list" id="403">
                <posx>100</posx>
                <posy>{{ vscale(18) }}</posy>
                <width>1740</width>
                <height>{{ vscale(430) }}</height>
                <onup>402</onup>
                <ondown>404</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                {% include "includes/episode_extra_card_layout.xml.tpl" %}
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="359" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>299</width>
                                <height>{{ vscale(168) }}</height>
                                <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>299</width>
                                <height>{{ vscale(168) }}</height>
                                <texture background="true">$INFO[ListItem.Thumb]</texture>
                                <aspectratio>scale</aspectratio>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(175) }}</posy>
                                <width>299</width>
                                <height>{{ vscale(60) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>AAFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
                                <posy>{{ vscale(205) }}</posy>
                                <width>299</width>
                                <height>{{ vscale(60) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>AAFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="359" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="110" time="100" center="154.5,{{ vscale(87.5) }}" reversible="false">Focus</animation>
                            <animation effect="zoom" start="110" end="100" time="100" center="154.5,{{ vscale(87.5) }}" reversible="false">UnFocus</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(403)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>389</width>
                                <height>{{ vscale(258) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(168) }}</height>
                                    <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                                    <aspectratio>scale</aspectratio>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>299</width>
                                    <height>{{ vscale(168) }}</height>
                                    <texture background="true">$INFO[ListItem.Thumb]</texture>
                                    <aspectratio>scale</aspectratio>
                                </control>
                                <control type="group">
                                    <control type="label">
                                        <scroll>Control.HasFocus(403)</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(175) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label]</label>
                                    </control>
                                    <control type="label">
                                        <scroll>Control.HasFocus(403)</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(205) }}</posy>
                                        <width>299</width>
                                        <height>{{ vscale(60) }}</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <textcolor>AAFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label2]</label>
                                    </control>
                                </control>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(403)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>309</width>
                                <height>{{ vscale(178) }}</height>
                                <texture border="10">script.plex/home/selected.png</texture>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- EXTRAS -->

        <!-- RELATED -->
        <control type="group" id="504">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),4)">Conditional</animation>
            <visible>Integer.IsGreater(Container(404).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>404</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(520) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(related.header)]</label>
            </control>
            <control type="list" id="404">
                <posx>100</posx>
                <posy>{{ vscale(16) }}</posy>
                <width>1740</width>
                <height>{{ vscale(520) }}</height>
                <onup>403</onup>
                <ondown>404</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                {% include "includes/episode_related_card_layout.xml.tpl" %}
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="304" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture colordiffuse="FF404040">script.plex/white-square.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                    <posx>91.5</posx>
                                    <posy>{{ vscale(130.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                    <posx>91.5</posx>
                                    <posy>{{ vscale(130.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white-l.png</texture>
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
                                <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>244</width>
                                <height>{{ vscale(361) }}</height>
                                <texture background="true">$INFO[ListItem.Thumb]</texture>
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
                            {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}

                            <control type="label">
                                <scroll>false</scroll>
                                <posx>0</posx>
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

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="304" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="110" time="100" center="127,{{ vscale(180.5) }}" reversible="false">Focus</animation>
                            <animation effect="zoom" start="110" end="100" time="100" center="127,{{ vscale(180.5) }}" reversible="false">UnFocus</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture colordiffuse="FF404040">script.plex/white-square.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                    <posx>91.5</posx>
                                    <posy>{{ vscale(130.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                    <posx>91.5</posx>
                                    <posy>{{ vscale(130.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white-l.png</texture>
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
                                <visible>Control.HasFocus(404)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>324</width>
                                <height>{{ vscale(441) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture>$INFO[ListItem.Property(thumb.fallback)]</texture>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture background="true">$INFO[ListItem.Thumb]</texture>
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
                                {% include "includes/watched_indicator.xml.tpl" with xoff=244 & uw_size=48 & with_count=True & scale="medium" %}
                                <control type="label">
                                    <scroll>Control.HasFocus(404)</scroll>
                                    <posx>0</posx>
                                    <posy>{{ vscale(369) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(38) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>FFFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(404)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(371) }}</height>
                                <texture border="10">script.plex/home/selected.png</texture>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- / RELATED -->

    </control>
</control>
{% endblock content %}
