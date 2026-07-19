{% extends "base.xml.tpl" %}
{% block headers %}<defaultcontrol>100</defaultcontrol>{% endblock %}
{% block backgroundcolor %}<backgroundcolor>$INFO[Window.Property(background_colour_opaque)]</backgroundcolor>{% endblock %}
{% block controls %}
<control type="group">
    <visible>String.IsEmpty(Window.Property(use_solid_background))</visible>
    <control type="image">
        <visible>String.IsEmpty(Window.Property(use_solid_background)) + String.IsEmpty(Window.Property(use_bg_fallback)) + String.IsEmpty(Window.Property(background_static))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>1080</height>
        <texture>script.plex/home/background-fallback.png</texture>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(use_bg_fallback))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>1080</height>
        <texture>script.plex/home/background-fallback.png</texture>
    </control>
</control>

<control type="image">
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texture colordiffuse="88FFFFFF">script.plex/home/background-fallback.png</texture>
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
    <texture colordiffuse="44000000">script.plex/white-square.png</texture>
</control>

<control type="group">
    <animation effect="fade" time="100" start="100" end="20" condition="ControlGroup(400).HasFocus(0)">Conditional</animation>
    <visible>Player.HasAudio + String.IsEmpty(Window(10000).Property(script.plex.theme_playing))</visible>
    <posx>441</posx>
    <posy>{{ vscale(780) }}</posy>

    <control type="image">
        <posx>-50</posx>
        <posy>{{ vscale(-50) }}</posy>
        <width>1138</width>
        <height>{{ vscale(325) }}</height>
        <texture border="48" colordiffuse="99000000">script.plex/square-rounded-shadow.png</texture>
    </control>
    <control type="image">
        <posx>-24</posx>
        <posy>{{ vscale(-24) }}</posy>
        <width>1086</width>
        <height>{{ vscale(273) }}</height>
        <texture border="34" colordiffuse="E5111114">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>225</width>
        <height>{{ vscale(225) }}</height>
        <texture fallback="script.plex/thumb_fallbacks/music.png" diffuse="script.plex/square-rounded-mask.png">$INFO[Player.Art(thumb)]</texture>
        <aspectratio>scale</aspectratio>
    </control>
    <control type="image">
        <posx>-4</posx>
        <posy>{{ vscale(-4) }}</posy>
        <width>233</width>
        <height>{{ vscale(233) }}</height>
        <texture colordiffuse="24FFFFFF">script.plex/square-rounded-outline.png</texture>
    </control>

    <control type="group">
        <posx>255</posx>
        <posy>0</posy>
        <control type="label">
            <posx>0</posx>
            <posy>0</posy>
            <width>783</width>
            <height>{{ vscale(42) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>[B]$INFO[MusicPlayer.Title][/B]</label>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(42) }}</posy>
            <width>783</width>
            <height>{{ vscale(34) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>DDFFFFFF</textcolor>
            <info>MusicPlayer.Artist</info>
        </control>
        <control type="label">
            <posx>0</posx>
            <posy>{{ vscale(76) }}</posy>
            <width>783</width>
            <height>{{ vscale(30) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>88FFFFFF</textcolor>
            <info>MusicPlayer.Album</info>
        </control>
    </control>

    <control type="grouplist" id="600">
        <defaultcontrol>406</defaultcontrol>
        <hitrect x="460" y="998" w="1000" h="55" />
        <posx>255</posx>
        <posy>{{ vscale(112) }}</posy>
        <width>783</width>
        <height>{{ vscale(124) }}</height>
        <align>center</align>
        <onup>101</onup>
        <itemgap>-40</itemgap>
        <orientation>horizontal</orientation>
        <scrolltime tween="quadratic" easing="out">200</scrolltime>
        <usecontrolcoords>true</usecontrolcoords>

        <control type="button" id="404">
            <enable>MusicPlayer.HasPrevious</enable>
            <animation effect="zoom" start="100" end="106" time="110" center="93,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(404)">Conditional</animation>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>30</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <texturefocus flipx="true">script.plex/buttons/player/modern-focused/next.png</texturefocus>
            <texturenofocus flipx="true" colordiffuse="99FFFFFF">script.plex/buttons/player/modern/next.png</texturenofocus>
            <onclick>PlayerControl(Previous)</onclick>
            <label> </label>
        </control>
        <control type="togglebutton" id="406">
            <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(406)">Conditional</animation>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <texturefocus>script.plex/buttons/player/modern-focused/pause.png</texturefocus>
            <texturenofocus colordiffuse="99FFFFFF">script.plex/buttons/player/modern/pause.png</texturenofocus>
            <usealttexture>Player.Paused | Player.Forwarding | Player.Rewinding</usealttexture>
            <alttexturefocus>script.plex/buttons/player/modern-focused/play.png</alttexturefocus>
            <alttexturenofocus colordiffuse="99FFFFFF">script.plex/buttons/player/modern/play.png</alttexturenofocus>
            <onclick>PlayerControl(Play)</onclick>
            <label> </label>
        </control>
        <control type="button" id="409">
            <enable>MusicPlayer.HasNext</enable>
            <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(409)">Conditional</animation>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <texturefocus>script.plex/buttons/player/modern-focused/next.png</texturefocus>
            <texturenofocus colordiffuse="99FFFFFF">script.plex/buttons/player/modern/next.png</texturenofocus>
            <onclick>PlayerControl(Next)</onclick>
            <label> </label>
        </control>
        <control type="button" id="407">
            <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(407)">Conditional</animation>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <texturefocus>script.plex/buttons/player/modern-focused/stop.png</texturefocus>
            <texturenofocus colordiffuse="99FFFFFF">script.plex/buttons/player/modern/stop.png</texturenofocus>
            <onclick>PlayerControl(Stop)</onclick>
            <label> </label>
        </control>
    </control>

    <control type="label">
        <posx>255</posx>
        <posy>{{ vscale(170) }}</posy>
        <width>120</width>
        <height>{{ vscale(40) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <info>MusicPlayer.Time</info>
    </control>
    <control type="label">
        <posx>918</posx>
        <posy>{{ vscale(170) }}</posy>
        <width>120</width>
        <height>{{ vscale(40) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <info>MusicPlayer.TimeRemaining</info>
    </control>


    <control type="progress">
        <description>Progressbar</description>
        <posx>255</posx>
        <posy>{{ vscale(216) }}</posy>
        <width>783</width>
        <height>{{ vscale(3) }}</height>
        <texturebg colordiffuse="9AFFFFFF">script.plex/white-square-1px.png</texturebg>
        <lefttexture>script.plex/transparent-6px.png</lefttexture>
        <midtexture colordiffuse="FFFFFFFF">script.plex/white-square-1px.png</midtexture>
        <righttexture>script.plex/transparent-6px.png</righttexture>
        <overlaytexture>script.plex/transparent-6px.png</overlaytexture>
        <info>Player.Progress</info>
    </control>
</control>

<control type="group" id="100">
    <posx>0</posx>
    <posy>{{ vscale(315) }}</posy>
    <defaultcontrol always="true">101</defaultcontrol>

    <control type="fixedlist" id="101">
        <posx>-180</posx>
        <posy>{{ vscale(-20) }}</posy>
        <width>2100</width>
        <height>{{ vscale(410) }}</height>
        <scrolltime>200</scrolltime>
        <onup>500</onup>
        <ondown condition="Player.HasAudio">600</ondown>
        <ondown condition="!String.IsEmpty(Container(101).ListItem.Property(protected))">400</ondown>
        <orientation>horizontal</orientation>
        <focusposition>3</focusposition>

        <!-- ITEM LAYOUT ########################################## -->
        <itemlayout width="330">
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(empty))</visible>
                <posx>35</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>230</width>
                <height>{{ vscale(310) }}</height>
                <control type="image">
                    <posx>23</posx>
                    <posy>{{ vscale(18) }}</posy>
                    <width>184</width>
                    <height>{{ vscale(184) }}</height>
                    <texture>script.plex/user_select/avatar-background.png</texture>
                    <colordiffuse>22000000</colordiffuse>
                </control>
                <control type="image">
                    <visible>Control.HasFocus(101) | ControlGroup(400).HasFocus(0)</visible>
                    <posx>63</posx>
                    <posy>{{ vscale(58) }}</posy>
                    <width>104</width>
                    <height>{{ vscale(104) }}</height>
                    <texture>script.plex/user_select/refresh.png</texture>
                    <colordiffuse>AAFFFFFF</colordiffuse>
                </control>
                <control type="label">
                    <posx>-35</posx>
                    <posy>{{ vscale(224) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(55) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>AAFFFFFF</textcolor>
                    <label>$ADDON[script.plexmod 35033]</label>
                </control>
            </control>

            <control type="group">
                <visible>String.IsEmpty(ListItem.Property(empty))</visible>
                <posx>15</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>300</width>
                <height>{{ vscale(310) }}</height>
                <control type="image">
                    <posx>40</posx>
                    <posy>0</posy>
                    <width>220</width>
                    <height>{{ vscale(220) }}</height>
                    <texture>script.plex/user_select/avatar-background.png</texture>
                    <colordiffuse>66FFFFFF</colordiffuse>
                </control>
                <control type="image">
                    <posx>50</posx>
                    <posy>{{ vscale(10) }}</posy>
                    <width>200</width>
                    <height>{{ vscale(200) }}</height>
                    <texture diffuse="script.plex/user_select/avatar-diffuse.png" fallback="script.plex/gray-square.png">$INFO[ListItem.Thumb]</texture>
                </control>
                <control type="label">
                    <visible>String.IsEmpty(ListItem.Thumb)</visible>
                    <posx>50</posx>
                    <posy>{{ vscale(10) }}</posy>
                    <width>200</width>
                    <height>{{ vscale(200) }}</height>
                    <font>WeatherTemp</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label2]</label>
                </control>

                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(protected))</visible>
                    <posx>29</posx>
                    <posy>{{ vscale(174) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/protected-back.png</texture>
                        <colordiffuse>A0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/protected-icon.png</texture>
                    </control>
                </control>

                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(admin))</visible>
                    <posx>217</posx>
                    <posy>{{ vscale(174) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/admin-back.png</texture>
                        <colordiffuse>A0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/admin-icon.png</texture>
                    </control>
                </control>
                <control type="label">
                    <posx>0</posx>
                    <posy>{{ vscale(235) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(55) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>AAFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>
        </itemlayout>

        <!-- FOCUSED LAYOUT ####################################### -->
        <focusedlayout width="330">
            <control type="group">
                <visible>!String.IsEmpty(ListItem.Property(empty))</visible>
                <animation effect="zoom" start="100" end="106" time="160" tween="sine" easing="out" center="150,150" reversible="true">Focus</animation>
                <posx>35</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>230</width>
                <height>{{ vscale(310) }}</height>
                <control type="image">
                    <posx>23</posx>
                    <posy>{{ vscale(18) }}</posy>
                    <width>184</width>
                    <height>{{ vscale(184) }}</height>
                    <texture>script.plex/user_select/avatar-background.png</texture>
                    <colordiffuse>FFFFFFFF</colordiffuse>
                </control>
                <control type="image">
                    <visible>Control.HasFocus(101) | ControlGroup(400).HasFocus(0)</visible>
                    <posx>63</posx>
                    <posy>{{ vscale(58) }}</posy>
                    <width>104</width>
                    <height>{{ vscale(104) }}</height>
                    <texture>script.plex/user_select/refresh.png</texture>
                    <colordiffuse>FF111111</colordiffuse>
                </control>
                <control type="label">
                    <posx>-35</posx>
                    <posy>{{ vscale(224) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(55) }}</height>
                    <font>font10</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$ADDON[script.plexmod 35033]</label>
                </control>
            </control>

            <control type="group">
                <visible>String.IsEmpty(ListItem.Property(empty))</visible>
                <animation effect="zoom" start="100" end="106" time="160" tween="sine" easing="out" center="150,150" reversible="true">Focus</animation>
                <posx>15</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>300</width>
                <height>{{ vscale(310) }}</height>
                <control type="image">
                    <posx>40</posx>
                    <posy>0</posy>
                    <width>220</width>
                    <height>{{ vscale(220) }}</height>
                    <texture>script.plex/user_select/avatar-background.png</texture>
                    <colordiffuse>FFFFFFFF</colordiffuse>
                </control>
                <control type="image">
                    <posx>50</posx>
                    <posy>{{ vscale(10) }}</posy>
                    <width>200</width>
                    <height>{{ vscale(200) }}</height>
                    <texture diffuse="script.plex/user_select/avatar-diffuse.png" fallback="script.plex/gray-square.png">$INFO[ListItem.Thumb]</texture>
                </control>
                <control type="label">
                    <visible>String.IsEmpty(ListItem.Thumb)</visible>
                    <posx>50</posx>
                    <posy>{{ vscale(10) }}</posy>
                    <width>200</width>
                    <height>{{ vscale(200) }}</height>
                    <font>WeatherTemp</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label2]</label>
                </control>

                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(protected))</visible>
                    <posx>29</posx>
                    <posy>{{ vscale(174) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/protected-back.png</texture>
                        <colordiffuse>A0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/protected-icon.png</texture>
                    </control>
                </control>

                <control type="group">
                    <visible>!String.IsEmpty(ListItem.Property(admin))</visible>
                    <posx>217</posx>
                    <posy>{{ vscale(174) }}</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/admin-back.png</texture>
                        <colordiffuse>A0000000</colordiffuse>
                    </control>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>54</width>
                        <height>{{ vscale(54) }}</height>
                        <texture>script.plex/user_select/admin-icon.png</texture>
                    </control>
                </control>

                <control type="label">
                    <posx>0</posx>
                    <posy>{{ vscale(235) }}</posy>
                    <width>300</width>
                    <height>{{ vscale(55) }}</height>
                    <font>font13</font>
                    <align>center</align>
                    <aligny>center</aligny>
                    <textcolor>FFFFFFFF</textcolor>
                    <label>$INFO[ListItem.Label]</label>
                </control>
            </control>

        </focusedlayout>
    </control>

    <control type="group" id="400">
        <defaultcontrol always="true">205</defaultcontrol>
        <visible allowhiddenfocus="true">!String.IsEmpty(Container(101).ListItem.Property(protected)) + ControlGroup(400).HasFocus(0) + !String.IsEmpty(Window.Property(initialized))</visible>
        <posx>810</posx>
        <posy>{{ vscale(375) }}</posy>
        <control type="button">
            <posx>0</posx>
            <posy>0</posy>
            <width>300</width>
            <height>{{ vscale(239) }}</height>
            <onleft>400</onleft>
            <onright>400</onright>
            <onup>400</onup>
            <ondown>400</ondown>
            <texturefocus>script.plex/transparent-6px.png</texturefocus>
            <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
            <label> </label>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(-75) }}</posy>
            <width>300</width>
            <height>{{ vscale(75) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>FF000000</colordiffuse>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>{{ vscale(-75) }}</posy>
            <width>300</width>
            <height>{{ vscale(75) }}</height>
            <texture fallback="script.plex/gray-square.png">$INFO[Container(101).ListItem.Property(back.image)]</texture>
            <colordiffuse>40FFFFFF</colordiffuse>
        </control>
        <control type="label">
            <visible>String.IsEmpty(Container(101).ListItem.Property(editing.pin))</visible>
            <posx>0</posx>
            <posy>{{ vscale(-75) }}</posy>
            <width>300</width>
            <height>{{ vscale(75) }}</height>
            <font>font13</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Container(101).ListItem.Label]</label>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Container(101).ListItem.Property(editing.pin))</visible>
            <posx>0</posx>
            <posy>{{ vscale(-75) }}</posy>
            <width>300</width>
            <height>{{ vscale(75) }}</height>
            <font>font13</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>[B]$INFO[Container(101).ListItem.Property(pin)][/B]</label>
        </control>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>300</width>
            <height>{{ vscale(239) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>FF000000</colordiffuse>
        </control>
        <control type="group" id="300">
            <defaultcontrol>205</defaultcontrol>
            <control type="group" id="200">
                <defaultcontrol>205</defaultcontrol>
                <control type="button" id="201">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>202</onright>
                    <onup>101</onup>
                    <ondown>204</ondown>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]1[/B]</label>
                </control>
                <control type="button" id="202">
                    <posx>75</posx>
                    <posy>0</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>203</onright>
                    <onleft>201</onleft>
                    <onup>101</onup>
                    <ondown>205</ondown>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]2[/B]</label>
                </control>
                <control type="button" id="203">
                    <posx>150</posx>
                    <posy>0</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>211</onright>
                    <onleft>202</onleft>
                    <onup>101</onup>
                    <ondown>206</ondown>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]3[/B]</label>
                </control>
                <control type="button" id="204">
                    <posx>0</posx>
                    <posy>{{ vscale(60) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>205</onright>
                    <ondown>207</ondown>
                    <onup>201</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]4[/B]</label>
                </control>
                <control type="button" id="205">
                    <posx>75</posx>
                    <posy>{{ vscale(60) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>206</onright>
                    <onleft>204</onleft>
                    <ondown>208</ondown>
                    <onup>202</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]5[/B]</label>
                </control>
                <control type="button" id="206">
                    <posx>150</posx>
                    <posy>{{ vscale(60) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>211</onright>
                    <onleft>205</onleft>
                    <ondown>209</ondown>
                    <onup>203</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]6[/B]</label>
                </control>
                <control type="button" id="207">
                    <posx>0</posx>
                    <posy>{{ vscale(120) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>208</onright>
                    <ondown>210</ondown>
                    <onup>204</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]7[/B]</label>
                </control>
                <control type="button" id="208">
                    <posx>75</posx>
                    <posy>{{ vscale(120) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>209</onright>
                    <onleft>207</onleft>
                    <ondown>210</ondown>
                    <onup>205</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]8[/B]</label>
                </control>
                <control type="button" id="209">
                    <posx>150</posx>
                    <posy>{{ vscale(120) }}</posy>
                    <width>73</width>
                    <height>{{ vscale(58) }}</height>
                    <onright>211</onright>
                    <onleft>208</onleft>
                    <ondown>210</ondown>
                    <onup>206</onup>
                    <font>font12</font>
                    <textcolor>FFFFFFFF</textcolor>
                    <focusedcolor>FF000000</focusedcolor>
                    <align>center</align>
                    <aligny>center</aligny>
                    <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                    <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                    <textoffsetx>0</textoffsetx>
                    <textoffsety>0</textoffsety>
                    <label>[B]9[/B]</label>
                </control>
            </control>
            <control type="button" id="210">
                <posx>0</posx>
                <posy>{{ vscale(180) }}</posy>
                <width>223</width>
                <height>{{ vscale(59) }}</height>
                <onright>211</onright>
                <onup>200</onup>
                <font>font12</font>
                <textcolor>FFFFFFFF</textcolor>
                <focusedcolor>FF000000</focusedcolor>
                <align>center</align>
                <aligny>center</aligny>
                <texturefocus colordiffuse="FFFFFFFF">script.plex/white-square.png</texturefocus>
                <texturenofocus colordiffuse="FF333333">script.plex/white-square.png</texturenofocus>
                <textoffsetx>0</textoffsetx>
                <textoffsety>0</textoffsety>
                <label>[B]0[/B]</label>
            </control>
        </control>
        <control type="button" id="211">
            <posx>225</posx>
            <posy>0</posy>
            <width>75</width>
            <height>{{ vscale(239) }}</height>
            <onleft>300</onleft>
            <onup>101</onup>
            <font>font12</font>
            <textcolor>FFFFFFFF</textcolor>
            <focusedcolor>FF000000</focusedcolor>
            <align>center</align>
            <aligny>center</aligny>
            <texturefocus>script.plex/user_select/backspace.png</texturefocus>
            <texturenofocus>script.plex/user_select/backspace_nf.png</texturenofocus>
            <textoffsetx>0</textoffsetx>
            <textoffsety>0</textoffsety>
            <label> </label>
        </control>
    </control>

</control>

<control type="group">
    <defaultcontrol always="true">201</defaultcontrol>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>{{ vscale(135) }}</height>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>{{ vscale(135) }}</height>
        <texture>script.plex/white-square.png</texture>
        <colordiffuse>19000000</colordiffuse>
    </control>

    <control type="grouplist">
        <posx>60</posx>
        <posy>{{ vscale(34.5) }}</posy>
        <width>1000</width>
        <height>{{ vscale(66) }}</height>
        <align>left</align>
        <itemgap>60</itemgap>
        <orientation>horizontal</orientation>
        <ondown>101</ondown>
        <usecontrolcoords>true</usecontrolcoords>
        <control type="group">
            <posx>0</posx>
            <posy>0</posy>
            <width>124</width>
            <height>{{ vscale(66) }}</height>
            <control type="button" id="500">
                <posx>0</posx>
                <posy>0</posy>
                <width>124</width>
                <height>{{ vscale(66) }}</height>
                <ondown>101</ondown>
                <onright>101</onright>
                <align>right</align>
                <aligny>center</aligny>
                <texturefocus colordiffuse="FFFFFFFF" border="10">script.plex/white-square-rounded.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <label> </label>
            </control>
            <control type="image">
                <visible>!String.IsEmpty(Window.Property(dropdown))</visible>
                <posx>0</posx>
                <posy>0</posy>
                <width>124</width>
                <height>{{ vscale(66) }}</height>
                <texture colordiffuse="FFFFFFFF" border="10">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="group">
                <posx>27</posx>
                <posy>{{ vscale(13) }}</posy>
                <control type="group">
                    <visible>!Control.HasFocus(500) + String.IsEmpty(Window.Property(dropdown))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>40</width>
                        <height>{{ vscale(40) }}</height>
                        <texture colordiffuse="99FFFFFF">script.plex/buttons/power.png</texture>
                    </control>
                    <control type="image">
                        <posx>55</posx>
                        <posy>{{ vscale(13.5) }}</posy>
                        <width>15</width>
                        <height>{{ vscale(13) }}</height>
                        <texture colordiffuse="99FFFFFF">script.plex/indicators/dropdown-triangle.png</texture>
                    </control>
                </control>
                <control type="group">
                    <visible>Control.HasFocus(500) | !String.IsEmpty(Window.Property(dropdown))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <control type="image">
                        <posx>0</posx>
                        <posy>0</posy>
                        <width>40</width>
                        <height>{{ vscale(40) }}</height>
                        <texture colordiffuse="FF000000">script.plex/buttons/power.png</texture>
                    </control>
                    <control type="image">
                        <posx>55</posx>
                        <posy>{{ vscale(13.5) }}</posy>
                        <width>15</width>
                        <height>{{ vscale(13) }}</height>
                        <texture colordiffuse="FF000000">script.plex/indicators/dropdown-triangle.png</texture>
                    </control>
                </control>
            </control>
        </control>
        <control type="label">
            <posx>-27</posx>
            <posy>0</posy>
            <width max="500">auto</width>
            <height>{{ vscale(66) }}</height>
            <font>font12</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35032]</label>
        </control>
    </control>

    <control type="label">
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
</control>

<control type="group">
    <visible>!String.IsEmpty(Window.Property(busy))</visible>
    <animation effect="fade" start="0" end="100">Visible</animation>
    <control type="image">
        <posx>840</posx>
        <posy>{{ vperc(vscale(150)) }}</posy>
        <width>240</width>
        <height>{{ vscale(150) }}</height>
        <texture>script.plex/busy-back.png</texture>
        <colordiffuse>A0FFFFFF</colordiffuse>
    </control>
    <control type="image">
        <posx>915</posx>
        <posy>{{ vperc(vscale(38)) }}</posy>
        <width>90</width>
        <height>{{ vscale(38) }}</height>
        <texture diffuse="script.plex/busy-diffuse.png">script.plex/busy.gif</texture>
    </control>
</control>
{% endblock controls %}
