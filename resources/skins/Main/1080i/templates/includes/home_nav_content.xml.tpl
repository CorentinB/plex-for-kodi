<control type="group">
    <visible>!String.IsEmpty(ListItem.Property(is.home))</visible>
    <control type="image">
        <posx>20</posx>
        <posy>{{ vscale(16) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture colordiffuse="{{ nav_icon_color }}">script.plex/home/type/home.png</texture>
        <aspectratio>keep</aspectratio>
    </control>
    <control type="label">
        <scroll>false</scroll>
        <posx>60</posx>
        <posy>0</posy>
        <width>94</width>
        <height>{{ vscale(60) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>{{ nav_color }}</textcolor>
        <label>$INFO[ListItem.Label]</label>
    </control>
</control>
{% with nav_label_width = 60 & nav_label_control_width = 74 %}
<control type="group">
    <visible>!String.IsEmpty(ListItem.Property(nav.width.60)) + String.IsEmpty(ListItem.Property(is.home))</visible>
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
{% endwith %}
{% with nav_label_width = 80 & nav_label_control_width = 94 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 100 & nav_label_control_width = 114 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 120 & nav_label_control_width = 134 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 140 & nav_label_control_width = 154 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 180 & nav_label_control_width = 194 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 220 & nav_label_control_width = 234 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 260 & nav_label_control_width = 274 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
{% with nav_label_width = 320 & nav_label_control_width = 334 %}
{% include "includes/home_nav_content_size.xml.tpl" %}
{% endwith %}
