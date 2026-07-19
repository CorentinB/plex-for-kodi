{% extends "base.xml.tpl" %}
{% block headers %}
    <defaultcontrol>201</defaultcontrol>
{% endblock %}

{% block controls %}
{% include "includes/default_background.xml.tpl" %}
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
    <texture colordiffuse="66000000">script.plex/white-square.png</texture>
</control>

<!-- Compact global header. -->
<control type="group" id="200">
    <defaultcontrol>201</defaultcontrol>
    <posx>0</posx>
    <posy>0</posy>
    <width>1920</width>
    <height>{{ vscale(130) }}</height>
    <control type="button" id="201">
        <posx>64</posx>
        <posy>{{ vscale(48) }}</posy>
        <width>44</width>
        <height>{{ vscale(44) }}</height>
        <onright>75</onright>
        <ondown>75</ondown>
        <texturefocus colordiffuse="FFFFFFFF">script.plex/buttons/home-focus.png</texturefocus>
        <texturenofocus colordiffuse="BFFFFFFF">script.plex/buttons/home.png</texturenofocus>
        <label> </label>
    </control>
    <control type="label">
        <posx>160</posx>
        <posy>{{ vscale(36) }}</posy>
        <width>900</width>
        <height>{{ vscale(70) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$INFO[Window.Property(heading)]</label>
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

<!-- Category rail. -->
<control type="image">
    <posx>160</posx>
    <posy>{{ vscale(150) }}</posy>
    <width>360</width>
    <height>{{ vscale(790) }}</height>
    <texture colordiffuse="D90D0D0D" border="28">script.plex/white-square-rounded.png</texture>
</control>
<control type="label">
    <posx>190</posx>
    <posy>{{ vscale(176) }}</posy>
    <width>300</width>
    <height>{{ vscale(44) }}</height>
    <font>font12</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>99FFFFFF</textcolor>
    <label>$INFO[Window.Property(heading)]</label>
</control>
<control type="list" id="75">
    <posx>180</posx>
    <posy>{{ vscale(232) }}</posy>
    <width>320</width>
    <height>{{ vscale(648) }}</height>
    <onup>201</onup>
    <onleft>201</onleft>
    <onright>100</onright>
    <scrolltime>180</scrolltime>
    <orientation>vertical</orientation>
    <itemlayout height="{{ vscale(72) }}">
        <control type="label">
            <posx>18</posx>
            <posy>0</posy>
            <width>284</width>
            <height>{{ vscale(64) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>DDFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
    </itemlayout>
    <focusedlayout height="{{ vscale(72) }}">
        <control type="image">
            <visible>Control.HasFocus(75)</visible>
            <posx>0</posx>
            <posy>{{ vscale(2) }}</posy>
            <width>320</width>
            <height>{{ vscale(60) }}</height>
            <texture colordiffuse="FFFFFFFF" border="22">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="image">
            <visible>!Control.HasFocus(75)</visible>
            <posx>0</posx>
            <posy>{{ vscale(2) }}</posy>
            <width>320</width>
            <height>{{ vscale(60) }}</height>
            <texture colordiffuse="33FFFFFF" border="22">script.plex/white-square-rounded.png</texture>
        </control>
        <control type="label">
            <visible>Control.HasFocus(75)</visible>
            <posx>18</posx>
            <posy>0</posy>
            <width>284</width>
            <height>{{ vscale(64) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FF000000</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
        <control type="label">
            <visible>!Control.HasFocus(75)</visible>
            <posx>18</posx>
            <posy>0</posy>
            <width>284</width>
            <height>{{ vscale(64) }}</height>
            <font>font10</font>
            <align>left</align>
            <aligny>center</aligny>
            <textcolor>FFFFFFFF</textcolor>
            <scroll>false</scroll>
            <label>$INFO[ListItem.Label]</label>
        </control>
    </focusedlayout>
</control>

<!-- Settings list. -->
<control type="image">
    <posx>540</posx>
    <posy>{{ vscale(150) }}</posy>
    <width>760</width>
    <height>{{ vscale(790) }}</height>
    <texture colordiffuse="D90D0D0D" border="28">script.plex/white-square-rounded.png</texture>
</control>
<control type="label">
    <posx>574</posx>
    <posy>{{ vscale(174) }}</posy>
    <width>690</width>
    <height>{{ vscale(48) }}</height>
    <font>font13</font>
    <align>left</align>
    <aligny>center</aligny>
    <textcolor>FFFFFFFF</textcolor>
    <label>$INFO[Container(75).ListItem.Label]</label>
</control>
<control type="list" id="100">
    <visible>Integer.IsGreater(Container(100).NumItems,0)</visible>
    <enable>String.IsEmpty(Window.Property(section.about))</enable>
    <posx>560</posx>
    <posy>{{ vscale(232) }}</posy>
    <width>720</width>
    <height>{{ vscale(624) }}</height>
    <onup>201</onup>
    <onleft>75</onleft>
    <onright>noop</onright>
    <scrolltime>180</scrolltime>
    <orientation>vertical</orientation>
    <pagecontrol>101</pagecontrol>
    {% include "includes/settings_row_layout.xml.tpl" %}
</control>
<control type="scrollbar" id="101">
    <visible>Integer.IsGreater(Container(100).NumPages,1)</visible>
    <posx>1260</posx>
    <posy>{{ vscale(246) }}</posy>
    <width>6</width>
    <height>{{ vscale(596) }}</height>
    <texturesliderbackground colordiffuse="22FFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbackground>
    <texturesliderbar colordiffuse="88FFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbar>
    <texturesliderbarfocus colordiffuse="FFFFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbarfocus>
    <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
    <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
    <orientation>vertical</orientation>
    <showonepage>false</showonepage>
    <onleft>100</onleft>
</control>

<!-- The right panel is contextual help until an option list opens. -->
<control type="image">
    <posx>1320</posx>
    <posy>{{ vscale(150) }}</posy>
    <width>440</width>
    <height>{{ vscale(790) }}</height>
    <texture colordiffuse="D90D0D0D" border="28">script.plex/white-square-rounded.png</texture>
</control>
<control type="group">
    <visible>!Control.HasFocus(125)</visible>
    <control type="textbox">
        <posx>1354</posx>
        <posy>{{ vscale(176) }}</posy>
        <width>372</width>
        <height>{{ vscale(86) }}</height>
        <font>font12</font>
        <align>left</align>
        <textcolor>FFFFFFFF</textcolor>
        <autoscroll>false</autoscroll>
        <label>$INFO[Container(100).ListItem.Label]</label>
    </control>
    <control type="label">
        <posx>1354</posx>
        <posy>{{ vscale(268) }}</posy>
        <width>372</width>
        <height>{{ vscale(38) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>88FFFFFF</textcolor>
        <label>$INFO[Container(100).ListItem.Label2]</label>
    </control>
    <control type="textbox">
        <posx>1354</posx>
        <posy>{{ vscale(326) }}</posy>
        <width>372</width>
        <height>{{ vscale(526) }}</height>
        <font>font10</font>
        <align>left</align>
        <textcolor>BBFFFFFF</textcolor>
        <autoscroll>false</autoscroll>
        <label>$INFO[Container(100).ListItem.Property(description)]</label>
    </control>
</control>

<control type="group">
    <visible allowhiddenfocus="true">Control.HasFocus(125)</visible>
    <control type="label">
        <posx>1354</posx>
        <posy>{{ vscale(174) }}</posy>
        <width>372</width>
        <height>{{ vscale(52) }}</height>
        <font>font13</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>$INFO[Container(100).ListItem.Label]</label>
    </control>
    <control type="list" id="125">
        <posx>1340</posx>
        <posy>{{ vscale(232) }}</posy>
        <width>400</width>
        <height>{{ vscale(576) }}</height>
        <onup>201</onup>
        <onleft>100</onleft>
        <onright>125</onright>
        <scrolltime>180</scrolltime>
        <orientation>vertical</orientation>
        <pagecontrol>126</pagecontrol>
        {% include "includes/settings_option_layout.xml.tpl" %}
    </control>
    <control type="scrollbar" id="126">
        <visible>Integer.IsGreater(Container(125).NumPages,1)</visible>
        <posx>1720</posx>
        <posy>{{ vscale(246) }}</posy>
        <width>6</width>
        <height>{{ vscale(548) }}</height>
        <texturesliderbackground colordiffuse="22FFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbackground>
        <texturesliderbar colordiffuse="88FFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbar>
        <texturesliderbarfocus colordiffuse="FFFFFFFF" border="3">script.plex/white-square-rounded-4r.png</texturesliderbarfocus>
        <textureslidernib>script.plex/transparent-6px.png</textureslidernib>
        <textureslidernibfocus>script.plex/transparent-6px.png</textureslidernibfocus>
        <orientation>vertical</orientation>
        <showonepage>false</showonepage>
        <onleft>125</onleft>
    </control>
</control>
{% endblock controls %}
