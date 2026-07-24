{% extends "default.xml.tpl" %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(preplay.background.blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <fadetime>450</fadetime>
    <texture background="true">$INFO[Window.Property(preplay.background.blurred)]</texture>
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
    <texture colordiffuse="28000000">script.plex/white-square.png</texture>
</control>
{% endblock background %}
{% block content %}
<control type="group" id="50">
    <animation effect="slide" end="0,{{ vscale(-300) }}" time="200" tween="quadratic" easing="out" condition="!String.IsEmpty(Window.Property(on.extras))">Conditional</animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + Control.IsVisible(500)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-650) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),1) + Control.IsVisible(501)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-446) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),2) + Control.IsVisible(502)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-446) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),3) + Control.IsVisible(503)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-555) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),4) + Control.IsVisible(504)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-555) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),5) + Control.IsVisible(505)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-555) }}" time="200" tween="quadratic" easing="out"/>
    </animation>

    <posx>0</posx>
    <posy>{{ vscale(135) }}</posy>
    <defaultcontrol>101</defaultcontrol>

    {% block buttons %}
        <control type="grouplist" id="300">
            <animation effect="fade" start="0" end="100" time="200" reversible="true">VisibleChange</animation>
            <visible>!String.IsEmpty(Window.Property(initialized))</visible>
            <defaultcontrol>302</defaultcontrol>
            <posx>155</posx>
            <posy>{{ vscale(405) }}</posy>
            <width>1600</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>400</ondown>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <scrolltime tween="quadratic" easing="out">200</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>

            {% with attr = theme.pre_play.buttons & template = "includes/themed_button.xml.tpl" & preplay_style = True %}
                {% include template with name="play" & id=302 & visible="String.IsEmpty(Window.Property(unavailable)) + String.IsEmpty(Window.Property(disable_playback))" & action_label="$LOCALIZE[208]" & action_width=178 & action_label_width=106 %}
                {% include "includes/wl_dynamic_buttons.xml.tpl" %}
                {% include template with name="info" & id=304 & action_label="$LOCALIZE[29915]" & action_width=154 & action_label_width=82 %}
                {% include template with name="trailer" & id=303 & visible="!String.IsEmpty(Window.Property(trailer.button))" & action_label="$ADDON[script.plexmod 32201]" & action_width=250 & action_label_width=178 %}
                {% include "includes/wl_add_remove_buttons.xml.tpl" %}
                {% include template with name="media" & id=307 & visible="!String.IsEmpty(Window.Property(media.multiple))" & action_label="$ADDON[script.plexmod 35063]" & action_width=180 & action_label_width=108 %}
                {% include template with name="settings" & id=305 & visible="String.IsEmpty(Window.Property(disable_playback))" & action_label="$ADDON[script.plexmod 35064]" & action_width=175 & action_label_width=103 %}
                {% include template with name="more" & id=306 & visible="String.IsEmpty(Window.Property(disable_playback))" & action_label="$ADDON[script.plexmod 32307]" & action_width=140 & action_label_width=68 %}
            {% endwith %}

        </control>
    {% endblock %}

    {% block details %}
        <control type="group">
            <!-- HERO COPY: leave the lower-detail focus state as one clean composition. -->
            <animation effect="fade" start="100" end="0" time="140" condition="!String.IsEmpty(Window.Property(on.extras))">Conditional</animation>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(600) }}</height>
            <control type="group">
                <visible>false</visible>
                <control type="image">
                    <posx>60</posx>
                    <posy>0</posy>
                    <width>347</width>
                    <height>{{ vscale(518) }}</height>
                    <texture background="true">script.plex/thumb_fallbacks/movie.png</texture>
                    <animation effect="fade" start="0" end="100" time="0" delay="500">WindowOpen</animation>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <posx>60</posx>
                    <posy>0</posy>
                    <width>347</width>
                    <height>{{ vscale(518) }}</height>
                    <texture background="true">$INFO[Window.Property(thumb)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
                {% include "includes/watched_indicator.xml.tpl" with itemref="Window" & xoff=347+60 & uw_size=48 & scale="medium" %}

            </control>

            <control type="group">
                <visible>false</visible>
                <posx>60</posx>
                <posy>0</posy>
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>347</width>
                    <height>{{ vscale(315) }}</height>
                    <texture background="true">script.plex/thumb_fallbacks/show.png</texture>
                    <animation effect="fade" start="0" end="100" time="0" delay="500">WindowOpen</animation>
                    <aspectratio>scale</aspectratio>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>{{ vscale(323) }}</posy>
                    <width>347</width>
                    <height>{{ vscale(195) }}</height>
                    <texture colordiffuse="FF111111">script.plex/white-square.png</texture>
                    <aspectratio>scale</aspectratio>
                </control>

                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>347</width>
                    <height>{{ vscale(315) }}</height>
                    <texture background="true">$INFO[Window.Property(thumb)]</texture>
                    <aspectratio aligny="top">scale</aspectratio>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>{{ vscale(323) }}</posy>
                    <width>347</width>
                    <height>{{ vscale(195) }}</height>
                    <texture background="true">$INFO[Window.Property(preview)]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
            </control>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1120</width>
                <height>{{ vscale(78) }}</height>
                <font>font60</font>
                <align>left</align>
                <aligny>center</aligny>
                <scroll>false</scroll>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(title)]</label>
            </control>
            <control type="grouplist">
                <posx>160</posx>
                <posy>{{ vscale(84) }}</posy>
                <width>1500</width>
                <height>{{ vscale(34) }}</height>
                <align>left</align>
                <itemgap>10</itemgap>
                <orientation>horizontal</orientation>
                <usecontrolcoords>true</usecontrolcoords>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(content.rating))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>F2FFFFFF</focusedcolor>
                    <textcolor>F2FFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="C0343436" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="C0343436" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(content.rating)]</label>
                </control>
                <control type="label">
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>left</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[Window.Property(meta.primary)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(video.res))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(video.res)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(video.rendering))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(video.rendering)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(video.codec))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(video.codec)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(audio.codec))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(audio.codec)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(audio.channels))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(audio.channels)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(remainingTime))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>14</textoffsetx>
                    <texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$INFO[Window.Property(remainingTime)]</label>
                </control>
                <control type="button">
                    <visible>!String.IsEmpty(Window.Property(unavailable))</visible>
                    <width>auto</width>
                    <height>{{ vscale(34) }}</height>
                    <font>font12</font>
                    <align>center</align>
                    <aligny>top</aligny>
                    <focusedcolor>FFFFFFFF</focusedcolor>
                    <textcolor>FFFFFFFF</textcolor>
                    <textoffsetx>15</textoffsetx>
                    <texturefocus colordiffuse="FFAC3223" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                    <texturenofocus colordiffuse="FFAC3223" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                    <label>$ADDON[script.plexmod 32312]</label>
                </control>
            </control>

            <control type="grouplist">
                <visible>!String.IsEmpty(Window.Property(rating)) | !String.IsEmpty(Window.Property(rating2))</visible>
                <posx>160</posx>
                <posy>{{ vscale(126) }}</posy>
                <width>620</width>
                <height>{{ vscale(32) }}</height>
                <align>left</align>
                <itemgap>12</itemgap>
                <orientation>horizontal</orientation>
                <usecontrolcoords>true</usecontrolcoords>
                <control type="image">
                    <visible>!String.IsEmpty(Window.Property(rating))</visible>
                    <posy>2</posy>
                    <width>63</width>
                    <height>{{ vscale(30) }}</height>
                    <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(rating.image)]</texture>
                    <aspectratio align="right">keep</aspectratio>
                </control>
                <control type="label">
                    <visible>!String.IsEmpty(Window.Property(rating))</visible>
                    <width>auto</width>
                    <height>{{ vscale(30) }}</height>
                    <font>font10</font>
                    <align>left</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[Window.Property(rating)]</label>
                </control>
                <control type="image">
                    <visible>!String.IsEmpty(Window.Property(rating2))</visible>
                    <posy>2</posy>
                    <width>40</width>
                    <height>{{ vscale(30) }}</height>
                    <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(rating2.image)]</texture>
                    <aspectratio align="right">keep</aspectratio>
                </control>
                <control type="label">
                    <visible>!String.IsEmpty(Window.Property(rating2))</visible>
                    <width>auto</width>
                    <height>{{ vscale(30) }}</height>
                    <font>font10</font>
                    <align>left</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[Window.Property(rating2)]</label>
                </control>
                <control type="image">
                    <visible>!String.IsEmpty(Window.Property(rating.stars))</visible>
                    <posy>6</posy>
                    <width>134</width>
                    <height>{{ vscale(22) }}</height>
                    <texture>script.plex/stars/$INFO[Window.Property(rating.stars)].png</texture>
                </control>
            </control>
            {% block cast_detail_and_streams %}
                <control type="label">
                    <visible>!String.IsEmpty(Window.Property(directors)) | !String.IsEmpty(Window.Property(writers))</visible>
                    <posx>160</posx>
                    <posy>{{ vscale(284) }}</posy>
                    <width>1120</width>
                    <height>{{ vscale(30) }}</height>
                    <font>font10</font>
                    <align>left</align>
                    <textcolor>CCFFFFFF</textcolor>
                    <label>$INFO[Window.Property(creators)]</label>
                </control>
                <control type="label">
                    <visible>false</visible>
                    <posx>466</posx>
                    <posy>{{ vscale(165) }}</posy>
                    <width>1360</width>
                    <height>{{ vscale(30) }}</height>
                    <font>font12</font>
                    <align>left</align>
                    <textcolor>99FFFFFF</textcolor>
                    <label>$INFO[Window.Property(cast)]</label>
                </control>
                {% block streams %}
                    <control type="grouplist">
                        <posx>160</posx>
                        <posy>{{ vscale(324) }}</posy>
                        <width>1500</width>
                        <height>{{ vscale(38) }}</height>
                        <align>left</align>
                        <itemgap>15</itemgap>
                        <orientation>horizontal</orientation>
                        <usecontrolcoords>true</usecontrolcoords>
                        <control type="button">
                            <visible>!String.IsEmpty(Window.Property(audio))</visible>
                            <width>auto</width>
                            <height>{{ vscale(38) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <aligny>center</aligny>
                            <focusedcolor>FFFFFFFF</focusedcolor>
                            <textcolor>FFFFFFFF</textcolor>
                            <textoffsetx>15</textoffsetx>
                            <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                            <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                            <label>$ADDON[script.plexmod 32048]</label>
                        </control>
                        <control type="label">
                            <width>auto</width>
                            <height>{{ vscale(38) }}</height>
                            <font>font10</font>
                            <align>left</align>
                            <aligny>center</aligny>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[Window.Property(audio)]</label>
                        </control>
                        <control type="button">
                            <visible>!String.IsEmpty(Window.Property(subtitles))</visible>
                            <left>30</left>
                            <width>auto</width>
                            <height>{{ vscale(38) }}</height>
                            <font>font10</font>
                            <align>center</align>
                            <aligny>center</aligny>
                            <focusedcolor>FFFFFFFF</focusedcolor>
                            <textcolor>FFFFFFFF</textcolor>
                            <textoffsetx>15</textoffsetx>
                            <texturefocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
                            <texturenofocus colordiffuse="40000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
                            <label>$ADDON[script.plexmod 32396]</label>
                        </control>
                        <control type="label">
                            <visible>!String.IsEmpty(Window.Property(subtitles))</visible>
                            <width>auto</width>
                            <height>{{ vscale(38) }}</height>
                            <font>font10</font>
                            <align>left</align>
                            <aligny>center</aligny>
                            <textcolor>FFFFFFFF</textcolor>
                            <label>$INFO[Window.Property(subtitles)]</label>
                        </control>
                    </control>
                {% endblock %}
            {% endblock %}
            {% block summary %}
                <control type="textbox">
                    <posx>160</posx>
                    <posy>{{ vscale(169) }}</posy>
                    <width>1040</width>
                    <height>{{ vscale(96) }}</height>
                    <font>font12</font>
                    <align>left</align>
                    <textcolor>FFFFFFFF</textcolor>
                    <scrolltime>0</scrolltime>
                    <autoscroll>false</autoscroll>
                    <label>$INFO[Window.Property(summary.short)]</label>
                </control>
            {% endblock %}
            <control type="image" id="250">
                <animation effect="zoom" start="0,100" end="100,100" time="1000" center="-1,561" reversible="false" tween="circle" easing="out">WindowOpen</animation>
                <posx>-1</posx>
                <posy>{{ vscale(585) }}</posy>
                <width>1</width>
                <height>{{ vscale(8) }}</height>
                <texture>script.plex/white-square.png</texture>
                <colordiffuse>FFCC7B19</colordiffuse>
            </control>
            <!-- /HERO COPY -->
        </control>
    {% endblock %}

    <control type="grouplist" id="60">
        <posx>0</posx>
        <posy>{{ vscale(600) }}</posy>
        <width>1920</width>
        <height>{{ vscale(3400) }}</height>

        <onup>300</onup>
        <itemgap>0</itemgap>

        <!-- ROLES -->
        <control type="group" id="500">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),0)">Conditional</animation>
            <visible>Integer.IsGreater(Container(400).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>400</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(370) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>800</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$ADDON[script.plexmod 35019]</label>
            </control>
            <control type="list" id="400">
                <posx>100</posx>
                <posy>{{ vscale(48) }}</posy>
                <width>1740</width>
                <height>{{ vscale(322) }}</height>
                <onup>300</onup>
                <ondown>401</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                {% include "includes/role_card_layout.xml.tpl" with role_focus_id=400 %}
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="260" condition="false">
                    <control type="group">
                       <posx>55</posx>
                        <posy>{{ vscale(10) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>200</width>
                                <height>{{ vscale(200) }}</height>
                                <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
                            </control>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>200</width>
                                <height>{{ vscale(200) }}</height>
                                <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                                <aspectratio scalediffuse="false" aligny="top">scale</aspectratio>
                            </control>
                            <control type="group">
                                <posx>0</posx>
                                <posy>{{ vscale(209) }}</posy>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>200</width>
                                    <height>{{ vscale(32) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>FFFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>0</posx>
                                    <posy>{{ vscale(30) }}</posy>
                                    <width>200</width>
                                    <height>{{ vscale(32) }}</height>
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
                <focusedlayout width="260" condition="false">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(10) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="106" time="110" center="105,{{ vscale(105) }}" reversible="false">Focus</animation>
                            <animation effect="zoom" start="106" end="100" time="100" center="105,{{ vscale(105) }}" reversible="false">UnFocus</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(400)</visible>
                                <posx>-30</posx>
                                <posy>{{ vscale(-30) }}</posy>
                                <width>270</width>
                                <height>{{ vscale(270) }}</height>
                                <texture border="42">script.plex/buttons/role-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(400)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>210</width>
                                <height>{{ vscale(210) }}</height>
                                <texture>script.plex/circle-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>200</width>
                                    <height>{{ vscale(200) }}</height>
                                    <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
                                </control>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>200</width>
                                    <height>{{ vscale(200) }}</height>
                                    <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                                    <aspectratio scalediffuse="false" aligny="top">scale</aspectratio>
                                </control>
                                <control type="group">
                                    <posx>0</posx>
                                    <posy>{{ vscale(209) }}</posy>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>200</width>
                                        <height>{{ vscale(32) }}</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <textcolor>FFFFFFFF</textcolor>
                                        <label>$INFO[ListItem.Label]</label>
                                    </control>
                                    <control type="label">
                                        <scroll>false</scroll>
                                        <posx>0</posx>
                                        <posy>{{ vscale(30) }}</posy>
                                        <width>200</width>
                                        <height>{{ vscale(32) }}</height>
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
        <!-- /ROLES -->

        <!-- REVIEWS -->
        <control type="group" id="501">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),1)">Conditional</animation>
            <visible>Integer.IsGreater(Container(401).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>401</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(446) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$ADDON[script.plexmod 32953]</label>
            </control>
            <control type="list" id="401">
                <posx>100</posx>
                <posy>{{ vscale(36) }}</posy>
                <width>1740</width>
                <height>{{ vscale(410) }}</height>
                <onup>400</onup>
                <ondown>402</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="560">
                    <control type="group">
                        <posx>65</posx>
                        <posy>{{ vscale(66) }}</posy>
                        <control type="image">
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>520</width>
                            <height>{{ vscale(310) }}</height>
                            <texture>script.plex/review-rounded-surface.png</texture>
                            <colordiffuse>60000000</colordiffuse>
                        </control>
                        <control type="group">
                            <posx>20</posx>
                            <posy>{{ vscale(20) }}</posy>
                            <control type="group">
                                <posx>0</posx>
                                <posy>0</posy>
                                <control type="image">
                                    <posx>10</posx>
                                    <posy>{{ vscale(-5) }}</posy>
                                    <width>70</width>
                                    <height>{{ vscale(70) }}</height>
                                    <texture>script.plex/reviews/$INFO[ListItem.Thumb].png</texture>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>100</posx>
                                    <posy>0</posy>
                                    <width>400</width>
                                    <height>{{ vscale(30) }}</height>
                                    <font>font10</font>
                                    <align>left</align>
                                    <textcolor>DDFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>100</posx>
                                    <posy>{{ vscale(30) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(30) }}</height>
                                    <font>font10</font>
                                    <align>left</align>
                                    <textcolor>66FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="textbox">
                                <posx>0</posx>
                                <posy>{{ vscale(80) }}</posy>
                                <width>480</width>
                                <height>{{ vscale(190) }}</height>
                                <font>font10</font>
                                <align>left</align>
                                <textcolor>AAFFFFFF</textcolor>
                                <label>$INFO[ListItem.Property(text)]</label>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="560">
                    <control type="group">
                        <posx>60</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <animation effect="zoom" start="100" end="103" time="110" center="265,{{ vscale(160) }}" reversible="true" condition="Control.HasFocus(401)">Conditional</animation>
                        <control type="image">
                            <visible>Control.HasFocus(401)</visible>
                            <posx>0</posx>
                            <posy>0</posy>
                            <width>530</width>
                            <height>{{ vscale(320) }}</height>
                            <texture>script.plex/review-rounded-focus.png</texture>
                        </control>
                        <control type="image">
                            <posx>5</posx>
                            <posy>{{ vscale(5) }}</posy>
                            <width>520</width>
                            <height>{{ vscale(310) }}</height>
                            <texture>script.plex/review-rounded-surface.png</texture>
                            <colordiffuse>F01A1A1C</colordiffuse>
                        </control>
                        <control type="group">
                            <posx>25</posx>
                            <posy>{{ vscale(25) }}</posy>
                            <control type="group">
                                <posx>0</posx>
                                <posy>0</posy>
                                <control type="image">
                                    <posx>10</posx>
                                    <posy>{{ vscale(-5) }}</posy>
                                    <width>70</width>
                                    <height>{{ vscale(70) }}</height>
                                    <texture>script.plex/reviews/$INFO[ListItem.Thumb].png</texture>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>100</posx>
                                    <posy>0</posy>
                                    <width>400</width>
                                    <height>{{ vscale(30) }}</height>
                                    <font>font10</font>
                                    <align>left</align>
                                    <textcolor>DDFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <scroll>false</scroll>
                                    <posx>100</posx>
                                    <posy>{{ vscale(30) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(30) }}</height>
                                    <font>font10</font>
                                    <align>left</align>
                                    <textcolor>66FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="textbox">
                                <posx>0</posx>
                                <posy>{{ vscale(80) }}</posy>
                                <width>480</width>
                                <height>{{ vscale(190) }}</height>
                                <font>font10</font>
                                <align>left</align>
                                <textcolor>DDFFFFFF</textcolor>
                                <label>$INFO[ListItem.Property(text)]</label>
                                <scrolltime>0</scrolltime>
                                <autoscroll>false</autoscroll>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /REVIEWS -->

        <!-- EXTRAS -->
        <control type="group" id="502">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),2)">Conditional</animation>
            <visible>Integer.IsGreater(Container(402).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <height>{{ vscale(446) }}</height>
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
                <label>$ADDON[script.plexmod 32305]</label>
            </control>
            <control type="list" id="402">
                <posx>100</posx>
                <posy>{{ vscale(36) }}</posy>
                <width>1740</width>
                <height>{{ vscale(410) }}</height>
                <onup>401</onup>
                <ondown>403</ondown>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="420">
                    <control type="group">
                        <posx>65</posx>
                        <posy>{{ vscale(66) }}</posy>
                        <control type="group">
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>385</width>
                                <height>{{ vscale(217) }}</height>
                                <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                                <aspectratio>scale</aspectratio>
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
                                <visible>!String.IsEmpty(ListItem.Property(extra.duration.available))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>385</width>
                                <height>{{ vscale(217) }}</height>
                                <control type="image">
                                    <right>10</right>
                                    <bottom>10</bottom>
                                    <width>64</width>
                                    <height>26</height>
                                    <texture>script.plex/white-square-rounded.png</texture>
                                    <colordiffuse>99000000</colordiffuse>
                                </control>
                                <control type="label">
                                    <right>10</right>
                                    <bottom>10</bottom>
                                    <width>64</width>
                                    <height>26</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <aligny>center</aligny>
                                    <textcolor>FFEEEEEE</textcolor>
                                    <label>$INFO[ListItem.Property(extra.duration)]</label>
                                </control>
                            </control>
                            <control type="textbox">
                                <posx>0</posx>
                                <posy>{{ vscale(229) }}</posy>
                                <width>385</width>
                                <height>{{ vscale(60) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>385</width>
                                    <height>{{ vscale(217) }}</height>
                                    <texture diffuse="script.plex/landscape-hub-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                    <posx>162</posx>
                                    <posy>{{ vscale(58.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white.png</texture>
                                </control>
                                <control type="image">
                                    <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                    <posx>162</posx>
                                    <posy>{{ vscale(58.5) }}</posy>
                                    <width>61</width>
                                    <height>{{ vscale(100) }}</height>
                                    <texture colordiffuse="40000000">script.plex/indicators/chevron-white-l.png</texture>
                                </control>
                                <control type="image">
                                    <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                                    <posx>152.5</posx>
                                    <posy>{{ vscale(68.5) }}</posy>
                                    <width>80</width>
                                    <height>{{ vscale(80) }}</height>
                                    <texture>script.plex/home/busy.gif</texture>
                                </control>
                            </control>
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="420">
                    <control type="group">
                        <posx>60</posx>
                        <posy>{{ vscale(61) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="105" time="110" center="197.5,{{ vscale(113.5) }}" reversible="true" condition="Control.HasFocus(402)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(402)</visible>
                                <posx>-35</posx>
                                <posy>{{ vscale(-35) }}</posy>
                                <width>465</width>
                                <height>{{ vscale(297) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(402)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>395</width>
                                <height>{{ vscale(227) }}</height>
                                <texture>script.plex/landscape-hub-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>385</width>
                                    <height>{{ vscale(217) }}</height>
                                    <texture diffuse="script.plex/landscape-hub-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                                    <aspectratio>scale</aspectratio>
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
                                    <visible>!String.IsEmpty(ListItem.Property(extra.duration.available))</visible>
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>385</width>
                                    <height>{{ vscale(217) }}</height>
                                    <control type="image">
                                        <right>10</right>
                                        <bottom>10</bottom>
                                        <width>64</width>
                                        <height>26</height>
                                        <texture>script.plex/white-square-rounded.png</texture>
                                        <colordiffuse>99000000</colordiffuse>
                                    </control>
                                    <control type="label">
                                        <right>10</right>
                                        <bottom>10</bottom>
                                        <width>64</width>
                                        <height>26</height>
                                        <font>font10</font>
                                        <align>center</align>
                                        <aligny>center</aligny>
                                        <textcolor>FFEEEEEE</textcolor>
                                        <label>$INFO[ListItem.Property(extra.duration)]</label>
                                    </control>
                                </control>
                                <control type="textbox">
                                    <posx>0</posx>
                                    <posy>{{ vscale(229) }}</posy>
                                    <width>385</width>
                                    <height>{{ vscale(60) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>FFFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="group">
                                    <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                    <control type="image">
                                        <posx>0</posx>
                                        <posy>0</posy>
                                        <width>385</width>
                                        <height>{{ vscale(217) }}</height>
                                        <texture diffuse="script.plex/landscape-hub-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(right.boundary))</visible>
                                        <posx>162</posx>
                                        <posy>{{ vscale(58.5) }}</posy>
                                        <width>61</width>
                                        <height>{{ vscale(100) }}</height>
                                        <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>String.IsEmpty(ListItem.Property(is.updating)) + !String.IsEmpty(ListItem.Property(left.boundary))</visible>
                                        <posx>162</posx>
                                        <posy>{{ vscale(58.5) }}</posy>
                                        <width>61</width>
                                        <height>{{ vscale(100) }}</height>
                                        <texture colordiffuse="66FFFFFF">script.plex/indicators/chevron-white-l.png</texture>
                                    </control>
                                    <control type="image">
                                        <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                                        <posx>152.5</posx>
                                        <posy>{{ vscale(68.5) }}</posy>
                                        <width>80</width>
                                        <height>{{ vscale(80) }}</height>
                                        <texture>script.plex/home/busy.gif</texture>
                                    </control>
                                </control>
                            </control>
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /EXTRAS -->

        <!-- RELATED -->
        <control type="group" id="503">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),3)">Conditional</animation>
            <visible>Integer.IsGreater(Container(403).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>403</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(555) }}</height>
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
            <control type="list" id="403">
                <posx>100</posx>
                <posy>{{ vscale(16) }}</posy>
                <width>1740</width>
                <height>{{ vscale(555) }}</height>
                <onup>402</onup>
                <ondown>404</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <!-- ITEM LAYOUT ########################################## -->
                <itemlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
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
                            <control type="label">
                                <scroll>false</scroll>
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(398) }}</posy>
                                <width>244</width>
                                <height>{{ vscale(35) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>99FFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </itemlayout>

                <!-- FOCUSED LAYOUT ####################################### -->
                <focusedlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180.5) }}" reversible="true" condition="Control.HasFocus(403)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(403)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>324</width>
                                <height>{{ vscale(441) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(403)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(371) }}</height>
                                <texture>script.plex/poster-home-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
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
                                <control type="label">
                                    <scroll>false</scroll>
                                    <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(398) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>99FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /RELATED -->

        <!-- COLLECTION HUB 0 -->
        <control type="group" id="504">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),4)">Conditional</animation>
            <visible>Integer.IsGreater(Container(404).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>404</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(555) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(collection.header.0)]</label>
            </control>
            <control type="list" id="404">
                <posx>100</posx>
                <posy>{{ vscale(16) }}</posy>
                <width>1740</width>
                <height>{{ vscale(555) }}</height>
                <onup>403</onup>
                <ondown>405</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <itemlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
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
                            <control type="label">
                                <scroll>false</scroll>
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(398) }}</posy>
                                <width>244</width>
                                <height>{{ vscale(35) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>99FFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </itemlayout>
                <focusedlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180.5) }}" reversible="true" condition="Control.HasFocus(404)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
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
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(371) }}</height>
                                <texture>script.plex/poster-home-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
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
                                <control type="label">
                                    <scroll>false</scroll>
                                    <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(398) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>99FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /COLLECTION HUB 0 -->

        <!-- COLLECTION HUB 1 -->
        <control type="group" id="505">
            <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),5)">Conditional</animation>
            <visible>Integer.IsGreater(Container(405).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>405</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(555) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(collection.header.1)]</label>
            </control>
            <control type="list" id="405">
                <posx>100</posx>
                <posy>{{ vscale(16) }}</posy>
                <width>1740</width>
                <height>{{ vscale(555) }}</height>
                <onup>404</onup>
                <ondown>406</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <itemlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
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
                            <control type="label">
                                <scroll>false</scroll>
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(398) }}</posy>
                                <width>244</width>
                                <height>{{ vscale(35) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>99FFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </itemlayout>
                <focusedlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180.5) }}" reversible="true" condition="Control.HasFocus(405)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(405)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>324</width>
                                <height>{{ vscale(441) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(405)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(371) }}</height>
                                <texture>script.plex/poster-home-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
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
                                <control type="label">
                                    <scroll>false</scroll>
                                    <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(398) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>99FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /COLLECTION HUB 1 -->

        <!-- COLLECTION HUB 2 -->
        <control type="group" id="506">
            <visible>Integer.IsGreater(Container(406).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
            <defaultcontrol>406</defaultcontrol>
            <width>1920</width>
            <height>{{ vscale(555) }}</height>
            <control type="label">
                <posx>160</posx>
                <posy>0</posy>
                <width>1000</width>
                <height>{{ vscale(48) }}</height>
                <font>font30_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(collection.header.2)]</label>
            </control>
            <control type="list" id="406">
                <posx>100</posx>
                <posy>{{ vscale(16) }}</posy>
                <width>1740</width>
                <height>{{ vscale(555) }}</height>
                <onup>405</onup>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <scrolltime>200</scrolltime>
                <orientation>horizontal</orientation>
                <preloaditems>4</preloaditems>
                <itemlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <posx>5</posx>
                            <posy>5</posy>
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
                            <control type="label">
                                <scroll>false</scroll>
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <posx>0</posx>
                                <posy>{{ vscale(398) }}</posy>
                                <width>244</width>
                                <height>{{ vscale(35) }}</height>
                                <font>font10</font>
                                <align>center</align>
                                <textcolor>99FFFFFF</textcolor>
                                <label>$INFO[ListItem.Label2]</label>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </itemlayout>
                <focusedlayout width="287">
                    <control type="group">
                        <posx>55</posx>
                        <posy>{{ vscale(72) }}</posy>
                        <control type="group">
                            <animation effect="zoom" start="100" end="105" time="110" center="127,{{ vscale(180.5) }}" reversible="true" condition="Control.HasFocus(406)">Conditional</animation>
                            <posx>0</posx>
                            <posy>0</posy>
                            <control type="image">
                                <visible>Control.HasFocus(406)</visible>
                                <posx>-40</posx>
                                <posy>{{ vscale(-40) }}</posy>
                                <width>324</width>
                                <height>{{ vscale(441) }}</height>
                                <texture border="42">script.plex/drop-shadow.png</texture>
                            </control>
                            <control type="image">
                                <visible>Control.HasFocus(406)</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>254</width>
                                <height>{{ vscale(371) }}</height>
                                <texture>script.plex/poster-home-rounded-focus.png</texture>
                            </control>
                            <control type="group">
                                <posx>5</posx>
                                <posy>5</posy>
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
                                <control type="label">
                                    <scroll>false</scroll>
                                    <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                    <posx>0</posx>
                                    <posy>{{ vscale(398) }}</posy>
                                    <width>244</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font10</font>
                                    <align>center</align>
                                    <textcolor>99FFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                                <control type="image">
                                    <posx>0</posx>
                                    <posy>0</posy>
                                    <width>244</width>
                                    <height>{{ vscale(361) }}</height>
                                    <texture diffuse="script.plex/poster-home-rounded-mask.png" colordiffuse="DD202020">script.plex/white-square.png</texture>
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
                        </control>
                    </control>
                </focusedlayout>
            </control>
        </control>
        <!-- /COLLECTION HUB 2 -->
    </control>
</control>
{% endblock content %}
