	<control type="grouplist">
		<visible>!String.IsEmpty(Window.Property(wl_server_availability_verbose))</visible>
		<posx>160</posx>
		<posy>{{ vscale(324) }}</posy>
		<width>1500</width>
		<height>{{ vscale(38) }}</height>
		<align>left</align>
		<itemgap>15</itemgap>
		<orientation>horizontal</orientation>
		<usecontrolcoords>true</usecontrolcoords>
		<control type="button">
			<width>auto</width>
			<height>{{ vscale(38) }}</height>
			<font>font10</font>
			<align>center</align>
			<aligny>center</aligny>
			<focusedcolor>FFFFFFFF</focusedcolor>
			<textcolor>FFFFFFFF</textcolor>
			<textoffsetx>15</textoffsetx>
			<texturefocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturefocus>
			<texturenofocus colordiffuse="52000000" border="8">script.plex/white-square-rounded-top-padded.png</texturenofocus>
			<label>[UPPERCASE]$ADDON[script.plexmod 32308][/UPPERCASE]</label>
		</control>
		<control type="label">
			<width>1160</width>
			<height>{{ vscale(38) }}</height>
			<font>font10</font>
			<align>left</align>
			<aligny>center</aligny>
			<textcolor>CCFFFFFF</textcolor>
			<scroll>false</scroll>
			<label>$INFO[Window.Property(wl_server_availability_verbose)]</label>
		</control>
	</control>
