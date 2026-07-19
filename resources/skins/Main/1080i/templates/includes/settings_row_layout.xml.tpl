<itemlayout height="{{ vscale(78) }}">
    <control type="label">
        <visible>Control.HasFocus(100)</visible>
        <posx>24</posx>
        <posy>0</posy>
        <width>500</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>EEFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="label">
        <visible>Control.HasFocus(100) + String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>500</posx>
        <posy>0</posy>
        <width>170</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>99FFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label2]</label>
    </control>
    <control type="label">
        <visible>!Control.HasFocus(100)</visible>
        <posx>24</posx>
        <posy>0</posy>
        <width>500</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="label">
        <visible>!Control.HasFocus(100) + String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>500</posx>
        <posy>0</posy>
        <width>170</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>AAFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label2]</label>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>640</posx>
        <posy>{{ vscale(19) }}</posy>
        <width>32</width>
        <height>{{ vscale(32) }}</height>
        <texture colordiffuse="66FFFFFF" border="8">script.plex/white-square-rounded-4r.png</texture>
    </control>
    <control type="image">
        <visible>!String.IsEmpty(ListItem.Property(checkbox.checked))</visible>
        <posx>642</posx>
        <posy>{{ vscale(20) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture>script.plex/settings/checkmark.png</texture>
    </control>
</itemlayout>
<focusedlayout height="{{ vscale(78) }}">
    <control type="image">
        <visible>Control.HasFocus(100)</visible>
        <posx>0</posx>
        <posy>{{ vscale(3) }}</posy>
        <width>700</width>
        <height>{{ vscale(64) }}</height>
        <texture colordiffuse="FFFFFFFF" border="22">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="image">
        <visible>Control.HasFocus(125)</visible>
        <posx>0</posx>
        <posy>{{ vscale(3) }}</posy>
        <width>700</width>
        <height>{{ vscale(64) }}</height>
        <texture colordiffuse="33FFFFFF" border="22">script.plex/white-square-rounded.png</texture>
    </control>
    <control type="label">
        <visible>Control.HasFocus(100)</visible>
        <posx>24</posx>
        <posy>0</posy>
        <width>500</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FF000000</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="label">
        <visible>Control.HasFocus(100) + String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>500</posx>
        <posy>0</posy>
        <width>170</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>AA000000</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label2]</label>
    </control>
    <control type="label">
        <visible>!Control.HasFocus(100)</visible>
        <posx>24</posx>
        <posy>0</posy>
        <width>500</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>left</align>
        <aligny>center</aligny>
        <textcolor>FFFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label]</label>
    </control>
    <control type="label">
        <visible>!Control.HasFocus(100) + String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>500</posx>
        <posy>0</posy>
        <width>170</width>
        <height>{{ vscale(70) }}</height>
        <font>font10</font>
        <align>right</align>
        <aligny>center</aligny>
        <textcolor>AAFFFFFF</textcolor>
        <scroll>false</scroll>
        <label>$INFO[ListItem.Label2]</label>
    </control>
    <control type="image">
        <visible>Control.HasFocus(100) + !String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>640</posx>
        <posy>{{ vscale(19) }}</posy>
        <width>32</width>
        <height>{{ vscale(32) }}</height>
        <texture colordiffuse="44000000" border="8">script.plex/white-square-rounded-4r.png</texture>
    </control>
    <control type="image">
        <visible>Control.HasFocus(100) + !String.IsEmpty(ListItem.Property(checkbox.checked))</visible>
        <posx>642</posx>
        <posy>{{ vscale(20) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture colordiffuse="FF000000">script.plex/settings/checkmark.png</texture>
    </control>
    <control type="image">
        <visible>!Control.HasFocus(100) + !String.IsEmpty(ListItem.Property(checkbox))</visible>
        <posx>640</posx>
        <posy>{{ vscale(19) }}</posy>
        <width>32</width>
        <height>{{ vscale(32) }}</height>
        <texture colordiffuse="66FFFFFF" border="8">script.plex/white-square-rounded-4r.png</texture>
    </control>
    <control type="image">
        <visible>!Control.HasFocus(100) + !String.IsEmpty(ListItem.Property(checkbox.checked))</visible>
        <posx>642</posx>
        <posy>{{ vscale(20) }}</posy>
        <width>28</width>
        <height>{{ vscale(28) }}</height>
        <texture>script.plex/settings/checkmark.png</texture>
    </control>
</focusedlayout>
