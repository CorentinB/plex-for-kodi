{% extends "default.xml.tpl" %}
{% block background %}
{% include "includes/default_background.xml.tpl" %}
<control type="image">
    <visible>!String.IsEmpty(Window.Property(home.hero.art_blurred))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <fadetime>450</fadetime>
    <texture background="true">$INFO[Window.Property(home.hero.art_blurred)]</texture>
    {% include "includes/scale_background.xml.tpl" %}
</control>
<control type="image">
    <visible>!String.IsEmpty(Window.Property(home.hero.art)) + String.IsEmpty(Window.Property(hub.scrolled))</visible>
    <posx>640</posx>
    <posy>0</posy>
    <width>1280</width>
    <height>720</height>
    <fadetime>450</fadetime>
    <texture background="true" diffuse="script.plex/home/tvos-first-row-art-mask.png">$INFO[Window.Property(home.hero.art)]</texture>
    <aspectratio align="right" aligny="top">keep</aspectratio>
</control>
<control type="image">
    <visible>String.IsEmpty(Window.Property(hub.scrolled))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="D8FFFFFF">script.plex/home/tvos-background-wash.png</texture>
</control>
<control type="image">
    <visible>!String.IsEmpty(Window.Property(hub.scrolled))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture>script.plex/home/tvos-background-wash.png</texture>
</control>
{% endblock background %}

{% block content %}
<control type="group" id="50">
    <!-- Keep the first hub in the hero composition. From the second hub onward,
         position the focused row deterministically. Rows above the focused hub
         fade away so the fixed hero can retain its artwork without a solid mask. -->
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + Control.IsVisible(500)" reversible="true">
        <effect type="slide" end="0,{{ vscale(-622) }}" time="240" tween="quadratic" easing="out"/>
    </animation>
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + !String.IsEmpty(Window.Property(home.resume.visible))" reversible="true">
        <effect type="slide" end="0,{{ vscale(-622) }}" time="240" tween="quadratic" easing="out"/>
    </animation>

    {% for i in range(1, core.hub_count) %}
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),{{ i }}) + Control.IsVisible({{ i + 500 }})" reversible="true">
        <effect type="slide" end="0,{{ vscale(-475) }}" time="240" tween="quadratic" easing="out"/>
    </animation>
    {% endfor %}

    <!-- Shorter artwork shapes reduce the physical row step. Counter that
         compaction while scrolling so every focused lower hub still lands on
         the same fixed hero baseline. -->
    {% for i in range(1, core.hub_count) %}
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),{{ i - 1 }}) + Control.IsVisible({{ i + 499 }}) + String.IsEqual(Window.Property(hub.display.{{ i + 399 }}),ar16x9)" reversible="true">
        <effect type="slide" end="0,{{ vscale(125) }}" time="240" tween="quadratic" easing="out"/>
    </animation>
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),{{ i - 1 }}) + Control.IsVisible({{ i + 499 }}) + String.IsEqual(Window.Property(hub.display.{{ i + 399 }}),square)" reversible="true">
        <effect type="slide" end="0,{{ vscale(105) }}" time="240" tween="quadratic" easing="out"/>
    </animation>
    {% endfor %}
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + !String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEqual(Window.Property(hub.display.400),ar16x9)" reversible="true">
        <effect type="slide" end="0,{{ vscale(125) }}" time="240" tween="quadratic" easing="out"/>
    </animation>
    <animation type="Conditional" condition="Integer.IsGreater(Window.Property(hub.focus),0) + !String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEqual(Window.Property(hub.display.400),square)" reversible="true">
        <effect type="slide" end="0,{{ vscale(105) }}" time="240" tween="quadratic" easing="out"/>
    </animation>

    <defaultcontrol>101</defaultcontrol>
    <posx>0</posx>
    <posy>{{ vscale(28) }}</posy>
    <width>1920</width>
    {% with n = core.hub_count %}{% with grouplist_height = n * 475 + 407 %}
    <height>{{ vscale(grouplist_height) }}</height>
    {% endwith %}{% endwith %}
    <control type="group" id="100">
        <width>1920</width>
        <height>{{ vscale(335) }}</height>
        <control type="group">
            <posx>34</posx>
            <posy>{{ vscale(20) }}</posy>
            <width>58</width>
            <height>{{ vscale(300) }}</height>
            <control type="image">
                <posx>0</posx>
                <posy>0</posy>
                <width>58</width>
                <height>{{ vscale(58) }}</height>
                <texture diffuse="script.plex/home/avatar-diffuse.png" fallback="script.plex/gray-square.png">$INFO[Window.Property(user.avatar)]</texture>
            </control>
            <control type="button" id="202">
                <animation effect="zoom" start="100" end="106" time="110" center="29,{{ vscale(29) }}" reversible="true" condition="Control.HasFocus(202)">Conditional</animation>
                <posx>-5</posx>
                <posy>{{ vscale(-5) }}</posy>
                <width>68</width>
                <height>{{ vscale(68) }}</height>
                <onright>101</onright>
                <ondown>203</ondown>
                <texturefocus>script.plex/circle-rounded-outline.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <label> </label>
            </control>
            <control type="button" id="203">
                <visible>String.IsEmpty(Window.Property(search.dialog))</visible>
                <animation effect="zoom" start="100" end="106" time="110" center="29,{{ vscale(132) }}" reversible="true" condition="Control.HasFocus(203)">Conditional</animation>
                <posx>9</posx>
                <posy>{{ vscale(112) }}</posy>
                <width>40</width>
                <height>{{ vscale(40) }}</height>
                <onup>202</onup>
                <onright condition="Control.IsVisible(204)">204</onright>
                <onright condition="!Control.IsVisible(204)">101</onright>
                <ondown condition="!String.IsEmpty(Window.Property(home.resume.visible))">205</ondown>
                <ondown condition="String.IsEmpty(Window.Property(home.resume.visible))">400</ondown>
                <font>font12</font>
                <focusedcolor>FF111111</focusedcolor>
                <texturefocus colordiffuse="FFFFFFFF">script.plex/buttons/search-focus.png</texturefocus>
                <texturenofocus colordiffuse="BFFFFFFF">script.plex/buttons/search.png</texturenofocus>
                <label> </label>
            </control>
            <control type="group" id="8901">
                <visible>false</visible>
                <posx>76</posx>
                <posy>{{ vscale(78) }}</posy>
                <width>340</width>
                <height>{{ vscale(500) }}</height>
                <control type="image" id="8801">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>340</width>
                    <height>{{ vscale(500) }}</height>
                    <texture colordiffuse="FF0D0D0D" border="28">script.plex/white-square-rounded.png</texture>
                </control>
                <control type="list" id="8250">
                    <posx>20</posx>
                    <posy>{{ vscale(20) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(460) }}</height>
                    <onleft>202</onleft>
                    <onright>101</onright>
                    <onunfocus>SetProperty(show.options,)</onunfocus>
                    <scrolltime>160</scrolltime>
                    <orientation>vertical</orientation>
                    <itemlayout height="{{ vscale(66) }}">
                        <control type="label">
                            <posx>22</posx>
                            <posy>0</posy>
                            <width>256</width>
                            <height>{{ vscale(60) }}</height>
                            <font>font10</font>
                            <align>left</align>
                            <aligny>center</aligny>
                            <textcolor>DDFFFFFF</textcolor>
                            <scroll>false</scroll>
                            <label>$INFO[ListItem.Label]</label>
                        </control>
                    </itemlayout>
                    <focusedlayout height="{{ vscale(66) }}">
                        <control type="image">
                            <posx>0</posx>
                            <posy>{{ vscale(2) }}</posy>
                            <width>300</width>
                            <height>{{ vscale(56) }}</height>
                            <texture colordiffuse="FFFFFFFF" border="20">script.plex/white-square-rounded.png</texture>
                        </control>
                        <control type="label">
                            <posx>22</posx>
                            <posy>0</posy>
                            <width>256</width>
                            <height>{{ vscale(60) }}</height>
                            <font>font10</font>
                            <align>left</align>
                            <aligny>center</aligny>
                            <textcolor>FF000000</textcolor>
                            <scroll>false</scroll>
                            <label>$INFO[ListItem.Label]</label>
                        </control>
                    </focusedlayout>
                </control>
            </control>
        </control>
        <control type="fixedlist" id="101">
            <posx>160</posx>
            <posy>{{ vscale(6) }}</posy>
            <width>960</width>
            <height>{{ vscale(86) }}</height>
            <onup>203</onup>
            <ondown condition="!String.IsEmpty(Window.Property(home.resume.visible))">205</ondown>
            <ondown condition="String.IsEmpty(Window.Property(home.resume.visible))">400</ondown>
            <scrolltime>200</scrolltime>
            <orientation>horizontal</orientation>
            <focusposition>1</focusposition>
            <movement>1</movement>
            <pagecontrol>102</pagecontrol>
            <!-- ITEM LAYOUT ########################################## -->
            <itemlayout width="192">
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(item))</visible>
                    {% include "includes/home_nav_shift.xml.tpl" %}
                    <posx>0</posx>
                    <posy>{{ vscale(16) }}</posy>
                    <width>410</width>
                    <height>{{ vscale(60) }}</height>
                    {% with nav_color = "DDFFFFFF" & nav_icon_color = "BBFFFFFF" & nav_scroll = "false" %}
                    {% include "includes/home_nav_content.xml.tpl" %}
                    {% endwith %}
                </control>
            </itemlayout>

            <!-- FOCUSED LAYOUT ####################################### -->
            <focusedlayout width="192">
                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(item))</visible>
                    {% include "includes/home_nav_shift.xml.tpl" %}
                    <posx>0</posx>
                    <posy>{{ vscale(16) }}</posy>
                    <control type="group">
                        <animation effect="zoom" start="100" end="106" time="110" center="0,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="70,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.60)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="80,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.80)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="90,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.100)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="100,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.120)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="110,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.140)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="130,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.180)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="150,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.220)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="170,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.260)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <animation effect="zoom" start="100" end="106" time="110" center="200,{{ vscale(30) }}" reversible="true" condition="Control.HasFocus(101) + !String.IsEmpty(ListItem.Property(nav.width.320)) + String.IsEmpty(ListItem.Property(is.home))">Conditional</animation>
                        <posx>0</posx>
                        <posy>0</posy>
                        {% include "includes/home_nav_focus_plate.xml.tpl" %}
                        {% with nav_color = "FF111111" & nav_icon_color = "FF111111" & nav_scroll = "false" %}
                        {% include "includes/home_nav_content.xml.tpl" %}
                        {% endwith %}
                    </control>
                </control>
            </focusedlayout>
        </control>
        <control type="group">
            <visible>!String.IsEmpty(Window.Property(home.hero.visible)) + String.IsEmpty(Window.Property(hub.scrolled))</visible>
            <posx>160</posx>
            <posy>{{ vscale(142) }}</posy>
            <width>1120</width>
            <height>{{ vscale(340) }}</height>
            <control type="label">
                <visible>String.IsEmpty(Window.Property(home.hero.logo))</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>1120</width>
                <height>{{ vscale(72) }}</height>
                <font>font45_title</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(home.hero.title)]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Window.Property(home.hero.logo))</visible>
                <posx>0</posx>
                <posy>{{ vscale(-30) }}</posy>
                <width>700</width>
                <height>{{ vscale(112) }}</height>
                <texture background="true">$INFO[Window.Property(home.hero.logo)]</texture>
                <aspectratio align="left" aligny="center">keep</aspectratio>
            </control>
            <control type="label">
                <animation effect="slide" end="0,{{ vscale(28) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
                <scroll>false</scroll>
                <visible>!String.IsEmpty(Window.Property(home.hero.subtitle))</visible>
                <posx>0</posx>
                <posy>{{ vscale(82) }}</posy>
                <width>880</width>
                <height>{{ vscale(34) }}</height>
                <font>font13</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>F2FFFFFF</textcolor>
                <label>$INFO[Window.Property(home.hero.subtitle)]</label>
            </control>
            {% with hero_meta_y = 126 & hero_meta_height = 32 & hero_meta_empty_shift = -44 & hero_logo_shift = 28 %}
            {% include "includes/home_hero_metadata.xml.tpl" %}
            {% endwith %}
            <control type="textbox">
                <animation effect="slide" end="0,{{ vscale(-44) }}" time="0" condition="String.IsEmpty(Window.Property(home.hero.subtitle))" reversible="true">Conditional</animation>
                <animation effect="slide" end="0,{{ vscale(28) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
                <autoscroll>false</autoscroll>
                <visible>!String.IsEmpty(Window.Property(home.hero.short_summary))</visible>
                <posx>0</posx>
                <posy>{{ vscale(168) }}</posy>
                <width>920</width>
                <height>{{ vscale(90) }}</height>
                <font>font10</font>
                <textcolor>F0FFFFFF</textcolor>
                <label>$INFO[Window.Property(home.hero.short_summary)]</label>
            </control>
        </control>
        <!-- Keep the action focusable while the full hero is hidden during row browsing. -->
        <control type="group" id="206">
            <visible>!String.IsEmpty(Window.Property(home.resume.visible))</visible>
            <animation effect="fade" start="100" end="0" time="0" condition="!String.IsEmpty(Window.Property(hub.scrolled))" reversible="true">Conditional</animation>
            <animation effect="slide" end="0,{{ vscale(-44) }}" time="0" condition="String.IsEmpty(Window.Property(home.hero.subtitle))" reversible="true">Conditional</animation>
            <animation effect="slide" end="0,{{ vscale(28) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
            <animation effect="slide" end="0,{{ vscale(-60) }}" time="0" condition="String.IsEmpty(Window.Property(home.hero.short_summary))" reversible="true">Conditional</animation>
            <animation effect="zoom" start="100" end="106" time="110" center="130,{{ vscale(29) }}" reversible="true" condition="Control.HasFocus(205)">Conditional</animation>
            <posx>160</posx>
            <posy>{{ vscale(376) }}</posy>
            <width>260</width>
            <height>{{ vscale(58) }}</height>
            <control type="button" id="205">
                <posx>0</posx>
                <posy>0</posy>
                <width>260</width>
                <height>{{ vscale(58) }}</height>
                <onup>101</onup>
                <ondown>401</ondown>
                <onleft>noop</onleft>
                <onright>noop</onright>
                <font>font12</font>
                <textcolor>FF111111</textcolor>
                <focusedcolor>FF111111</focusedcolor>
                <align>left</align>
                <aligny>center</aligny>
                <texturefocus colordiffuse="FFFFFFFF" border="20">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus colordiffuse="FFFFFFFF" border="20">script.plex/white-square-rounded.png</texturenofocus>
                <textoffsetx>60</textoffsetx>
                <label>$ADDON[script.plexmod 32316]</label>
            </control>
            <control type="image">
                <posx>18</posx>
                <posy>{{ vscale(15) }}</posy>
                <width>28</width>
                <height>{{ vscale(28) }}</height>
                <texture colordiffuse="FF111111">script.plex/circle-rounded-focus.png</texture>
            </control>
            <control type="image">
                <posx>4</posx>
                <posy>{{ vscale(6) }}</posy>
                <width>56</width>
                <height>{{ vscale(45) }}</height>
                <texture colordiffuse="FFFFFFFF">script.plex/buttons/player/modern/play.png</texture>
                <aspectratio>keep</aspectratio>
            </control>
        </control>
    </control>

    <!-- DYNAMIC HUB ROWS - Generated from hub_count setting -->
    {% for i in range(core.hub_count) %}
    {% with group_id = i + 500 & hub_id = i + 400 & row_y = i * 475 + 407 %}
    <control type="group" id="{{ group_id }}">
        <animation effect="slide" end="0,{{ vscale(36) }}" time="0" condition="String.IsEmpty(Window.Property(hub.scrolled)) + !String.IsEmpty(Window.Property(home.hero.logo)) + !String.IsEmpty(Window.Property(home.hero.subtitle)) + !String.IsEmpty(Window.Property(home.hero.short_summary))" reversible="true">Conditional</animation>
        {% for previous_i in range(i) %}
        <animation effect="slide" end="0,{{ vscale(-125) }}" time="0" condition="String.IsEqual(Window.Property(hub.display.{{ previous_i + 400 }}),ar16x9)" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-105) }}" time="0" condition="String.IsEqual(Window.Property(hub.display.{{ previous_i + 400 }}),square)" reversible="true">Conditional</animation>
        {% endfor %}
        {% if i > 0 %}
        <animation effect="slide" end="0,{{ vscale(-410) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEqual(Window.Property(hub.display.400),poster)" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-305) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEqual(Window.Property(hub.display.400),square)" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-285) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEqual(Window.Property(hub.display.400),ar16x9)" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-47) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEmpty(Window.Property(home.hero.short_summary))" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-52) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEmpty(Window.Property(home.hero.logo)) + String.IsEmpty(Window.Property(home.hero.subtitle)) + String.IsEmpty(Window.Property(home.hero.short_summary))" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(-36) }}" time="0" condition="!String.IsEmpty(Window.Property(home.resume.visible)) + String.IsEmpty(Window.Property(hub.scrolled)) + String.IsEmpty(Window.Property(home.hero.logo)) + String.IsEmpty(Window.Property(home.hero.subtitle)) + !String.IsEmpty(Window.Property(home.hero.short_summary))" reversible="true">Conditional</animation>
        {% endif %}
        <animation effect="fade" start="100" end="0" time="140" condition="Integer.IsGreater(Window.Property(hub.focus),{{ i }})">Conditional</animation>
        <visible>Integer.IsGreater(Container({{ hub_id }}).NumItems,0) + String.IsEmpty(Window.Property(drawing)){% if loop.is_first %} + String.IsEmpty(Window.Property(home.resume.visible)){% endif %}</visible>
        <defaultcontrol>{{ hub_id }}</defaultcontrol>
        <posx>0</posx>
        <posy>{{ vscale(row_y) }}</posy>
        <width>1920</width>
        <height>{{ vscale(475) }}</height>
        <control type="image">
            <visible>!String.IsEmpty(Window.Property(bifurcation_lines))</visible>
            <posx>160</posx>
            <posy>{{ vscale(12) }}</posy>
            <width>1680</width>
            <height>{{ vscale(2) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>50000000</colordiffuse>
        </control>
        <control type="label">
            <posx>160</posx>
            <posy>0</posy>
            <width>1680</width>
            <height>{{ vscale(46) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(hub.{{ hub_id }})]</label>
        </control>
        <control type="list" id="{{ hub_id }}">
            <posx>100</posx>
            <posy>{{ vscale(42) }}</posy>
            <width>1740</width>
            <height>{{ vscale(435) }}</height>
            {% if loop.is_first %}
            <onup>101</onup>
            {% elif i == 1 %}
            <onup condition="!String.IsEmpty(Window.Property(home.resume.visible))">205</onup>
            <onup condition="String.IsEmpty(Window.Property(home.resume.visible))">400</onup>
            {% else %}
            <onup>{{ hub_id - 1 }}</onup>
            {% endif %}
            <ondown>{% if loop.is_last %}{{ hub_id }}{% else %}{{ hub_id + 1 }}{% endif %}</ondown>
            <onright>noop</onright>
            <onleft>noop</onleft>
            <scrolltime>200</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>4</preloaditems>

            <!-- Conditional item layouts - Kodi selects layout based on condition attribute -->
            {% include "includes/hub_itemlayout_poster.xml.tpl" %}
            {% include "includes/hub_itemlayout_square.xml.tpl" %}
            {% include "includes/hub_itemlayout_ar16x9.xml.tpl" %}
            <!-- Conditional focused layouts - Kodi selects layout based on condition attribute -->
            {% include "includes/hub_focusedlayout_poster.xml.tpl" %}
            {% include "includes/hub_focusedlayout_square.xml.tpl" %}
            {% include "includes/hub_focusedlayout_ar16x9.xml.tpl" %}
        </control>
    </control>
    {% endwith %}
    {% endfor %}

    <control type="label">
        <!-- DUMMY -->
        <width>1920</width>
        <height>{{ vscale(100) }}</height>
        <font>font12</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>00FFFFFF</textcolor>
        <label> </label>
    </control>
</control>
<control type="group">
    <visible>!String.IsEmpty(Window.Property(home.hero.visible)) + !String.IsEmpty(Window.Property(hub.scrolled))</visible>
    <posx>160</posx>
    <posy>{{ vscale(48) }}</posy>
    <width>1120</width>
    <height>{{ vscale(260) }}</height>
    <control type="label">
        <visible>String.IsEmpty(Window.Property(home.hero.logo))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>1120</width>
        <height>{{ vscale(58) }}</height>
        <font>font40_title</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$INFO[Window.Property(home.hero.title)]</label>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(home.hero.logo))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>620</width>
        <height>{{ vscale(84) }}</height>
        <texture background="true">$INFO[Window.Property(home.hero.logo)]</texture>
        <aspectratio align="left" aligny="center">keep</aspectratio>
    </control>
    <control type="label">
        <animation effect="slide" end="0,{{ vscale(26) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
        <scroll>false</scroll>
        <visible>!String.IsEmpty(Window.Property(home.hero.subtitle))</visible>
        <posx>0</posx>
        <posy>{{ vscale(70) }}</posy>
        <width>880</width>
        <height>{{ vscale(30) }}</height>
        <font>font12</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>F2FFFFFF</textcolor>
        <label>$INFO[Window.Property(home.hero.subtitle)]</label>
    </control>
    {% with hero_meta_y = 112 & hero_meta_height = 30 & hero_meta_empty_shift = -42 & hero_logo_shift = 26 %}
    {% include "includes/home_hero_metadata.xml.tpl" %}
    {% endwith %}
    <control type="textbox">
        <animation effect="slide" end="0,{{ vscale(-42) }}" time="0" condition="String.IsEmpty(Window.Property(home.hero.subtitle))" reversible="true">Conditional</animation>
        <animation effect="slide" end="0,{{ vscale(26) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
        <autoscroll>false</autoscroll>
        <visible>!String.IsEmpty(Window.Property(home.hero.short_summary))</visible>
        <posx>0</posx>
        <posy>{{ vscale(154) }}</posy>
        <width>1120</width>
        <height>{{ vscale(56) }}</height>
        <font>font10</font>
        <textcolor>D8FFFFFF</textcolor>
        <label>$INFO[Window.Property(home.hero.short_summary)]</label>
    </control>
</control>

<!-- Draw the profile menu after all Home hero and hub content so nothing can
     bleed over this modal surface. -->
<control type="group" id="901">
    <visible>Control.HasFocus(250) | !String.IsEmpty(Window.Property(show.options))</visible>
    <posx>110</posx>
    <posy>{{ vscale(98) }}</posy>
    <width>340</width>
    <height>{{ vscale(500) }}</height>
    <control type="image" id="801">
        <posx>0</posx>
        <posy>0</posy>
        <width>340</width>
        <height>{{ vscale(500) }}</height>
        <texture colordiffuse="FF0D0D0D" border="28">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="list" id="250">
        <posx>20</posx>
        <posy>{{ vscale(20) }}</posy>
        <width>300</width>
        <height>{{ vscale(460) }}</height>
        <onleft>202</onleft>
        <onright>101</onright>
        <onunfocus>SetProperty(show.options,)</onunfocus>
        <scrolltime>160</scrolltime>
        <orientation>vertical</orientation>
        <itemlayout height="{{ vscale(66) }}">
            <control type="label">
                <posx>22</posx>
                <posy>0</posy>
                <width>256</width>
                <height>{{ vscale(60) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>DDFFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[ListItem.Label]</label>
            </control>
        </itemlayout>
        <focusedlayout height="{{ vscale(66) }}">
            <control type="image">
                <posx>0</posx>
                <posy>{{ vscale(2) }}</posy>
                <width>300</width>
                <height>{{ vscale(56) }}</height>
                <texture colordiffuse="FFFFFFFF" border="20">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="label">
                <posx>22</posx>
                <posy>0</posy>
                <width>256</width>
                <height>{{ vscale(60) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF000000</textcolor>
                <scroll>false</scroll>
                <label>$INFO[ListItem.Label]</label>
            </control>
        </focusedlayout>
    </control>
</control>
{% endblock content %}

{% block header %}
<control type="group" id="200">
    <animation effect="slide" end="0,{{ vscale(-135) }}" time="200" tween="sine" easing="inout" condition="!String.IsEmpty(Window(10000).Property(script.plex.off.sections)) + !ControlGroup(200).HasFocus(0)">Conditional</animation>
    <defaultcontrol always="true">204</defaultcontrol>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>{{ vscale(135) }}</height>
    <control type="image">
        <animation effect="fade" start="0" end="100" time="200" tween="quadratic" easing="out" reversible="true">VisibleChange</animation>
        <visible>ControlGroup(200).HasFocus(0) + !String.IsEmpty(Window(10000).Property(script.plex.off.sections))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>{{ vscale(135) }}</height>
        <texture>script.plex/white-square.png</texture>
        <colordiffuse>C0000000</colordiffuse>
    </control>
	    <control type="group">
	        <visible>Player.HasAudio + String.IsEmpty(Window(10000).Property(script.plex.theme_playing))</visible>
	        <posx>1180</posx>
	        <posy>0</posy>
        <control type="button" id="204">
            <visible>Player.HasAudio + String.IsEmpty(Window(10000).Property(script.plex.theme_playing))</visible>
            <posx>-10</posx>
            <posy>{{ vscale(38) }}</posy>
            <width>260</width>
            <height>{{ vscale(75) }}</height>
            <onleft>203</onleft>
            <onright>101</onright>
            <ondown>50</ondown>
            <font>font12</font>
            <textcolor>FFFFFFFF</textcolor>
            <focusedcolor>FF000000</focusedcolor>
            <align>right</align>
            <aligny>center</aligny>
            <texturefocus colordiffuse="EEFFFFFF" border="10">script.plex/white-square-rounded.png</texturefocus>
            <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
            <textoffsetx>100</textoffsetx>
            <textoffsety>0</textoffsety>
            <label> </label>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(48) }}</posy>
            <width>42</width>
            <height>{{ vscale(42) }}</height>
            <texture>$INFO[Player.Art(thumb)]</texture>
        </control>

        <control type="group">
            <visible>!Control.HasFocus(204)</visible>
            <control type="label">
                <posx>53</posx>
                <posy>{{ vscale(48) }}</posy>
                <width>187</width>
                <height>{{ vscale(20) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <info>MusicPlayer.Artist</info>
            </control>
            <control type="label">
                <posx>53</posx>
                <posy>{{ vscale(72) }}</posy>
                <width>187</width>
                <height>{{ vscale(20) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <info>MusicPlayer.Title</info>
            </control>
        </control>
        <control type="group">
            <visible>Control.HasFocus(204)</visible>
            <control type="label">
                <posx>53</posx>
                <posy>{{ vscale(48) }}</posy>
                <width>187</width>
                <height>{{ vscale(20) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF000000</textcolor>
                <info>MusicPlayer.Artist</info>
            </control>
            <control type="label">
                <posx>53</posx>
                <posy>{{ vscale(72) }}</posy>
                <width>187</width>
                <height>{{ vscale(20) }}</height>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF000000</textcolor>
                <info>MusicPlayer.Title</info>
            </control>
        </control>

        <control type="progress">
            <description>Progressbar</description>
            <posx>0</posx>
            <posy>{{ vscale(102) }}</posy>
            <width>240</width>
            <height>{{ vscale(1) }}</height>
            <texturebg colordiffuse="9AFFFFFF">script.plex/white-square-1px.png</texturebg>
            <lefttexture>script.plex/transparent-6px.png</lefttexture>
            <midtexture colordiffuse="FFFFFFFF">script.plex/white-square-1px.png</midtexture>
            <righttexture>script.plex/transparent-6px.png</righttexture>
            <overlaytexture>script.plex/transparent-6px.png</overlaytexture>
            <info>Player.Progress</info>
        </control>
	    </control>
	    <control type="label">
	        <visible>false</visible>
	        <right>213</right>
        <posy>{{ vscale(35) }}</posy>
        <width>200</width>
        <height>{{ vscale(65) }}</height>
        <font>font12</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$INFO[System.Time]</label>
    </control>
    <control type="image">
        <posx>153r</posx>
        <posy>{{ vscale(47.5) }}</posy>
        <width>93</width>
        <height>{{ vscale(43) }}</height>
        <texture>script.plex/home/plex.png</texture>
	    </control>
	    <control type="group">
	        <visible>false</visible>
	        <posx>1320</posx>
        <posy>{{ vscale(34) }}</posy>
        <width>420</width>
        <height>{{ vscale(1046) }}</height>
        <control type="grouplist">
            <posx>0</posx>
            <posy>0</posy>
            <width>420</width>
            <height>{{ vscale(1046) }}</height>
            <ondown>50</ondown>
            <onleft>204</onleft>
            <align>right</align>
            <itemgap>0</itemgap>
            <orientation>horizontal</orientation>
            <scrolltime tween="quadratic" easing="out">200</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            <control type="button" id="201">
                <width max="320">auto</width>
                <height>{{ vscale(66) }}</height>
                <font>font12</font>
                <textcolor>FFFFFFFF</textcolor>
                <focusedcolor>FF000000</focusedcolor>
                <disabledcolor>FFFFFFFF</disabledcolor>
                <align>right</align>
                <aligny>center</aligny>
                <texturefocus colordiffuse="EEFFFFFF" border="10">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <textoffsetx>100</textoffsetx>
                <textoffsety>0</textoffsety>
                <label>$INFO[Window.Property(server.name)]</label>
                <onunfocus condition="!String.IsEmpty(Window.Property(show.servers))">SetFocus(260)</onunfocus>
            </control>
            <!-- server control -->
            <control type="group">
                <posx>-93</posx>
                <width>93</width>
                <height>{{ vscale(66) }}</height>
                <control type="image">
                    <posx>6</posx>
                    <posy>{{ vscale(14) }}</posy>
                    <width>40</width>
                    <height>{{ vscale(39) }}</height>
                    <texture>$INFO[Window.Property(server.icon)]</texture>
                </control>
                <control type="image">
                    <posx>0</posx>
                    <posy>{{ vscale(38) }}</posy>
                    <width>16</width>
                    <height>{{ vscale(15) }}</height>
                    <texture>$INFO[Window.Property(server.iconmod)]</texture>
                </control>
                <!-- secure + local -->
                <control type="image">
                    <visible>!String.IsEmpty(Window.Property(server.iconmod))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(20) }}</posy>
                    <width>16</width>
                    <height>{{ vscale(14) }}</height>
                    <texture>$INFO[Window.Property(server.iconmod2)]</texture>
                    <colordiffuse>FFEEEEEE</colordiffuse>
                </control>
                <!-- local -->
                <control type="image">
                    <visible>String.IsEmpty(Window.Property(server.iconmod))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(38) }}</posy>
                    <width>16</width>
                    <height>{{ vscale(14) }}</height>
                    <texture>$INFO[Window.Property(server.iconmod2)]</texture>
                    <colordiffuse>FFEEEEEE</colordiffuse>
                </control>
                <control type="image">
                    <visible>!Control.HasFocus(201)</visible>
                    <posx>59</posx>
                    <posy>{{ vscale(27) }}</posy>
                    <width>15</width>
                    <height>{{ vscale(13) }}</height>
                    <texture>script.plex/indicators/dropdown-triangle.png</texture>
                    <colordiffuse>99FFFFFF</colordiffuse>
                </control>
                <control type="image">
                    <visible>Control.HasFocus(201)</visible>
                    <posx>59</posx>
                    <posy>{{ vscale(27) }}</posy>
                    <width>15</width>
                    <height>{{ vscale(13) }}</height>
                    <texture>script.plex/indicators/dropdown-triangle.png</texture>
                    <colordiffuse>FF222222</colordiffuse>
                </control>
                <control type="group">
                    <visible>Control.HasFocus(260) | !String.IsEmpty(Window.Property(show.servers))</visible>
                    <posx>-250</posx>
                    <posy>{{ vscale(70) }}</posy>
                    <control type="image" id="800">
                        <posx>-40</posx>
                        <posy>{{ vscale(-40) }}</posy>
                        <width>580</width>
                        <height>{{ vscale(146) }}</height>
                        <texture border="42">script.plex/drop-shadow.png</texture>
                    </control>
                    <control type="image">
                        <posx>269</posx>
                        <posy>{{ vscale(-13) }}</posy>
                        <width>15</width>
                        <height>{{ vscale(13) }}</height>
                        <texture flipy="true">script.plex/indicators/dropdown-triangle.png</texture>
                        <colordiffuse>FF1F1F1F</colordiffuse>
                    </control>
                    <control type="list" id="260">
                        <hitrect x="0" y="-10" w="500" h="910" />
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>500</width>
                        <height>{{ vscale(900) }}</height>
                        <onleft>203</onleft>
                        <onright>202</onright>
                        <onunfocus>SetProperty(show.servers,)</onunfocus>
                        <scrolltime>200</scrolltime>
                        <orientation>vertical</orientation>
                        <pagecontrol>261</pagecontrol>
                        <!-- ITEM LAYOUT ########################################## -->
                        <itemlayout height="{{ vscale(100) }}">
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(first))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FF1F1F1F" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(first)) + String.IsEmpty(ListItem.Property(last)) + String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FF1F1F1F">script.plex/white-square.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(last))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture flipy="true" colordiffuse="FF1F1F1F" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FF1F1F1F" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <control type="label">
                                    <posx>20</posx>
                                    <posy>{{ vscale(20) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font12</font>
                                    <align>left</align>
                                    <aligny>center</aligny>
                                    <textcolor>FFFFFFFF</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <posx>20</posx>
                                    <posy>{{ vscale(50) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font12</font>
                                    <align>left</align>
                                    <aligny>center</aligny>
                                    <textcolor>FFA0A0A0</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="label">
                                <visible>String.IsEmpty(ListItem.Label2)</visible>
                                <posx>20</posx>
                                <posy>0</posy>
                                <width>400</width>
                                <height>{{ vscale(100) }}</height>
                                <font>font12</font>
                                <align>left</align>
                                <aligny>center</aligny>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>

                            <!-- not status + not current + local -->
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>456</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- not status + current + local -->
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- status + not current + local -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- status + current + local -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>374</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- status + not current -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>456</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(24) }}</height>
                                <texture>script.plex/home/device/$INFO[ListItem.Property(status)]</texture>
                            </control>
                            <!-- status + current -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(24) }}</height>
                                <texture>script.plex/home/device/$INFO[ListItem.Property(status)]</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>449</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>31</width>
                                <height>{{ vscale(24) }}</height>
                                <texture colordiffuse="FFFFFFFF">script.plex/home/device/check.png</texture>
                            </control>

                        </itemlayout>
                        <focusedlayout height="{{ vscale(100) }}">
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(first))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FFF5F5F5" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(first)) + String.IsEmpty(ListItem.Property(last)) + String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FFF5F5F5">script.plex/white-square.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(last))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture flipy="true" colordiffuse="FFF5F5F5" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>500</width>
                                <height>{{ vscale(100) }}</height>
                                <texture colordiffuse="FFF5F5F5" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="group">
                                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                                <control type="label">
                                    <posx>20</posx>
                                    <posy>{{ vscale(20) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font12</font>
                                    <align>left</align>
                                    <aligny>center</aligny>
                                    <textcolor>FF000000</textcolor>
                                    <label>$INFO[ListItem.Label]</label>
                                </control>
                                <control type="label">
                                    <posx>20</posx>
                                    <posy>{{ vscale(50) }}</posy>
                                    <width>400</width>
                                    <height>{{ vscale(35) }}</height>
                                    <font>font12</font>
                                    <align>left</align>
                                    <aligny>center</aligny>
                                    <textcolor>A0000000</textcolor>
                                    <label>$INFO[ListItem.Label2]</label>
                                </control>
                            </control>
                            <control type="label">
                                <visible>String.IsEmpty(ListItem.Label2)</visible>
                                <posx>20</posx>
                                <posy>0</posy>
                                <width>400</width>
                                <height>{{ vscale(100) }}</height>
                                <font>font12</font>
                                <align>left</align>
                                <aligny>center</aligny>
                                <textcolor>FF000000</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>

                            <!-- not status + not current + local -->
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>456</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- not status + current + local -->
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- status + not current + local -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <!-- status + current + local -->
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current)) + !String.IsEmpty(ListItem.Property(local)) </visible>
                                <posx>374</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(21) }}</height>
                                <texture>script.plex/home/device/home.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>456</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(24) }}</height>
                                <texture>script.plex/home/device/focus-$INFO[ListItem.Property(status)]</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(status)) + !String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>415</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>24</width>
                                <height>{{ vscale(24) }}</height>
                                <texture>script.plex/home/device/focus-$INFO[ListItem.Property(status)]</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(current))</visible>
                                <posx>449</posx>
                                <posy>{{ vscale(38) }}</posy>
                                <width>31</width>
                                <height>{{ vscale(24) }}</height>
                                <texture colordiffuse="FF000000">script.plex/home/device/check.png</texture>
                            </control>

                        </focusedlayout>
                    </control>

                    <control type="scrollbar" id="261">
                        <posx>492</posx>
                        <posy>{{ vscale(20) }}</posy>
                        <width>8</width>
                        <height>{{ vscale(860) }}</height>
                        <texturesliderbackground>script.plex/transparent-6px.png</texturesliderbackground>
                        <texturesliderbar colordiffuse="20FFFFFF" border="4">script.plex/white-square.png</texturesliderbar>
                        <texturesliderbarfocus colordiffuse="77FFFFFF" border="4">script.plex/white-square.png</texturesliderbarfocus>
                        <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
                        <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
                        <pulseonselect>false</pulseonselect>
                        <orientation>vertical</orientation>
                        <showonepage>false</showonepage>
                        <onleft>250</onleft>
                    </control>

                </control>
            </control>
            <control type="button" id="9202">
                <width max="500">auto</width>
                <height>{{ vscale(66) }}</height>
                <font>font12</font>
                <textcolor>FFFFFFFF</textcolor>
                <focusedcolor>FF000000</focusedcolor>
                <align>right</align>
                <aligny>center</aligny>
                <texturefocus colordiffuse="FFF5F5F5" border="10">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <textoffsetx>100</textoffsetx>
                <textoffsety>0</textoffsety>
                <label>$INFO[Window.Property(user.name)]</label>
                <onunfocus condition="!String.IsEmpty(Window.Property(show.options))">SetFocus(250)</onunfocus>
            </control>
            <control type="group">
                <posx>-87</posx>
                <width>87</width>
                <height>{{ vscale(66) }}</height>
                <control type="image">
                    <posx>0</posx>
                    <posy>{{ vscale(14) }}</posy>
                    <width>40</width>
                    <height>{{ vscale(39) }}</height>
                    <texture diffuse="script.plex/home/avatar-diffuse.png" fallback="script.plex/gray-square.png">$INFO[Window.Property(user.avatar)]</texture>
                </control>
                <control type="label">
                    <visible>String.IsEmpty(Window.Property(user.avatar))</visible>
                    <posx>0</posx>
                    <posy>{{ vscale(14) }}</posy>
                    <width>40</width>
                    <height>{{ vscale(39) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>[B]$INFO[Window.Property(user.avatar.letter)][/B]</label>
                </control>
                <control type="image">
                    <visible>!String.IsEmpty(Window(10000).Property(script.plex.update_available))</visible>
                    <posx>-8</posx>
                    <posy>{{ vscale(38) }}</posy>
                    <width>16</width>
                    <height>{{ vscale(14) }}</height>
                    <texture>script.plex/home/device/update_small.png</texture>
                    <colordiffuse>FF00CC00</colordiffuse>
                </control>
                <control type="image">
                    <visible>!Control.HasFocus(202)</visible>
                    <posx>53</posx>
                    <posy>{{ vscale(27) }}</posy>
                    <width>15</width>
                    <height>{{ vscale(13) }}</height>
                    <texture>script.plex/indicators/dropdown-triangle.png</texture>
                    <colordiffuse>99FFFFFF</colordiffuse>
                </control>
                <control type="image">
                    <visible>Control.HasFocus(202)</visible>
                    <posx>53</posx>
                    <posy>{{ vscale(27) }}</posy>
                    <width>15</width>
                    <height>{{ vscale(13) }}</height>
                    <texture>script.plex/indicators/dropdown-triangle.png</texture>
                    <colordiffuse>FF222222</colordiffuse>
                </control>
                <control type="group" id="9901">
                    <visible>Control.HasFocus(250) | !String.IsEmpty(Window.Property(show.options))</visible>
                    <posx>-213</posx>
                    <posy>{{ vscale(70) }}</posy>
                    <control type="image" id="9801">
                        <posx>-40</posx>
                        <posy>{{ vscale(-40) }}</posy>
                        <width>380</width>
                        <height>{{ vscale(146) }}</height>
                        <texture border="42">script.plex/drop-shadow.png</texture>
                    </control>
                    <control type="image">
                        <posx>226</posx>
                        <posy>{{ vscale(-13) }}</posy>
                        <width>15</width>
                        <height>{{ vscale(13) }}</height>
                        <texture flipy="true">script.plex/indicators/dropdown-triangle.png</texture>
                        <colordiffuse>FF1F1F1F</colordiffuse>
                    </control>
                    <control type="list" id="9250">
                        <hitrect x="0" y="-10" w="300" h="422" />
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>300</width>
                        <height>{{ vscale(422) }}</height>
                        <onleft>201</onleft>
                        <onunfocus>SetProperty(show.options,)</onunfocus>
                        <scrolltime>200</scrolltime>
                        <orientation>vertical</orientation>
                        <!-- ITEM LAYOUT ########################################## -->
                        <itemlayout height="{{ vscale(66) }}">
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(first))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FF1F1F1F" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(first)) + String.IsEmpty(ListItem.Property(last)) + String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FF1F1F1F">script.plex/white-square.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(last))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture flipy="true" colordiffuse="FF1F1F1F" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FF1F1F1F" border="10">script.plex/white-square-rounded.png</texture>
                            </control>
                            <control type="label">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <font>font12</font>
                                <align>center</align>
                                <aligny>center</aligny>
                                <textcolor>FFFFFFFF</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                        </itemlayout>
                        <focusedlayout height="{{ vscale(66) }}">
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(first))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FFF5F5F5" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>String.IsEmpty(ListItem.Property(first)) + String.IsEmpty(ListItem.Property(last)) + String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FFF5F5F5">script.plex/white-square.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(last))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture flipy="true" colordiffuse="FFF5F5F5" border="10">script.plex/white-square-top-rounded.png</texture>
                            </control>
                            <control type="image">
                                <visible>!String.IsEmpty(ListItem.Property(only))</visible>
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <texture colordiffuse="FFF5F5F5" border="10">script.plex/white-square-rounded.png</texture>
                            </control>
                            <control type="label">
                                <posx>0</posx>
                                <posy>0</posy>
                                <width>300</width>
                                <height>{{ vscale(66) }}</height>
                                <font>font12</font>
                                <align>center</align>
                                <aligny>center</aligny>
                                <textcolor>FF000000</textcolor>
                                <label>$INFO[ListItem.Label]</label>
                            </control>
                        </focusedlayout>
                    </control>
                </control>
            </control>
            <control type="image">
                <!-- dummy image to allow shadow -->
                <width>40</width>
                <height>{{ vscale(10) }}</height>
                <texture>script.plex/transparent-6px.png</texture>
            </control>
        </control>
    </control>
</control>

<control type="group">
    <visible>!String.IsEmpty(Window.Property(search.dialog))</visible>
    <control type="group" >
        <visible>!String.IsEmpty(Window.Property(search.dialog.hasresults))</visible>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>1080</height>
            <texture>script.plex/home/background-fallback.png</texture>
            {% include "includes/scale_background.xml.tpl" %}
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>1080</height>
            <texture background="true">$INFO[Window.Property(background)]</texture>
            {% include "includes/scale_background.xml.tpl" %}
        </control>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>1080</height>
        <texture colordiffuse="99606060">script.plex/white-square.png</texture>
        {% include "includes/scale_background.xml.tpl" %}
    </control>
</control>

<control type="group">
    <visible>String.IsEmpty(Window.Property(busy)) + !String.IsEmpty(Window.Property(no.content))</visible>
    <posx>0</posx>
    <posy>{{ vscale(465) }}</posy>
    <control type="image">
        <posx>560</posx>
        <posy>{{ vscale(-76) }}</posy>
        <width>800</width>
        <height>{{ vscale(220) }}</height>
        <texture colordiffuse="D90B0B0B" border="30">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <scroll>false</scroll>
        <posx>60</posx>
        <posy>0</posy>
        <width>1800</width>
        <height>{{ vscale(35) }}</height>
        <font>font13</font>
        <align>center</align>
        <textcolor>FFFFFFFF</textcolor>
        <label>[B]$ADDON[script.plexmod 32452][/B]</label>
    </control>
    <control type="label">
        <scroll>false</scroll>
        <posx>60</posx>
        <posy>{{ vscale(60) }}</posy>
        <width>1800</width>
        <height>{{ vscale(35) }}</height>
        <font>font13</font>
        <align>center</align>
        <textcolor>FFCCCCCC</textcolor>
        <label>$ADDON[script.plexmod 32453]</label>
    </control>
</control>

<control type="group">
    <visible>!String.IsEmpty(Window.Property(busy)) | !String.IsEmpty(Window.Property(loading.content))</visible>
    <animation effect="fade" start="0" end="100">Visible</animation>
    <posx>840</posx>
    <posy>{{ vscale(465) }}</posy>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>240</width>
        <height>{{ vscale(150) }}</height>
        <texture>script.plex/busy-back.png</texture>
        <colordiffuse>A0FFFFFF</colordiffuse>
    </control>
    <control type="image">
        <posx>75</posx>
        <posy>{{ vscale(56) }}</posy>
        <width>90</width>
        <height>{{ vscale(38) }}</height>
        <texture diffuse="script.plex/busy-diffuse.png">script.plex/busy.gif</texture>
    </control>
</control>
{% endblock header %}
