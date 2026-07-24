<control type="group">
    <animation effect="slide" end="0,{{ vscale(hero_meta_empty_shift) }}" time="0" condition="String.IsEmpty(Window.Property(home.hero.subtitle))" reversible="true">Conditional</animation>
    <animation effect="slide" end="0,{{ vscale(hero_logo_shift) }}" time="0" condition="!String.IsEmpty(Window.Property(home.hero.logo))" reversible="true">Conditional</animation>
    <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) | !String.IsEmpty(Window.Property(home.hero.meta)) | !String.IsEmpty(Window.Property(home.hero.rating)) | !String.IsEmpty(Window.Property(home.hero.rating2))</visible>
    <posx>0</posx>
    <posy>{{ vscale(hero_meta_y) }}</posy>
    <width>1120</width>
    <height>{{ vscale(hero_meta_height) }}</height>
    <control type="grouplist">
        <posx>0</posx>
        <posy>0</posy>
        <width>1120</width>
        <height>{{ vscale(hero_meta_height) }}</height>
        <align>left</align>
        <itemgap>12</itemgap>
        <orientation>horizontal</orientation>
        <usecontrolcoords>true</usecontrolcoords>
        <control type="group">
            <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) + String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
            <width>86</width>
            <height>{{ vscale(hero_meta_height) }}</height>
            <control type="image">
                <posx>0</posx>
                <posy>{{ vscale(2) }}</posy>
                <width>86</width>
                <height>{{ vscale(28) }}</height>
                <texture border="8" colordiffuse="C0343436">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="label">
                <posx>0</posx>
                <posy>0</posy>
                <width>86</width>
                <height>{{ vscale(hero_meta_height) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>F2FFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Window.Property(home.hero.content_rating)]</label>
            </control>
        </control>
        <control type="group">
            <visible>!String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
            <width>150</width>
            <height>{{ vscale(hero_meta_height) }}</height>
            <control type="image">
                <posx>0</posx>
                <posy>{{ vscale(2) }}</posy>
                <width>150</width>
                <height>{{ vscale(28) }}</height>
                <texture border="8" colordiffuse="C0343436">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="label">
                <posx>0</posx>
                <posy>0</posy>
                <width>150</width>
                <height>{{ vscale(hero_meta_height) }}</height>
                <font>font10</font>
                <align>center</align>
                <aligny>center</aligny>
                <textcolor>F2FFFFFF</textcolor>
                <scroll>false</scroll>
                <label>$INFO[Window.Property(home.hero.content_rating)]</label>
            </control>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(home.hero.meta))</visible>
            <width>auto</width>
            <height>{{ vscale(hero_meta_height) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>DDFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[Window.Property(home.hero.meta)]</label>
        </control>
        <control type="image">
            <visible>!String.IsEmpty(Window.Property(home.hero.rating))</visible>
            <posy>{{ vscale(1) }}</posy>
            <width>63</width>
            <height>{{ vscale(28) }}</height>
            <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(home.hero.rating_image)]</texture>
            <aspectratio align="right">keep</aspectratio>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(home.hero.rating))</visible>
            <width>auto</width>
            <height>{{ vscale(hero_meta_height) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>F2FFFFFF</textcolor>
            <label>$INFO[Window.Property(home.hero.rating)]</label>
        </control>
        <control type="image">
            <visible>!String.IsEmpty(Window.Property(home.hero.rating2))</visible>
            <posy>{{ vscale(1) }}</posy>
            <width>40</width>
            <height>{{ vscale(28) }}</height>
            <texture fallback="script.plex/ratings/other/image.rating.png">$INFO[Window.Property(home.hero.rating2_image)]</texture>
            <aspectratio align="right">keep</aspectratio>
        </control>
        <control type="label">
            <visible>!String.IsEmpty(Window.Property(home.hero.rating2))</visible>
            <width>auto</width>
            <height>{{ vscale(hero_meta_height) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>F2FFFFFF</textcolor>
            <label>$INFO[Window.Property(home.hero.rating2)]</label>
        </control>
    </control>
</control>
