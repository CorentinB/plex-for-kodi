{% extends "base.xml.tpl" %}
{% block headers %}
    <defaultcontrol>800</defaultcontrol>
    <zorder>100</zorder>
{% endblock %}
{% block backgroundcolor %}{% endblock %}

{% block controls %}
<control type="group" id="804">
    <visible>!String.IsEmpty(Window.Property(show.blackout))</visible>
    <animation effect="fade" time="200" delay="200" end="0">Hidden</animation>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>1920</width>
        <height>1080</height>
        <texture>script.plex/white-square.png</texture>
        <colordiffuse>FF000000</colordiffuse>
    </control>
</control>

<control type="group" id="802">
    <!-- This is the buttonless OSD -->
    <visible>[!String.IsEmpty(Window.Property(show.OSD)) | [String.IsEmpty(Window.Property(is_plextuary)) + Window.IsVisible(seekbar)] | !String.IsEmpty(Window.Property(button.seek))] + !Window.IsVisible(osdvideosettings) + !Window.IsVisible(osdaudiosettings) + !Window.IsVisible(osdsubtitlesettings) + !Window.IsVisible(subtitlesearch) + !Window.IsActive(playerprocessinfo) + !Window.IsActive(selectdialog) + !Window.IsVisible(osdcmssettings)</visible>
    <animation effect="fade" time="200" delay="200" end="0">Hidden</animation>
    <control type="group">
        <visible>String.IsEmpty(Window.Property(is_plextuary)) + String.IsEmpty(Window.Property(settings.visible)) + [Window.IsVisible(seekbar) | Window.IsVisible(videoosd) | Player.ShowInfo]</visible>
        <animation effect="fade" start="100" end="0">Hidden</animation>
        <posx>0</posx>
        <posy>0</posy>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>1080</height>
            <texture>script.plex/player-fade.png</texture>
            <colordiffuse>FF080808</colordiffuse>
        </control>
    </control>

    <control type="group">
        <posx>0</posx>
        <posy>0</posy>
        <control type="image">
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(140) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>A0000000</colordiffuse>
        </control>
        <control type="image">
            <visible>String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))</visible>
            <posx>0</posx>
            <posy>{{ vscale(140) }}r</posy>
            <width>1920</width>
            <height>{{ vscale(140) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>A0000000</colordiffuse>
        </control>
    </control>

    <control type="group">
        <posx>0</posx>
        <posy>{{ vscale(40) }}</posy>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(is.show)) + String.IsEmpty(Window.Property(hide.title))</visible>
            <posx>60</posx>
            <posy>0</posy>
            <width>1580</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>[B]$INFO[VideoPlayer.TVShowTitle][/B]$INFO[VideoPlayer.Title, &#8226; ]$INFO[Window.Property(ep.season), &#8226; ]$INFO[Window.Property(ep.episode), &#8226; ]$INFO[Window.Property(ep.year), &#8226; ]</label>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(is.show)) + !String.IsEmpty(Window.Property(hide.title))</visible>
            <posx>60</posx>
            <posy>0</posy>
            <width>1580</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>[B]$INFO[VideoPlayer.TVShowTitle][/B]$INFO[Window.Property(ep.season), &#8226; ]$INFO[Window.Property(ep.episode), &#8226; ]$INFO[Window.Property(ep.year), &#8226; ]</label>
        </control>
        <control type="label">
            <visible>String.IsEmpty(Window.Property(is.show))</visible>
            <posx>60</posx>
            <posy>0</posy>
            <width>1580</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>[B]$INFO[VideoPlayer.Title][/B]$INFO[VideoPlayer.Year, &#8226; ]</label>
        </control>
        <control type="label">
            <posx>1660</posx>
            <posy>0</posy>
            <width>200</width>
            <height>{{ vscale(60) }}</height>
            <font>font12</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[System.Time]</label>
        </control>
    </control>

    <control type="group">
        <posx>0</posx>
        <posy>{{ vscale(320) }}r</posy>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>60</posx>
            <posy>0</posy>
            <width>1000</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Player.Time($INFO[Window.Property(time.fmt)])]</label>
        </control>
        <control type="label">
            <visible>String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>60</posx>
            <posy>0</posy>
            <width>1000</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(time.current)]</label>
        </control>
        <control type="label">
            <visible>Player.IsTempo</visible>
            <posx>60</posx>
            <posy>{{ vscale(40) }}</posy>
            <width>1000</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>A0FFFFFF</textcolor>
            <label>$INFO[Player.PlaySpeed]x</label>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>1860</posx>
            <posy>0</posy>
            <width>800</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Player.TimeRemaining($INFO[Window.Property(time.fmt)])]$INFO[Window.Property(time.add)]</label>
        </control>
        <control type="label">
            <visible>String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>1860</posx>
            <posy>0</posy>
            <width>800</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(time.left)]</label>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(media.show_ends)) + !String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>1860</posx>
            <posy>{{ vscale(40) }}</posy>
            <width>800</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>A0FFFFFF</textcolor>
            <label>$INFO[Window.Property(time.ends_label)] $INFO[Player.FinishTime($INFO[Window.Property(time.fmt.ends)])]</label>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(media.show_ends)) + String.IsEmpty(Window.Property(direct.play)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>1860</posx>
            <posy>{{ vscale(40) }}</posy>
            <width>800</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>right</align>
            <aligny>center</aligny>
            <textcolor>A0FFFFFF</textcolor>
            <label>$INFO[Window.Property(time.ends_label)] $INFO[Window.Property(time.end)]</label>
        </control>
        <!--<control type="label">
            <visible>Player.Paused + String.IsEmpty(Window.Property(show.OSD))</visible>
            <animation effect="fade" time="200" delay="200" end="100">Visible</animation>
            <posx>0</posx>
            <posy>{{ vscale(20) }}</posy>
            <width>1920</width>
            <height>{{ vscale(60) }}</height>
            <font>font13</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>[UPPERCASE]$ADDON[script.plexmod 32436][/UPPERCASE]</label>
        </control>-->
    </control>

    <control type="group">
        <posx>0</posx>
        <posy>{{ vscale(190) }}r</posy>
        <control type="image">
            <visible>String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(10) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>A0000000</colordiffuse>
        </control>
        <control type="image" id="206">
            <visible>!String.IsEmpty(Window.Property(show.buffer)) + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>0</posx>
            <posy>2</posy>
            <width>1</width>
            <height>{{ vscale(6) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>EE4E4842</colordiffuse>
        </control>
        <control type="image" id="201">
            <visible>String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))</visible>
            <posx>0</posx>
            <posy>2</posy>
            <width>1</width>
            <height>{{ vscale(6) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>FFFFFFFF</colordiffuse>
        </control>
        <control type="image" id="200">
            <visible>[Control.HasFocus(100) | !String.IsEmpty(Window.Property(button.seek))] + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
            <posx>0</posx>
            <posy>2</posy>
            <width>1</width>
            <height>{{ vscale(6) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>FFFFFFFF</colordiffuse>
        </control>
    </control>
</control>
<control type="button" id="800">
    <visible allowhiddenfocus="true">String.IsEmpty(Window.Property(show.OSD))</visible>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>1080</height>
    <texturefocus>script.plex/transparent-6px.png</texturefocus>
    <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
    <label> </label>
    <onclick condition="String.IsEmpty(Window.Property(button.seek)) + String.IsEmpty(Window.Property(marker.countdown)) + !String.IsEmpty(Window.Property(mouse.mode))">SetProperty(show.OSD,1)</onclick>
</control>

<!-- PPI -->
<control type="group" id="803">
    <bottom>0</bottom>
    <height>{{ vscale(350) }}</height>
    <visible>!String.IsEmpty(Window.Property(show.PPI)) + String.IsEmpty(Window.Property(settings.visible)) + String.IsEmpty(Window.Property(playlist.visible))</visible>
    <animation effect="fade" start="0" end="100" time="300">Visible</animation>
    <animation effect="fade" start="100" end="0" time="200">Hidden</animation>
    <control type="image">
        <left>10</left>
        <top>{{ vscale(-220) }}</top>
        <right>10</right>
        <height>{{ vscale(420) }}</height>
        <texture border="40">buttons/dialogbutton-nofo.png</texture>
    </control>
    <control type="grouplist">
        <left>52</left>
        <top>{{ vscale(-184) }}</top>
        <width>1786</width>
        <height>{{ vscale(350) }}</height>
        <orientation>horizontal</orientation>
        <itemgap>10</itemgap>
        <control type="grouplist">
            <left>0</left>
            <top>0</top>
            <width>793</width>
            <control type="label">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Player.Process(videodecoder),[COLOR BFFFFFFF]$LOCALIZE[31139]:[/COLOR] ]$VAR[VideoHWDecoder, (,)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo</visible>
            </control>
            <control type="label">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Player.Process(pixformat),[COLOR BFFFFFFF]$LOCALIZE[31140]:[/COLOR] ]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo</visible>
            </control>
            <control type="label">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Player.Process(deintmethod),[COLOR BFFFFFFF]$LOCALIZE[16038]:[/COLOR] ]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo</visible>
            </control>
            <control type="label">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Player.Process(videowidth),[COLOR BFFFFFFF]$LOCALIZE[38031]:[/COLOR] ,x]$INFO[Player.Process(videoheight),, px]$INFO[Player.Process(videodar),$COMMA , AR]$INFO[Player.Process(videofps),$COMMA , FPS]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo</visible>
            </control>
            <control type="textbox">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <autoscroll delay="1000" time="1000" repeat="2000"></autoscroll>
                <label>[COLOR BFFFFFFF]$LOCALIZE[460]:[/COLOR] $INFO[Player.Process(audiochannels),,$COMMA ]$INFO[Player.Process(audiodecoder)]$INFO[Player.Process(audiobitspersample),$COMMA , bits]$INFO[Player.Process(audiosamplerate),$COMMA , Hz]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
            </control>
            <control type="label">
                <width>793</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[System.Memory(used.percent),[COLOR BFFFFFFF]$LOCALIZE[31030]:[/COLOR] ,]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
            </control>
        </control>
        <control type="grouplist">
            <left>0</left>
            <top>0</top>
            <height>{{ vscale(350) }}</height>
            <width>993</width>
            <control type="label">
                <width>963</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Window.Property(ppi.Status)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.Status))</visible>
            </control>
            <control type="label">
                <width>963</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Mode:[/COLOR] $INFO[Window.Property(ppi.Mode)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.Mode))</visible>
            </control>
            <control type="label">
                <width>963</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Container:[/COLOR] $INFO[Window.Property(ppi.Container)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.Container))</visible>
            </control>
            <control type="textbox">
                <width>963</width>
                <autoscroll delay="1000" time="1000" repeat="2000"></autoscroll>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Video:[/COLOR] $INFO[Window.Property(ppi.Video)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.Video))</visible>
            </control>
            <control type="textbox">
                <width>963</width>
                <autoscroll delay="1000" time="1000" repeat="2000"></autoscroll>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>$INFO[Window.Property(ppi.Audio),[COLOR BFFFFFFF]Audio:[/COLOR] ]$INFO[Window.Property(ppi.Subtitles),   [COLOR BFFFFFFF]Subtitle:[/COLOR] ]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + [!String.IsEmpty(Window.Property(ppi.Audio)) | !String.IsEmpty(Window.Property(ppi.Subtitles))]</visible>
            </control>
            <control type="textbox">
                <width>963</width>
                <autoscroll delay="1000" time="1000" repeat="2000"></autoscroll>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Server:[/COLOR] $INFO[Window.Property(ppi.User)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.User))</visible>
            </control>
            <control type="label">
                <width>963</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Buffer:[/COLOR] $INFO[Player.CacheLevel]%$INFO[Window.Property(ppi.BufferMB), (of ~, MB]$INFO[Window.Property(ppi.ReadFactor),$COMMA Readfactor: ,x)]$INFO[Window.Property(ppi.AReadFactor),$COMMA Readfactor: ,)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + String.IsEmpty(Window.Property(ppi.Buffered))</visible>
            </control>
            <control type="label">
                <width>963</width>
                <height>{{ vscale(50) }}</height>
                <aligny>bottom</aligny>
                <label>[COLOR BFFFFFFF]Buffer:[/COLOR] $INFO[Window.Property(ppi.Buffered)]% (% of Video cached)$INFO[Window.Property(ppi.BufferMB), (of ~, MB]$INFO[Window.Property(ppi.ReadFactor),$COMMA Readfactor:,x)]$INFO[Window.Property(ppi.AReadFactor),$COMMA Readfactor: ,)]</label>
                <font>font14</font>
                <shadowcolor>black</shadowcolor>
                <visible>Player.HasVideo + !String.IsEmpty(Window.Property(ppi.Buffered))</visible>
            </control>
        </control>
    </control>
    <control type="label">
        <left>52</left>
        <top>{{ vscale(120) }}</top>
        <width>1786</width>
        <height>{{ vscale(50) }}</height>
        <aligny>bottom</aligny>
        <label>$INFO[System.CpuUsage,[COLOR BFFFFFFF]$LOCALIZE[13271][/COLOR] ]</label>
        <font>font14</font>
        <shadowcolor>black</shadowcolor>
    </control>
</control>
<control type="group" id="300">
    <visible>!String.IsEmpty(Window.Property(has.bif)) + !String.IsEmpty(Window.Property(bif.image)) + String.IsEmpty(Window.Property(show.chapters)) + [Control.HasFocus(100) | Control.HasFocus(501) | !String.IsEmpty(Window.Property(button.seek))] + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))] </visible>
    <animation effect="fade" time="100" delay="100" end="100">Visible</animation>
    <posx>0</posx>
    <posy>592</posy>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>324</width>
        <height>{{ vscale(184) }}</height>
        <texture colordiffuse="E60B0B0B" border="20">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <posx>2</posx>
        <posy>2</posy>
        <width>320</width>
        <height>{{ vscale(180) }}</height>
        <fadetime>10</fadetime>
        <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[Window.Property(bif.image)]</texture>
        <aspectratio>scale</aspectratio>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>324</width>
        <height>{{ vscale(184) }}</height>
        <texture>script.plex/landscape-search-rounded-outline.png</texture>
    </control>
</control>
<control type="group" id="801">
    <!-- This is the OSD with buttons -->
    <visible>!String.IsEmpty(Window.Property(show.OSD)) + !Window.IsVisible(osdvideosettings) + !Window.IsVisible(osdaudiosettings) + !Window.IsVisible(osdsubtitlesettings) + !Window.IsVisible(subtitlesearch) + !Window.IsActive(playerprocessinfo) + !Window.IsActive(selectdialog) + !Window.IsVisible(osdcmssettings)</visible>
    <animation effect="fade" time="200" delay="200" end="0">Hidden</animation>

    <control type="group" id="440">
        <posx>0</posx>
        <posy>{{ vscale(910) }}</posy>
        <control type="label">
            <visible>Control.HasFocus(401)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32934]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(402)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32935]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(403)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32925]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(404)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$LOCALIZE[210]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(405)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>-10 s</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(406) + !Player.Paused + !Player.Forwarding + !Player.Rewinding</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$LOCALIZE[36045]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(406) + [Player.Paused | Player.Forwarding | Player.Rewinding]</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$LOCALIZE[208]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(407)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$LOCALIZE[36044]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(408)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>+30 s</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(409)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$LOCALIZE[209]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(410)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 35036]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(412)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>$ADDON[script.plexmod 32396]</label>
        </control>
        <control type="label">
            <visible>Control.HasFocus(413)</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(38) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>D9FFFFFF</textcolor>
            <label>VS10</label>
        </control>
    </control>

    <control type="grouplist" id="400">
        <defaultcontrol>406</defaultcontrol>
        <hitrect x="460" y="998" w="1000" h="55" />
        <posx>120</posx>
        <posy>{{ vscale(122) }}r</posy>
        <width>1680</width>
        <height>{{ vscale(124) }}</height>
        <align>center</align>
        <onup>100</onup>
        <itemgap>-26</itemgap>
        <orientation>horizontal</orientation>
        <scrolltime tween="quadratic" easing="out">200</scrolltime>
        <usecontrolcoords>true</usecontrolcoords>
        <control type="group" id="421">
            <visible>!String.IsEmpty(Window.Property(nav.repeat))</visible>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <control type="button" id="401">
                <hitrect x="28" y="28" w="69" h="45" />
                <posx>0</posx>
                <posy>0</posy>
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>100</onup>
                <onright>402</onright>
                <onleft condition="Control.IsVisible(413)">413</onleft>
                <onleft condition="!Control.IsVisible(413) + Control.IsVisible(412)">412</onleft>
                <onleft condition="!Control.IsVisible(413) + !Control.IsVisible(412) + Control.IsVisible(410)">410</onleft>
                <onleft condition="!Control.IsVisible(413) + !Control.IsVisible(412) + !Control.IsVisible(410) + Control.IsVisible(409)">409</onleft>
                <onleft condition="!Control.IsVisible(413) + !Control.IsVisible(412) + !Control.IsVisible(410) + !Control.IsVisible(409) + Control.IsVisible(408)">408</onleft>
                <onleft>407</onleft>
                <ondown>501</ondown>
                <font>font12</font>
                <texturefocus>script.plex/transparent-6px.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <label> </label>
            </control>
            <control type="group">
                <visible>!Control.HasFocus(401)</visible>
                <ondown>501</ondown>
                <control type="image">
                    <visible>!Playlist.IsRepeatOne + !Playlist.IsRepeat + String.IsEmpty(Window.Property(pq.repeat))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}repeat.png</texture>
                </control>
                <control type="image">
                    <visible>Playlist.IsRepeat | !String.IsEmpty(Window.Property(pq.repeat))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}repeat.png</texture>
                </control>
                <control type="image">
                    <visible>Playlist.IsRepeatOne | !String.IsEmpty(Window.Property(pq.repeat.one))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}repeat-one.png</texture>
                </control>
            </control>
            <control type="group">
                <visible>Control.HasFocus(401)</visible>
                <ondown>501</ondown>
                <control type="image">
                    <visible>!Playlist.IsRepeatOne + !Playlist.IsRepeat + String.IsEmpty(Window.Property(pq.repeat))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat{{ theme.assets.buttons.focusSuffix }}.png</texture>
                </control>
                <control type="image">
                    <visible>Playlist.IsRepeat | !String.IsEmpty(Window.Property(pq.repeat))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat{{ theme.assets.buttons.focusSuffix }}.png</texture>
                </control>
                <control type="image">
                    <visible>Playlist.IsRepeatOne | !String.IsEmpty(Window.Property(pq.repeat.one))</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}repeat-one{{ theme.assets.buttons.focusSuffix }}.png</texture>
                </control>
            </control>
        </control>

        <control type="togglebutton" id="402">
            <visible>!String.IsEmpty(Window.Property(has.playlist)) + !String.IsEmpty(Window.Property(nav.shuffle))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}shuffle.png</texturenofocus>
            <usealttexture>!String.IsEmpty(Window.Property(pq.shuffled))</usealttexture>
            <alttexturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</alttexturefocus>
            <alttexturenofocus colordiffuse="FFFFFFFF">{{ theme.assets.buttons.base }}shuffle.png</alttexturenofocus>
            <label> </label>
        </control>
        <control type="button" id="422">
            <enable>false</enable>
            <visible>String.IsEmpty(Window.Property(has.playlist)) + !String.IsEmpty(Window.Property(nav.shuffle))</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.focusBase }}shuffle{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}shuffle.png</texturenofocus>
            <label> </label>
        </control>

        <control type="button" id="403">
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}settings{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}settings.png</texturenofocus>
            <label> </label>
        </control>

        <control type="group" id="423">
            <width>38</width>
            <height>{{ vscale(101) }}</height>
        </control>

        <control type="button" id="404">
            <visible>!String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.prevnext))</visible>
            <hitrect x="58" y="28" w="69" h="45" />
            <posx>30</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus flipx="true"{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus flipx="true"{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="424">
            <enable>false</enable>
            <visible>String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.prevnext))</visible>
            <posx>30</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus flipx="true" colordiffuse="40FFFFFF">{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus flipx="true" colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="405">
            <visible>!String.IsEmpty(Window.Property(nav.ffwdrwd))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus flipx="true" colordiffuse="FFFFFFFF">{{ theme.assets.buttons.focusBase }}skip-forward{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus flipx="true"{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}skip-forward.png</texturenofocus>
            <label> </label>
        </control>

        <control type="group" id="426">
            {% if theme.buttons.zoomPlayButton %}
                <animation effect="zoom" start="100" end="106" time="110" center="63,{{ vscale(50) }}" reversible="true" condition="Control.HasFocus(406)">Conditional</animation>
            {% endif %}
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <control type="button" id="406">
                <hitrect x="28" y="28" w="69" h="45" />
                <posx>0</posx>
                <posy>0</posy>
                <width>125</width>
                <height>{{ vscale(101) }}</height>
                <onup>100</onup>
                <onright>407</onright>
                <onleft condition="!String.IsEmpty(Window.Property(nav.ffwdrwd))">405</onleft>
                <onleft condition="String.IsEmpty(Window.Property(nav.ffwdrwd)) + !String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.prevnext))">404</onleft>
                <onleft condition="String.IsEmpty(Window.Property(nav.ffwdrwd)) + [String.IsEmpty(Window.Property(pq.hasprev)) | String.IsEmpty(Window.Property(nav.prevnext))]">403</onleft>
                <ondown>501</ondown>
                <font>font12</font>
                <texturefocus>script.plex/transparent-6px.png</texturefocus>
                <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
                <label> </label>
                <onclick>PlayerControl(Play)</onclick>
            </control>
            <control type="group">
                <ondown>501</ondown>
                <visible>!Control.HasFocus(406)</visible>
                <control type="image">
                    <visible>!Player.Paused + !Player.Forwarding + !Player.Rewinding</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pause.png</texture>
                </control>
                <control type="image">
                    <visible>Player.Paused | Player.Forwarding | Player.Rewinding</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}play.png</texture>
                </control>
            </control>
            <control type="group">
                <ondown>501</ondown>
                <visible>Control.HasFocus(406)</visible>
                <control type="image">
                    <visible>!Player.Paused + !Player.Forwarding + !Player.Rewinding</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}pause{{ theme.assets.buttons.focusSuffix }}.png</texture>
                </control>
                <control type="image">
                    <visible>Player.Paused | Player.Forwarding | Player.Rewinding</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>125</width>
                    <height>{{ vscale(101) }}</height>
                    <texture{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}play{{ theme.assets.buttons.focusSuffix }}.png</texture>
                </control>
            </control>
        </control>

        <control type="button" id="407">
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}stop{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}stop.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="408">
            <visible>!String.IsEmpty(Window.Property(nav.ffwdrwd))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}skip-forward{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}skip-forward.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="409">
            <visible>!String.IsEmpty(Window.Property(pq.hasnext)) + !String.IsEmpty(Window.Property(nav.prevnext))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}next.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="419">
            <enable>false</enable>
            <visible>String.IsEmpty(Window.Property(pq.hasnext)) + !String.IsEmpty(Window.Property(nav.prevnext))</visible>
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <ondown>501</ondown>
            <texturefocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.focusBase }}next{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}next.png</texturenofocus>
            <label> </label>
        </control>

        <control type="group" id="425">
            <width>38</width>
            <height>{{ vscale(101) }}</height>
        </control>

        <control type="button" id="410">
            <visible>[!String.IsEmpty(Window.Property(pq.hasnext)) | !String.IsEmpty(Window.Property(pq.hasprev))] + !String.IsEmpty(Window.Property(nav.playlist))</visible>
            <hitrect x="58" y="28" w="69" h="45" />
            <posx>30</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}pqueue{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}pqueue.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="430">
            <enable>false</enable>
            <visible>String.IsEmpty(Window.Property(pq.hasnext)) + String.IsEmpty(Window.Property(pq.hasprev)) + !String.IsEmpty(Window.Property(nav.playlist))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>30</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.focusBase }}pqueue{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus colordiffuse="40FFFFFF">{{ theme.assets.buttons.base }}pqueue.png</texturenofocus>
            <label> </label>
        </control>
        <control type="button" id="412">
            <visible>!String.IsEmpty(Window.Property(nav.quick_subtitles))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus{% if theme.buttons.useFocusColor %} colordiffuse="{{ theme.buttons.focusColor|default("FFFFFFFF") }}"{% endif %}>{{ theme.assets.buttons.focusBase }}subtitle{{ theme.assets.buttons.focusSuffix }}.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>{{ theme.assets.buttons.base }}subtitle.png</texturenofocus>
            <label> </label>
        </control>

        <!-- VS10 mode switcher - CoreELEC/Amlogic only. Visibility controlled via nav.vs10 window property
             set in seekdialog.py. To restrict to CoreELEC hardware once tested, change the Python side:
             self.setBoolProperty('nav.vs10', xbmc.getCondVisibility('System.AddonIsEnabled(service.coreelec.settings)')) -->
        <control type="button" id="413">
            <visible>!String.IsEmpty(Window.Property(nav.vs10))</visible>
            <hitrect x="28" y="28" w="69" h="45" />
            <posx>0</posx>
            <posy>0</posy>
            <width>125</width>
            <height>{{ vscale(101) }}</height>
            <font>font12</font>
            <ondown>501</ondown>
            <texturefocus>script.plex/buttons/player/modern-focused/vs10.png</texturefocus>
            <texturenofocus{% if theme.buttons.useNoFocusColor %} colordiffuse="{{ theme.buttons.noFocusColor|default('99FFFFFF') }}"{% endif %}>script.plex/buttons/player/modern/vs10.png</texturenofocus>
            <label> </label>
        </control>
    </control>

    <control type="group">
        <posx>0</posx>
        <posy>890</posy>
        <control type="button" id="100">
            <hitrect x="0" y="-19" w="1920" h="48" />
            <posx>0</posx>
            <posy>0</posy>
            <width>1920</width>
            <height>{{ vscale(10) }}</height>
            <onup>501</onup>
            <ondown>400</ondown>
            <texturefocus>script.plex/transparent-6px.png</texturefocus>
            <texturenofocus>script.plex/transparent-6px.png</texturenofocus>
        </control>
    </control>

    <control type="group" id="500">
        <animation effect="slide" time="100" start="0,0" end="0,{{ vscale(20) }}" reversible="true" condition="Control.HasFocus(501) + String.IsEmpty(Window.Property(has.chapters))">Conditional</animation>

        <!-- CHAPTERS -->
        <animation effect="slide" time="100" start="0,0" end="0,{{ vscale(-60) }}" reversible="true" condition="Control.HasFocus(501) + !String.IsEmpty(Window.Property(has.chapters)) + !String.IsEmpty(Window.Property(show.chapters))">Conditional</animation>
        <!-- /CHAPTERS -->

        <visible>String.IsEmpty(Window.Property(mouse.mode)) + String.IsEmpty(Window.Property(hide.bigseek)) + [Control.HasFocus(501) | Control.HasFocus(100)] + [!String.IsEmpty(Window.Property(show.chapters)) | String.IsEmpty(Window.Property(has.chapters))]</visible>
        <posx>-8</posx>
        <posy>867</posy>
        <control type="image">
            <posx>-200</posx>
            <posy>5</posy>
            <width>2320</width>
            <height>{{ vscale(6) }}</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>A0000000</colordiffuse>
            <visible>String.IsEmpty(Window.Property(has.chapters))</visible>
        </control>
        <!-- CHAPTERS -->
        <control type="image">
            <posx>0</posx>
            <posy>-175</posy>
            <width>1928</width>
            <height>200</height>
            <texture>script.plex/white-square.png</texture>
            <colordiffuse>A0000000</colordiffuse>
            <visible>!String.IsEmpty(Window.Property(has.chapters))</visible>
        </control>
        <control type="label">
            <posx>40</posx>
            <posy>-162</posy>
            <width>auto</width>
            <height>{{ vscale(20) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>CC606060</textcolor>
            <label>$INFO[Window.Property(chapters.label)]</label>
            <visible>!String.IsEmpty(Window.Property(has.chapters)) + !Control.HasFocus(501)</visible>
        </control>
        <control type="label">
            <posx>40</posx>
            <posy>-162</posy>
            <width>auto</width>
            <height>{{ vscale(20) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(chapters.label)]</label>
            <visible>!String.IsEmpty(Window.Property(has.chapters)) + Control.HasFocus(501)</visible>
        </control>
        <!-- /CHAPTERS -->
        <control type="list" id="501">
            <hitrect x="-20" y="-20" w="10" h="10" />
            <posx>0</posx>
            <posy>0</posy>
            <width>1928</width>
            <height>{{ vscale(16) }}</height>
            <ondown>100</ondown>
            <onfocus>SetProperty(hide.bigseek,)</onfocus>
            <scrolltime>200</scrolltime>
            <orientation>horizontal</orientation>
            <preloaditems>4</preloaditems>
            <!-- ITEM LAYOUT ########################################## -->
            <itemlayout width="160" condition="String.IsEmpty(Window.Property(has.chapters))">
                <control type="image">
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>16</width>
                    <height>{{ vscale(16) }}</height>
                    <texture>script.plex/indicators/seek-selection-marker.png</texture>
                    <colordiffuse>FF606060</colordiffuse>
                </control>
            </itemlayout>

            <!-- FOCUSED LAYOUT ####################################### -->
            <focusedlayout width="160" condition="String.IsEmpty(Window.Property(has.chapters))">
                <control type="image">
                    <visible>!Control.HasFocus(501)</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>16</width>
                    <height>{{ vscale(16) }}</height>
                    <texture>script.plex/indicators/seek-selection-marker.png</texture>
                    <colordiffuse>FF606060</colordiffuse>
                </control>
                <control type="image">
                    <visible>Control.HasFocus(501)</visible>
                    <posx>0</posx>
                    <posy>0</posy>
                    <width>16</width>
                    <height>{{ vscale(16) }}</height>
                    <texture>script.plex/indicators/seek-selection-marker.png</texture>
                    <colordiffuse>FFFFFFFF</colordiffuse>
                </control>
            </focusedlayout>

            <!-- ITEM LAYOUT CHAPTERS ########################################## -->
            <itemlayout width="218" condition="!String.IsEmpty(Window.Property(has.chapters))">
                <control type="group">
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">script.plex/thumb_fallbacks/movie16x9.png</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>CC606060</colordiffuse>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>DDAAAAAA</colordiffuse>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">script.plex/thumb_fallbacks/movie16x9.png</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>FFAAAAAA</colordiffuse>
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>FFAAAAAA</colordiffuse>
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                    <control type="label">
                        <posx>40</posx>
                        <posy>{{ vscale(120) }}</posy>
                        <width>auto</width>
                        <height>{{ vscale(10) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>CC606060</textcolor>
                        <label>$INFO[ListItem.Label]</label>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="label">
                        <posx>40</posx>
                        <posy>{{ vscale(120) }}</posy>
                        <width>auto</width>
                        <height>{{ vscale(10) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFAAAAAA</textcolor>
                        <label>$INFO[ListItem.Label]</label>
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                </control>
            </itemlayout>

            <!-- FOCUSED LAYOUT CHAPTERS ####################################### -->
            <focusedlayout width="218" condition="!String.IsEmpty(Window.Property(has.chapters))">
                <control type="group">
                    <animation effect="slide" time="100" start="0,0" end="0,{{ vscale(-10) }}" reversible="true">Focus</animation>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">script.plex/thumb_fallbacks/movie16x9.png</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>CC909090</colordiffuse>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
                        <colordiffuse>FF666666</colordiffuse>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">script.plex/thumb_fallbacks/movie16x9.png</texture>
                        <aspectratio>scale</aspectratio>
<!--                                <colordiffuse>FF606060</colordiffuse>-->
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <posx>40</posx>
                        <posy>0</posy>
                        <width>178</width>
                        <height>{{ vscale(100) }}</height>
                        <texture diffuse="script.plex/landscape-rounded-mask.png">$INFO[ListItem.Thumb]</texture>
                        <aspectratio>scale</aspectratio>
<!--                                <colordiffuse>FFFFFFFF</colordiffuse>-->
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                    <control type="image">
                        <visible>Control.HasFocus(501)</visible>
                        <posx>38</posx>
                        <posy>{{ vscale(-2) }}</posy>
                        <width>182</width>
                        <height>{{ vscale(104) }}</height>
                        <texture>script.plex/landscape-search-rounded-outline.png</texture>
                    </control>
                    <control type="label">
                        <posx>40</posx>
                        <posy>{{ vscale(120) }}</posy>
                        <width>auto</width>
                        <height>{{ vscale(10) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
                        <textcolor>FFDDDDDD</textcolor>
                        <label>$INFO[ListItem.Label]</label>
                        <visible>!Control.HasFocus(501)</visible>
                    </control>
                    <control type="label">
                        <posx>40</posx>
                        <posy>{{ vscale(120) }}</posy>
                        <width>auto</width>
                        <height>{{ vscale(10) }}</height>
                        <font>font10</font>
                        <align>center</align>
                        <aligny>center</aligny>
<!--                                <textcolor>FFFFFFFF</textcolor>-->
                        <label>[B]$INFO[ListItem.Label][/B]</label>
                        <visible>Control.HasFocus(501)</visible>
                    </control>
                </control>
            </focusedlayout>
        </control>
    </control>
</control>
<control type="group" id="202">
    <visible>[Control.HasFocus(100) | Control.HasFocus(501) | !String.IsEmpty(Window.Property(button.seek))] + [String.IsEmpty(Window.Property(no.osd.hide_info)) | !String.IsEmpty(Window.Property(show.OSD))]</visible>
    <posx>0</posx>
    <posy>846</posy>
    <control type="group" id="203">
        <posx>-50</posx>
        <posy>0</posy>
        <control type="image" id="204">
            <animation effect="fade" time="100" delay="100" end="100">Visible</animation>
            <posx>0</posx>
            <posy>0</posy>
            <width>101</width>
            <height>{{ vscale(39) }}</height>
            <texture>script.plex/indicators/player-selection-time_box.png</texture>
            <colordiffuse>D0000000</colordiffuse>
        </control>
        <control type="label" id="205">
            <posx>0</posx>
            <posy>0</posy>
            <width>101</width>
            <height>{{ vscale(40) }}</height>
            <font>font10</font>
            <align>center</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <label>$INFO[Window.Property(time.selection)]</label>
        </control>
    </control>
    <control type="image">
        <animation effect="fade" time="100" delay="100" end="100">Visible</animation>
        <posx>-6</posx>
        <posy>{{ vscale(39) }}</posy>
        <width>15</width>
        <height>{{ vscale(7) }}</height>
        <texture>script.plex/indicators/player-selection-time_arrow.png</texture>
        <colordiffuse>D0000000</colordiffuse>
    </control>
</control>

<!-- SKIP MARKER BUTTON -->
<control type="grouplist" id="790">
    <visible>!String.IsEmpty(Window.Property(initialized))</visible>
    <posx>1400</posx>
    <posy>{{ vscale(800) }}</posy>
    <width>440</width>
    <height>{{ vscale(72) }}</height>
    <align>right</align>
    <orientation>horizontal</orientation>
    <control type="button" id="791">
        <visible>[!String.IsEmpty(Window.Property(show.markerSkip)) + String.IsEmpty(Window.Property(show.markerSkip_OSDOnly))] | [!String.IsEmpty(Window.Property(show.markerSkip_OSDOnly)) + !String.IsEmpty(Window.Property(show.OSD))]</visible>
        <animation effect="zoom" start="100" end="104" time="110" center="auto" reversible="true">Focus</animation>
        <animation type="Conditional" condition="String.IsEmpty(Window.Property(show.OSD)) + !Window.IsVisible(seekbar)" reversible="false">
            <effect type="slide" end="0,100" time="100" delay="100"></effect>
        </animation>
        <posx>0</posx>
        <posy>0</posy>
        <width min="300" max="440">auto</width>
        <height>{{ vscale(64) }}</height>
        <align>center</align>
        <aligny>center</aligny>
        <font>font12</font>
        <texturefocus colordiffuse="FFF5F5F5" border="22">script.plex/white-square-rounded.png</texturefocus>
        <texturenofocus colordiffuse="2CFFFFFF" border="22">script.plex/white-square-rounded.png</texturenofocus>
        <textcolor>FF000000</textcolor>
        <focusedcolor>FF000000</focusedcolor>
        <disabledcolor>66FFFFFF</disabledcolor>
        <pulseonselect>false</pulseonselect>
        <label>$INFO[Window.Property(skipMarkerName)]</label>
    </control>
</control>
{% endblock controls %}
