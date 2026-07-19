<control type="group">
    <visible>!String.IsEmpty(ListItem.Property(nav.width.{{ nav_label_width }})) + String.IsEmpty(ListItem.Property(is.home))</visible>
    <control type="image">
        <visible>Control.HasFocus(101)</visible>
        <posx>-13</posx>
        <posy>{{ vscale(-12) }}</posy>
        <width>{{ nav_shadow_width }}</width>
        <height>{{ vscale(84) }}</height>
        <texture border="42">script.plex/drop-shadow.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>{{ nav_plate_width }}</width>
        <height>{{ vscale(60) }}</height>
        <texture border="24">script.plex/white-square-rounded.png</texture>
        <colordiffuse>EEFFFFFF</colordiffuse>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(is.mapped))</visible>
        <posx>{{ nav_dot_x }}</posx>
        <posy>{{ vscale(10) }}</posy>
        <width>8</width>
        <height>{{ vscale(8) }}</height>
        <texture>script.plex/white-square-rounded-4r.png</texture>
        <colordiffuse>CC111111</colordiffuse>
    </control>
</control>
