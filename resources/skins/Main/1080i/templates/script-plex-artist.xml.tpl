{% extends "default.xml.tpl" %}
{% block headers %}<defaultcontrol>302</defaultcontrol>{% endblock %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(artist.background.blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture background="true">$INFO[Window.Property(artist.background.blurred)]</texture>
    <aspectratio>scale</aspectratio>
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
    <texture colordiffuse="66000000">script.plex/white-square.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <animation effect="slide" end="0,{{ vscale(-390) }}" time="220" tween="quadratic" easing="out" condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>
    <posx>0</posx>
    <posy>{{ vscale(135) }}</posy>
    <width>1920</width>
    <height>{{ vscale(1335) }}</height>
    <defaultcontrol>302</defaultcontrol>

    <control type="group">
        <animation effect="fade" start="100" end="0" time="140" condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>
        <posx>160</posx>
        <posy>{{ vscale(10) }}</posy>
        <width>360</width>
        <height>{{ vscale(360) }}</height>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>360</width>
            <height>{{ vscale(360) }}</height>
            <texture diffuse="script.plex/masks/role.png">script.plex/thumb_fallbacks/role.png</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>360</width>
            <height>{{ vscale(360) }}</height>
            <texture background="true" diffuse="script.plex/masks/role.png">$INFO[Window.Property(thumb)]</texture>
            <aspectratio>scale</aspectratio>
        </control>
        <control type="image">
            <posx>-5</posx>
            <posy>{{ vscale(-5) }}</posy>
            <width>370</width>
            <height>{{ vscale(370) }}</height>
            <texture colordiffuse="66FFFFFF">script.plex/circle-rounded-outline.png</texture>
        </control>
    </control>

    <control type="group">
        <animation effect="fade" start="100" end="0" time="140" condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>
        <posx>580</posx>
        <posy>0</posy>
        <width>1180</width>
        <height>{{ vscale(410) }}</height>
        <control type="label">
            <posx>0</posx>
            <posy>0</posy>
            <width>1180</width>
            <height>{{ vscale(72) }}</height>
            <font>font60</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(artist.title)]</label>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(78) }}</posy>
            <width>1180</width>
            <height>{{ vscale(38) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>B8FFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(artist.genre)]</label>
        </control>
        <control type="textbox">
            <posx>0</posx>
            <posy>{{ vscale(135) }}</posy>
            <width>1120</width>
            <height>{{ vscale(110) }}</height>
            <font>font13</font>
            <align>left</align>
            <textcolor>E8FFFFFF</textcolor>
            <autoscroll>false</autoscroll>
            <label>$INFO[Window.Property(summary.short)]</label>
        </control>

        <control type="grouplist" id="300">
            <defaultcontrol always="true">302</defaultcontrol>
            <posx>0</posx>
            <posy>{{ vscale(275) }}</posy>
            <width>520</width>
            <height>{{ vscale(90) }}</height>
            <onup>200</onup>
            <ondown>400</ondown>
            <itemgap>14</itemgap>
            <orientation>horizontal</orientation>
            <align>left</align>
            <scrolltime>160</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            {% with template = "includes/themed_button.xml.tpl" & music_artist_style = True %}
                {% include template with name="play" & id=302 %}
                {% include template with name="info" & id=301 %}
                {% include template with name="shuffle" & id=303 %}
                {% include template with name="more" & id=304 %}
            {% endwith %}
        </control>
    </control>

    <control type="group" id="100">
        <animation effect="fade" start="100" end="0" time="140" condition="String.IsEqual(Window.Property(hub.focus),1)">Conditional</animation>
        <visible>Integer.IsGreater(Container(400).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>400</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(440) }}</posy>
        <width>1920</width>
        <height>{{ vscale(390) }}</height>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>600</width>
            <height>{{ vscale(48) }}</height>
            <font>font30_title</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$LOCALIZE[132]</label>
        </control>
        <control type="list" id="400">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1740</width>
            <height>{{ vscale(320) }}</height>
            <onup>300</onup>
            <ondown condition="Control.IsVisible(401)">401</ondown>
            <ondown condition="!Control.IsVisible(401)">400</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>2</preloaditems>
            <itemlayout width="280">
                <control type="group">
                    <posx>60</posx>
                    <posy>{{ vscale(12) }}</posy>
                    <control type="image">
                        <width>220</width>
                        <height>{{ vscale(220) }}</height>
                        <texture diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                    <control type="image">
                        <width>220</width>
                        <height>{{ vscale(220) }}</height>
                        <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                    <control type="label">
                        <posy>{{ vscale(230) }}</posy>
                        <width>220</width>
                        <height>{{ vscale(34) }}</height>
                        <font>font12</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFFFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                    <control type="label">
                        <posy>{{ vscale(264) }}</posy>
                        <width>220</width>
                        <height>{{ vscale(28) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(year)]</label>
                    </control>
                </control>
            </itemlayout>
            <focusedlayout width="280">
                <control type="group">
                    <posx>60</posx>
                    <posy>{{ vscale(12) }}</posy>
                    <animation effect="zoom" start="100" end="105" time="110" center="110,{{ vscale(110) }}" reversible="true" condition="Control.HasFocus(400)">Conditional</animation>
                    <control type="image">
                        <visible>Control.HasFocus(400)</visible>
                        <posx>-4</posx>
                        <posy>{{ vscale(-4) }}</posy>
                        <width>228</width>
                        <height>{{ vscale(228) }}</height>
                        <texture>script.plex/square-rounded-focus.png</texture>
                    </control>
                    <control type="image">
                        <width>220</width>
                        <height>{{ vscale(220) }}</height>
                        <texture diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                    <control type="image">
                        <width>220</width>
                        <height>{{ vscale(220) }}</height>
                        <texture background="true" diffuse="script.plex/square-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                    <control type="label">
                        <posy>{{ vscale(230) }}</posy>
                        <width>220</width>
                        <height>{{ vscale(34) }}</height>
                        <font>font12</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFFFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                    <control type="label">
                        <posy>{{ vscale(264) }}</posy>
                        <width>220</width>
                        <height>{{ vscale(28) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>99FFFFFF</textcolor>
                        <label>$INFO[ListItem.Property(year)]</label>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>

    <control type="group" id="500">
        <visible>Integer.IsGreater(Container(401).NumItems,0) + String.IsEmpty(Window.Property(drawing))</visible>
        <defaultcontrol>401</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(850) }}</posy>
        <width>1920</width>
        <height>{{ vscale(390) }}</height>
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
        <control type="list" id="401">
            <posx>100</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>1740</width>
            <height>{{ vscale(320) }}</height>
            <onup>400</onup>
            <ondown>401</ondown>
            <scrolltime>180</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>3</preloaditems>
            <itemlayout width="240">
                <control type="group">
                    <posx>60</posx>
                    <posy>{{ vscale(12) }}</posy>
                    <control type="group">
                        <visible>String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture diffuse="script.plex/masks/role.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                    </control>
                    <control type="group">
                        <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture colordiffuse="77222222" diffuse="script.plex/masks/role.png">script.plex/white-square.png</texture>
                        </control>
                        <control type="image">
                            <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                            <posx>60</posx>
                            <posy>{{ vscale(60) }}</posy>
                            <width>80</width>
                            <height>{{ vscale(80) }}</height>
                            <texture>script.plex/home/busy.gif</texture>
                        </control>
                    </control>
                    <control type="label">
                        <visible>String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <posy>{{ vscale(210) }}</posy>
                        <width>200</width>
                        <height>{{ vscale(40) }}</height>
                        <font>font12</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFFFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                </control>
            </itemlayout>
            <focusedlayout width="240">
                <control type="group">
                    <posx>60</posx>
                    <posy>{{ vscale(12) }}</posy>
                    <animation effect="zoom" start="100" end="105" time="110" center="100,{{ vscale(100) }}" reversible="true" condition="Control.HasFocus(401)">Conditional</animation>
                    <control type="group">
                        <visible>String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <control type="image">
                            <visible>Control.HasFocus(401)</visible>
                            <posx>-4</posx>
                            <posy>{{ vscale(-4) }}</posy>
                            <width>208</width>
                            <height>{{ vscale(208) }}</height>
                            <texture>script.plex/circle-rounded-focus.png</texture>
                        </control>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture diffuse="script.plex/masks/role.png">$INFO[ListItem.Property(thumb.fallback)]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture background="true" diffuse="script.plex/masks/role.png">$INFO[ListItem.Thumb]</texture>
                            <aspectratio>scale</aspectratio>
                        </control>
                    </control>
                    <control type="group">
                        <visible>!String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <control type="image">
                            <width>200</width>
                            <height>{{ vscale(200) }}</height>
                            <texture colordiffuse="77222222" diffuse="script.plex/masks/role.png">script.plex/white-square.png</texture>
                        </control>
                        <control type="image">
                            <visible>!String.IsEmpty(ListItem.Property(is.updating))</visible>
                            <posx>60</posx>
                            <posy>{{ vscale(60) }}</posy>
                            <width>80</width>
                            <height>{{ vscale(80) }}</height>
                            <texture>script.plex/home/busy.gif</texture>
                        </control>
                    </control>
                    <control type="label">
                        <visible>String.IsEmpty(ListItem.Property(is.boundary))</visible>
                        <posy>{{ vscale(210) }}</posy>
                        <width>200</width>
                        <height>{{ vscale(40) }}</height>
                        <font>font12</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFFFFFFF</textcolor>
                        <scroll>false</scroll>
                        <label>$INFO[ListItem.Label]</label>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>
</control>
{% endblock content %}
