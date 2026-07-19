<itemlayout height="{{ vscale(72) }}">
    <control type="label">
        <posx>22</posx>
        <posy>0</posy>
        <width>320</width>
        <height>{{ vscale(64) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>DDFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(checkbox.checked))</visible>
        <posx>342</posx>
        <posy>{{ vscale(18) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture>script.plex/settings/checkmark.png</texture>
    </control>
</itemlayout>
<focusedlayout height="{{ vscale(72) }}">
    <control type="image">
        <posx>0</posx>
        <posy>{{ vscale(2) }}</posy>
        <width>380</width>
        <height>{{ vscale(60) }}</height>
        <texture colordiffuse="FFFFFFFF" border="22">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <posx>22</posx>
        <posy>0</posy>
        <width>320</width>
        <height>{{ vscale(64) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FF000000</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(checkbox.checked))</visible>
        <posx>342</posx>
        <posy>{{ vscale(18) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture colordiffuse="FF000000">script.plex/settings/checkmark.png</texture>
    </control>
</focusedlayout>
