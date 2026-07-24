<control type="group">
    <visible>!String.IsEmpty(ListItem.Property(is.home))</visible>
    <control type="image">
        <visible>Control.HasFocus(101)</visible>
        <posx>-13</posx>
        <posy>{{ vscale(-12) }}</posy>
        <width>186</width>
        <height>{{ vscale(84) }}</height>
        <texture border="42">script.plex/drop-shadow.png</texture>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>160</width>
        <height>{{ vscale(60) }}</height>
        <texture border="24">script.plex/white-square-rounded.png</texture>
        <colordiffuse>EEFFFFFF</colordiffuse>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(is.mapped))</visible>
        <posx>149</posx>
        <posy>{{ vscale(10) }}</posy>
        <width>8</width>
        <height>{{ vscale(8) }}</height>
        <texture>script.plex/white-square-rounded-4r.png</texture>
        <colordiffuse>CC111111</colordiffuse>
    </control>
</control>
{% with nav_label_width = 60 & nav_plate_width = 140 & nav_shadow_width = 166 & nav_dot_x = 129 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 80 & nav_plate_width = 160 & nav_shadow_width = 186 & nav_dot_x = 149 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 100 & nav_plate_width = 180 & nav_shadow_width = 206 & nav_dot_x = 169 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 120 & nav_plate_width = 200 & nav_shadow_width = 226 & nav_dot_x = 189 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 140 & nav_plate_width = 220 & nav_shadow_width = 246 & nav_dot_x = 209 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 180 & nav_plate_width = 260 & nav_shadow_width = 286 & nav_dot_x = 249 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 220 & nav_plate_width = 300 & nav_shadow_width = 326 & nav_dot_x = 289 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 260 & nav_plate_width = 340 & nav_shadow_width = 366 & nav_dot_x = 329 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 320 & nav_plate_width = 400 & nav_shadow_width = 426 & nav_dot_x = 389 %}
{% include "includes/home_nav_focus_plate_size.xml.tpl" %}
{% endwith %}
