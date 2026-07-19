<control type="group">
    <visible>!String.IsEmpty(ListItem.Property(nav.width.{{ nav_label_width }})) + String.IsEmpty(ListItem.Property(is.home))</visible>
    <control type="image">
        <posx>20</posx>
        <posy>{{ vscale(16) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture colordiffuse="{{ nav_icon_color }}">$INFO[ListItem.Thumb]</texture>
        <aspectratio>keep</aspectratio>
    </control>
    <control type="label">
        <scroll>{{ nav_scroll }}</scroll>
        <posx>60</posx>
        <posy>0</posy>
        <width>{{ nav_label_control_width }}</width>
        <height>{{ vscale(60) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>{{ nav_color }}</textcolor>
        <label>$INFO[ListItem.Label]</label>
    </control>
</control>
