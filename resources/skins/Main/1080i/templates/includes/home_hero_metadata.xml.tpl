<control type="group">
    <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) | !String.IsEmpty(Window.Property(home.hero.meta))</visible>
    <posx>0</posx>
    <posy>{{ vscale(hero_meta_y) }}</posy>
    <width>960</width>
    <height>{{ vscale(hero_meta_height) }}</height>
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) + String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
        <posx>0</posx>
        <posy>{{ vscale(2) }}</posy>
        <width>86</width>
        <height>{{ vscale(28) }}</height>
        <texture border="8" colordiffuse="C0343436">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) + String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
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
    <control type="image">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
        <posx>0</posx>
        <posy>{{ vscale(2) }}</posy>
        <width>150</width>
        <height>{{ vscale(28) }}</height>
        <texture border="8" colordiffuse="C0343436">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating_wide))</visible>
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
    <control type="label">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating)) + String.IsEmpty(Window.Property(home.hero.content_rating_wide)) + !String.IsEmpty(Window.Property(home.hero.meta))</visible>
        <posx>104</posx>
        <posy>0</posy>
        <width>856</width>
        <height>{{ vscale(hero_meta_height) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>DDFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(home.hero.meta)]</label>
    </control>
    <control type="label">
        <visible>!String.IsEmpty(Window.Property(home.hero.content_rating_wide)) + !String.IsEmpty(Window.Property(home.hero.meta))</visible>
        <posx>168</posx>
        <posy>0</posy>
        <width>792</width>
        <height>{{ vscale(hero_meta_height) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>DDFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(home.hero.meta)]</label>
    </control>
    <control type="label">
        <visible>String.IsEmpty(Window.Property(home.hero.content_rating)) + !String.IsEmpty(Window.Property(home.hero.meta))</visible>
        <posx>0</posx>
        <posy>0</posy>
        <width>960</width>
        <height>{{ vscale(hero_meta_height) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>DDFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[Window.Property(home.hero.meta)]</label>
    </control>
</control>
