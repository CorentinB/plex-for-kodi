{% extends "base.xml.tpl" %}
{% block backgroundcolor %}{% endblock %}
{% block controls %}
<control type="group">
    <posx>660</posx>
    <posy>{{ vscale(145) }}</posy>
    {% for rows in range(1, 7) %}
    {% with slide_y = 350 - rows * 50 %}
    <animation effect="slide" end="0,{{ vscale(slide_y) }}" time="0" condition="Integer.IsEqual(Container(100).NumItems,{{ rows }})" reversible="true">Conditional</animation>
    {% endwith %}
    {% endfor %}
    {% for rows in range(1, 8) %}
    {% with shadow_height = rows * 100 + 170 & body_height = rows * 100 + 10 %}
    <control type="image">
        <posx>-40</posx>
        <posy>{{ vscale(-40) }}</posy>
        <width>680</width>
        <height>{{ vscale(shadow_height) }}</height>
        <texture border="42">script.plex/drop-shadow.png</texture>
        <visible>{% if rows < 7 %}Integer.IsEqual(Container(100).NumItems,{{ rows }}){% else %}Integer.IsGreaterOrEqual(Container(100).NumItems,7){% endif %}</visible>
    </control>
    <control type="image">
        <posx>0</posx>
        <posy>{{ vscale(80) }}</posy>
        <width>600</width>
        <height>{{ vscale(body_height) }}</height>
        <texture flipy="true" border="10">script.plex/white-square-top-rounded.png</texture>
        <colordiffuse>D3111111</colordiffuse>
        <visible>{% if rows < 7 %}Integer.IsEqual(Container(100).NumItems,{{ rows }}){% else %}Integer.IsGreaterOrEqual(Container(100).NumItems,7){% endif %}</visible>
    </control>
    {% endwith %}
    {% endfor %}
    <control type="image">
        <posx>0</posx>
        <posy>0</posy>
        <width>600</width>
        <height>{{ vscale(80) }}</height>
        <texture border="10">script.plex/white-square-top-rounded.png</texture>
        <colordiffuse>F21F1F1F</colordiffuse>
    </control>
    <control type="label">
        <posx>0</posx>
        <posy>0</posy>
        <width>600</width>
        <height>{{ vscale(80) }}</height>
        <font>font12</font>
        <align>center</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <label>[B]$INFO[Window.Property(heading)][/B]</label>
    </control>
    <control type="list" id="100">
        <posx>0</posx>
        <posy>{{ vscale(80) }}</posy>
        <width>600</width>
        <height>{{ vscale(700) }}</height>
        <onup>noop</onup>
        <ondown>noop</ondown>
        <scrolltime>200</scrolltime>
        <orientation>vertical</orientation>
        <!-- ITEM LAYOUT ########################################## -->
        <itemlayout height="{{ vscale(100) }}">
            <control type="label">
                <visible>String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>0</posy>
                <width>560</width>
                <height>{{ vscale(100) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>{{ vscale(15) }}</posy>
                <width>600</width>
                <height>{{ vscale(40) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFFFFFFF</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>600</width>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FFBBBBBB</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </itemlayout>
        <focusedlayout height="{{ vscale(100) }}">
            <control type="image">
                <posx>10</posx>
                <posy>{{ vscale(5) }}</posy>
                <width>580</width>
                <height>{{ vscale(90) }}</height>
                <texture colordiffuse="FFFFFFFF" border="24">script.plex/white-square-rounded.png</texture>
            </control>
            <control type="label">
                <visible>String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>0</posy>
                <width>560</width>
                <height>{{ vscale(100) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF000000</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>{{ vscale(15) }}</posy>
                <width>600</width>
                <height>{{ vscale(40) }}</height>
                <font>font12</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF000000</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label]</label>
            </control>
            <control type="label">
                <visible>!String.IsEmpty(ListItem.Label2)</visible>
                <posx>20</posx>
                <posy>{{ vscale(40) }}</posy>
                <width>560</width>
                <font>font10</font>
                <align>left</align>
                <aligny>center</aligny>
                <textcolor>FF222222</textcolor>
                <scroll>false</scroll>
                <scrollspeed>15</scrollspeed>
                <label>$INFO[ListItem.Label2]</label>
            </control>
        </focusedlayout>
    </control>
</control>
{% endblock controls %}
