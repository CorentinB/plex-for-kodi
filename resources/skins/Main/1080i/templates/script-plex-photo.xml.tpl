{% extends "base.xml.tpl" %}
{% block headers %}
    <defaultcontrol>250</defaultcontrol>
    <zorder>100</zorder>
{% endblock %}

{% block controls %}
<!-- The blurred Plex transcode fills unused aspect-ratio space; the original
     photo remains uncropped above it. -->
<control type="group">
    {% include "includes/default_background.xml.tpl" %}
    <control type="image" id="600">
        <animation effect="rotate" time="200" start="0" end="90" center="960,540" reversible="false" condition="Integer.IsGreater(Window.Property(rotate),89)">Conditional</animation>
        <animation effect="rotate" time="200" start="0" end="90" center="960,540" reversible="false" condition="Integer.IsGreater(Window.Property(rotate),179)">Conditional</animation>
        <animation effect="rotate" time="200" start="0" end="90" center="960,540" reversible="false" condition="Integer.IsGreater(Window.Property(rotate),269)">Conditional</animation>
        <animation effect="rotate" time="200" start="270" end="360" center="960,540" reversible="false" condition="!Integer.IsGreater(Window.Property(rotate),89)">Conditional</animation>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>1080</height>
        <fadetime>500</fadetime>
        <texture background="true">$INFO[Window.Property(photo)]</texture>
        <aspectratio>keep</aspectratio>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(Window.Property(is.updating))</visible>
        <animation effect="fade" time="250" delay="250">VisibleChange</animation>
        <control type="image">
            <posx>856</posx>
            <posy>456</posy>
            <width>208</width>
            <height>168</height>
            <texture colordiffuse="E60B0B0B" border="32">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="image">
            <posx>915</posx>
            <posy>502</posy>
            <width>90</width>
            <height>76</height>
            <texture diffuse="script.plex/busy-diffuse.png">script.plex/busy.gif</texture>
        </control>
    </control>
</control>

<!-- Full-screen remote target. Real transparency prevents Kodi from trying to
     resolve the legacy '-' pseudo-texture on every OSD transition. -->
<control type="togglebutton" id="250">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texturefocus>script.plex/transparent-6px.png</texturefocus>
    <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
    <usealttexture>!String.IsEmpty(Window.Property(OSD))</usealttexture>
    <alttexturefocus>script.plex/transparent-6px.png</alttexturefocus>
    <alttexturenofocus>script.plex/transparent-6px.png</alttexturenofocus>
    <label> </label>
    <onclick>SetProperty(OSD,1)</onclick>
    <onclick>SetFocus(406)</onclick>
    <altclick>SetProperty(OSD,)</altclick>
    <ondown>SetProperty(OSD,1)</ondown>
    <ondown>SetFocus(406)</ondown>
    <onfocus condition="!String.IsEmpty(Window.Property(show.pqueue))">SetFocus(500)</onfocus>
    <onfocus condition="!String.IsEmpty(Window.Property(OSD))">SetFocus(406)</onfocus>
</control>

<!-- Compact tvOS control dock and optional filmstrip. The whole group moves up
     as one unit when the filmstrip opens, preserving a consistent 44px gap. -->
<control type="group" id="200">
    <animation effect="slide" start="0,0" end="0,-190" time="180" tween="sine" easing="inout" condition="!String.IsEmpty(Window.Property(show.pqueue))">Conditional</animation>

    <control type="group">
        <visible allowhiddenfocus="true">!String.IsEmpty(Window.Property(OSD))</visible>
        <animation effect="fade" start="0" end="100" time="120">VisibleChange</animation>
        <control type="image">
            <posx>480</posx>
            <posy>924</posy>
            <width>960</width>
            <height>112</height>
            <texture colordiffuse="EE0B0B0B" border="34">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="grouplist" id="400">
            <defaultcontrol>406</defaultcontrol>
            <posx>500</posx>
            <posy>928</posy>
            <width>920</width>
            <height>104</height>
            <align>center</align>
            <orientation>horizontal</orientation>
            <itemgap>-30</itemgap>
            <scrolltime tween="quadratic" easing="out">160</scrolltime>
            <usecontrolcoords>true</usecontrolcoords>
            <onup>SetProperty(OSD,)</onup>
            <onup>250</onup>
            <ondown condition="!String.IsEmpty(Window.Property(show.pqueue))">500</ondown>
            <ondown condition="String.IsEmpty(Window.Property(show.pqueue))">SetProperty(OSD,)</ondown>
            <ondown condition="String.IsEmpty(Window.Property(show.pqueue))">250</ondown>

            <control type="togglebutton" id="401">
                <visible>String.IsEmpty(Window.Property(no.playlist))</visible>
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}repeat{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}repeat.png</texturenofocus>
                <usealttexture>!String.IsEmpty(Window.Property(pq.repeat))</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}repeat{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}repeat.png</alttexturenofocus>
                <label> </label>
            </control>
            <control type="button" id="421">
                <enable>false</enable>
                <visible>!String.IsEmpty(Window.Property(no.playlist))</visible>
                <width>116</width><height>104</height>
                <texturefocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}repeat.png</texturefocus>
                <texturenofocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}repeat.png</texturenofocus>
                <label> </label>
            </control>

            <control type="togglebutton" id="402">
                <visible>String.IsEmpty(Window.Property(no.playlist))</visible>
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle.png</texturenofocus>
                <usealttexture>!String.IsEmpty(Window.Property(pq.shuffled))</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}shuffle.png</alttexturenofocus>
                <label> </label>
            </control>
            <control type="button" id="422">
                <enable>false</enable>
                <visible>!String.IsEmpty(Window.Property(no.playlist))</visible>
                <width>116</width><height>104</height>
                <texturefocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}shuffle.png</texturefocus>
                <texturenofocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}shuffle.png</texturenofocus>
                <label> </label>
            </control>

            <control type="button" id="403">
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}rotate{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}rotate.png</texturenofocus>
                <label> </label>
            </control>

            <control type="button" id="404">
                <visible>String.IsEmpty(Window.Property(hide.prev))</visible>
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus flipx="true"{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus flipx="true"{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>
            <control type="button" id="424">
                <enable>false</enable>
                <visible>!String.IsEmpty(Window.Property(hide.prev))</visible>
                <width>116</width><height>104</height>
                <texturefocus flipx="true" colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}next.png</texturefocus>
                <texturenofocus flipx="true" colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>

            <control type="togglebutton" id="406">
                {% if theme.buttons.zoomPlayButton %}
                    <animation effect="zoom" start="100" end="106" time="110" center="58,52" reversible="true" condition="Control.HasFocus(406)">Conditional</animation>
                {% endif %}
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}play{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}play.png</texturenofocus>
                <usealttexture>!String.IsEmpty(Window.Property(playing))</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pause{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pause.png</alttexturenofocus>
                <label> </label>
            </control>

            <control type="button" id="407">
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}stop{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}stop.png</texturenofocus>
                <label> </label>
            </control>

            <control type="button" id="409">
                <visible>String.IsEmpty(Window.Property(hide.next))</visible>
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>
            <control type="button" id="419">
                <enable>false</enable>
                <visible>!String.IsEmpty(Window.Property(hide.next))</visible>
                <width>116</width><height>104</height>
                <texturefocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}next.png</texturefocus>
                <texturenofocus colordiffuse="38FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
                <label> </label>
            </control>

            <control type="togglebutton" id="412">
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}square2x2{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}square2x2.png</texturenofocus>
                <usealttexture>!String.IsEmpty(Window.Property(show.pqueue))</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}square2x2{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}square2x2.png</alttexturenofocus>
                <onclick>SetProperty(show.pqueue,1)</onclick>
                <onclick>SetProperty(show.info,)</onclick>
                <altclick>SetProperty(show.pqueue,)</altclick>
                <label> </label>
            </control>

            <control type="togglebutton" id="413">
                <width>116</width><height>104</height>
                <hitrect x="24" y="20" w="68" h="56" />
                <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}info{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
                <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('88FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}info.png</texturenofocus>
                <usealttexture>!String.IsEmpty(Window.Property(show.info))</usealttexture>
                <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default('FFFFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}info{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
                <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}info.png</alttexturenofocus>
                <onclick>SetProperty(show.info,1)</onclick>
                <onclick>SetProperty(show.pqueue,)</onclick>
                <altclick>SetProperty(show.info,)</altclick>
                <label> </label>
            </control>
        </control>
    </control>

    <control type="group">
        <visible>!String.IsEmpty(Window.Property(show.pqueue))</visible>
        <control type="image">
            <posx>90</posx>
            <posy>1080</posy>
            <width>1740</width>
            <height>180</height>
            <texture colordiffuse="EE0B0B0B" border="36">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="label">
            <posx>135</posx>
            <posy>1090</posy>
            <width>400</width>
            <height>34</height>
            <font>font20</font>
            <textcolor>CCFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35062]</label>
        </control>
        <control type="fixedlist" id="500">
            <posx>135</posx>
            <posy>1124</posy>
            <width>1650</width>
            <height>150</height>
            <orientation>horizontal</orientation>
            <scrolltime tween="quadratic" easing="out">180</scrolltime>
            <preloaditems>4</preloaditems>
            <focusposition>5</focusposition>
            <onup>SetProperty(OSD,1)</onup>
            <onup>412</onup>
            <ondown>SetProperty(show.pqueue,)</ondown>
            <ondown>SetProperty(OSD,)</ondown>
            <ondown>250</ondown>

            <itemlayout width="150">
                <control type="image">
                    <posx>9</posx><posy>9</posy>
                    <width>132</width><height>132</height>
                    <texture background="true" fallback="script.plex/thumb_fallbacks/photo.png" diffuse="script.plex/square-photo-queue-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                    <aspectratio>scale</aspectratio>
                </control>
            </itemlayout>

            <focusedlayout width="150">
                <control type="group">
                    <control type="image">
                        <posx>4</posx><posy>4</posy>
                        <width>142</width><height>142</height>
                        <texture>script.plex/square-photo-queue-rounded-focus.png</texture>
                    </control>
                    <control type="image">
                        <posx>9</posx><posy>9</posy>
                        <width>132</width><height>132</height>
                        <texture background="true" fallback="script.plex/thumb_fallbacks/photo.png" diffuse="script.plex/square-photo-queue-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>
</control>

<!-- Bounded metadata card. It deliberately contains no focusable controls, so
     opening information never steals the remote from the photo dock. -->
<control type="group">
    <visible>!String.IsEmpty(Window.Property(show.info))</visible>
    <animation effect="fade" start="0" end="100" time="160">VisibleChange</animation>
    <animation effect="slide" start="28,0" end="0,0" time="180" tween="sine" easing="out">VisibleChange</animation>
    <control type="image">
        <posx>1390</posx>
        <posy>60</posy>
        <width>470</width>
        <height>720</height>
        <texture colordiffuse="EE0B0B0B" border="36">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="group">
        <posx>1430</posx>
        <posy>92</posy>
        <width>390</width>
        <height>656</height>

        <control type="label">
            <posx>0</posx><posy>0</posy>
            <width>390</width><height>36</height>
            <font>font20</font>
            <textcolor>99FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35057]</label>
        </control>
        <control type="textbox">
            <posx>0</posx><posy>46</posy>
            <width>390</width><height>82</height>
            <font>font30_title</font>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(photo.title)]</label>
        </control>
        <control type="label">
            <posx>0</posx><posy>132</posy>
            <width>390</width><height>30</height>
            <font>font13</font>
            <textcolor>B3FFFFFF</textcolor>
            <label>$INFO[Window.Property(photo.date)]</label>
        </control>
        <control type="image">
            <posx>0</posx><posy>180</posy>
            <width>390</width><height>1</height>
            <texture colordiffuse="30FFFFFF">script.plex/white-square.png</texture>
        </control>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(camera.model))</visible>
            <control type="label">
                <posx>0</posx><posy>202</posy><width>390</width><height>24</height>
                <font>font10</font><textcolor>80FFFFFF</textcolor>
                <label>$ADDON[script.plexmod 35058]</label>
            </control>
            <control type="label">
                <posx>0</posx><posy>226</posy><width>390</width><height>34</height>
                <font>font13</font><textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(camera.model)]</label>
            </control>
        </control>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(camera.lens))</visible>
            <control type="label">
                <posx>0</posx><posy>272</posy><width>390</width><height>24</height>
                <font>font10</font><textcolor>80FFFFFF</textcolor>
                <label>$ADDON[script.plexmod 35059]</label>
            </control>
            <control type="label">
                <posx>0</posx><posy>296</posy><width>390</width><height>34</height>
                <font>font13</font><textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(camera.lens)]</label>
            </control>
        </control>

        <control type="group">
            <visible>!String.IsEmpty(Window.Property(photo.dims)) | !String.IsEmpty(Window.Property(photo.container))</visible>
            <control type="label">
                <posx>0</posx><posy>342</posy><width>390</width><height>24</height>
                <font>font10</font><textcolor>80FFFFFF</textcolor>
                <label>$ADDON[script.plexmod 35060]</label>
            </control>
            <control type="label">
                <posx>96</posx><posy>366</posy><width>294</width><height>36</height>
                <font>font10</font><textcolor>FFFFFFFF</textcolor>
                <label>$INFO[Window.Property(photo.dims)]</label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Window.Property(photo.container))</visible>
                <posx>0</posx><posy>366</posy><width>80</width><height>36</height>
                <texture colordiffuse="2EFFFFFF" border="16">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(Window.Property(photo.container))</visible>
                <posx>0</posx><posy>366</posy><width>80</width><height>36</height>
                <font>font10</font><align>center</align><aligny>center</aligny>
                <textcolor>E6FFFFFF</textcolor>
                <label>[UPPERCASE]$INFO[Window.Property(photo.container)][/UPPERCASE]</label>
            </control>
        </control>

        <control type="label">
            <visible>!String.IsEmpty(Window.Property(camera.settings))</visible>
            <posx>0</posx><posy>418</posy><width>390</width><height>34</height>
            <font>font12</font><textcolor>B3FFFFFF</textcolor>
            <label>$INFO[Window.Property(camera.settings)]</label>
        </control>

        <control type="textbox">
            <visible>!String.IsEmpty(Window.Property(photo.summary))</visible>
            <posx>0</posx><posy>470</posy><width>390</width><height>176</height>
            <font>font13</font><textcolor>CCFFFFFF</textcolor>
            <label>$INFO[Window.Property(photo.summary)]</label>
        </control>
    </control>
</control>
{% endblock %}
