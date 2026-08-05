<#
    WingetGUI.ps1
    A polished WPF front-end for winget: a big categorized checklist tab + a live search tab.
    Run with: powershell -ExecutionPolicy Bypass -File WingetGUI.ps1
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ---------------------------------------------------------------------------
# Curated apps, grouped by category. DisplayName -> winget package ID
# Edit / add / remove freely.
# ---------------------------------------------------------------------------
$CuratedCategories = [ordered]@{
    "Browsers" = [ordered]@{
        "Google Chrome"        = "Google.Chrome"
        "Mozilla Firefox"      = "Mozilla.Firefox"
        "Brave Browser"        = "Brave.Brave"
        "Microsoft Edge"       = "Microsoft.Edge"
        "Opera"                = "Opera.Opera"
        "Opera GX"             = "Opera.OperaGX"
        "Vivaldi"              = "VivaldiTechnologies.Vivaldi"
        "Tor Browser"          = "TorProject.TorBrowser"
        "Chromium"             = "Hibbiki.Chromium"
        "Waterfox"             = "Waterfox.Waterfox"
        "LibreWolf"            = "LibreWolf.LibreWolf"
        "Arc Browser"          = "TheBrowserCompany.Arc"
        "DuckDuckGo Browser"   = "DuckDuckGo.DesktopBrowser"
    }
    "Communication" = [ordered]@{
        "Discord"              = "Discord.Discord"
        "Slack"                = "SlackTechnologies.Slack"
        "Zoom"                 = "Zoom.Zoom"
        "Microsoft Teams"      = "Microsoft.Teams"
        "Skype"                = "Microsoft.Skype"
        "Telegram"             = "Telegram.TelegramDesktop"
        "WhatsApp"             = "9NKSQGP7F2NH"
        "Signal"               = "OpenWhisperSystems.Signal"
        "TeamSpeak 3"          = "TeamSpeakSystems.TeamSpeakClient"
        "Viber"                = "Viber.Viber"
        "Element"              = "Element.Element"
        "Mumble"               = "Mumble.Mumble"
        "Thunderbird"          = "Mozilla.Thunderbird"
        "Google Chat"          = "Google.GoogleChat"
        "Facebook Messenger"   = "9NHF89ZFZ71S"
    }
    "Gaming" = [ordered]@{
        "Steam"                = "Valve.Steam"
        "Riot Games (Valorant, LoL)" = "RiotGames.RiotClient"
        "Epic Games Launcher"  = "EpicGames.EpicGamesLauncher"
        "GOG Galaxy"           = "GOG.Galaxy"
        "Battle.net"           = "Blizzard.BattleNet"
        "Ubisoft Connect"      = "Ubisoft.Connect"
        "EA App"               = "ElectronicArts.EADesktop"
        "Xbox"                 = "9MV0B5HZVK9Z"
        "PlayStation App"      = "SonyInteractiveEntertainment.PlayStationApp"
        "Rockstar Games Launcher" = "RockstarGames.RockstarGamesLauncher"
        "itch.io"              = "ItchIo.Itch"
        "Minecraft Launcher"   = "Mojang.MinecraftLauncher"
        "OBS Studio"           = "OBSProject.OBSStudio"
        "Streamlabs Desktop"   = "Streamlabs.StreamlabsOBS"
        "MSI Afterburner"      = "Guru3D.Afterburner"
        "Moonlight"            = "MoonlightGameStreamingProject.Moonlight"
        "Parsec"               = "Parsec.Parsec"
        "GeForce Experience"   = "Nvidia.GeForceExperience"
        "AMD Software Adrenalin" = "AMD.AMDSoftware"
        "CrystalDiskInfo"      = "CrystalDewWorld.CrystalDiskInfo"
        "HWiNFO"               = "REALiX.HWiNFO"
        "PlaynGetSound"        = "VoiceMeeter.VoiceMeeter"
    }
    "Media and Music" = [ordered]@{
        "VLC Media Player"     = "VideoLAN.VLC"
        "Spotify"              = "Spotify.Spotify"
        "iTunes"               = "Apple.iTunes"
        "foobar2000"           = "PeterPawlowski.foobar2000"
        "MPC-HC"               = "clsid2.mpc-hc"
        "Audacity"             = "Audacity.Audacity"
        "HandBrake"            = "HandBrake.HandBrake"
        "K-Lite Codec Pack"    = "CodecGuide.K-LiteCodecPack.Standard"
        "AIMP"                 = "AIMP.AIMP"
        "MusicBee"             = "MusicBee.MusicBee"
        "Plex Media Server"    = "Plex.PlexMediaServer"
        "Plex Desktop"         = "Plex.Plex"
        "Kodi"                 = "XBMCFoundation.Kodi"
        "PotPlayer"            = "Daum.PotPlayer"
        "iTunes Store Helper"  = "Apple.iCloud"
        "YouTube Music Desktop"= "ytmdesktop.ytmdesktop"
        "Tidal"                = "9NBLGGH52083"
        "Amazon Music"         = "Amazon.Music"
        "OpenShot Video Editor"= "OpenShot.OpenShot"
        "Shotcut"              = "Meltytech.Shotcut"
    }
    "Productivity" = [ordered]@{
        "Microsoft Office"     = "Microsoft.Office"
        "LibreOffice"          = "TheDocumentFoundation.LibreOffice"
        "Notion"               = "Notion.Notion"
        "Obsidian"             = "Obsidian.Obsidian"
        "Evernote"             = "Evernote.Evernote"
        "Adobe Acrobat Reader" = "Adobe.Acrobat.Reader.64-bit"
        "Sumatra PDF"          = "SumatraPDF.SumatraPDF"
        "Todoist"              = "Doist.Todoist"
        "Microsoft PowerToys"  = "Microsoft.PowerToys"
        "Everything (search)"  = "voidtools.Everything"
        "Notion Calendar"      = "Notion.NotionCalendar"
        "Trello"               = "Trello.Trello"
        "Microsoft OneNote"    = "Microsoft.OneNote"
        "Google Keep"          = "9NHHT8SQZBH6"
        "XMind"                = "XMindLtd.XMind"
        "Zotero"               = "DigitalScholar.Zotero"
        "Calibre"              = "calibre.calibre"
        "WPS Office"           = "Kingsoft.WPSOffice"
        "PDF24 Creator"        = "geeksoftwareGmbH.PDF24Creator"
        "Grammarly"            = "Grammarly.Grammarly"
    }
    "Utilities" = [ordered]@{
        "7-Zip"                = "7zip.7zip"
        "WinRAR"               = "RARLab.WinRAR"
        "CCleaner"             = "Piriform.CCleaner"
        "Revo Uninstaller"     = "RevoUninstaller.RevoUninstaller"
        "TreeSize Free"        = "JAMSoftware.TreeSize.Free"
        "Rufus"                = "Rufus.Rufus"
        "balenaEtcher"         = "Balena.Etcher"
        "Windows Terminal"     = "Microsoft.WindowsTerminal"
        "PowerShell 7"         = "Microsoft.PowerShell"
        "AutoHotkey"           = "AutoHotkey.AutoHotkey"
        "ShareX"               = "ShareX.ShareX"
        "Wise Disk Cleaner"    = "WiseCleaner.WiseDiskCleaner"
        "PeaZip"               = "Giorgiotani.Peazip"
        "WizTree"              = "AntibodySoftware.WizTree"
        "Bulk Rename Utility"  = "TGRMNSoftware.BulkRenameUtility"
        "Glary Utilities"      = "Glarysoft.GlaryUtilities"
        "Q-Dir"                = "Nenad.QDir"
        "FanControl"           = "Rem0o.FanControl"
        "Wintoys"              = "Bloatynosy.Wintoys"
        "Process Explorer"     = "Microsoft.Sysinternals.ProcessExplorer"
        "Autoruns"             = "Microsoft.Sysinternals.Autoruns"
        "NanaZip"              = "M2Team.NanaZip"
        "Voicemeeter Banana"   = "VB-Audio.Voicemeeter.Banana"
    }
    "Dev Tools" = [ordered]@{
        "Visual Studio Code"   = "Microsoft.VisualStudioCode"
        "Visual Studio 2022"   = "Microsoft.VisualStudio.2022.Community"
        "Git"                  = "Git.Git"
        "GitHub Desktop"       = "GitHub.GitHubDesktop"
        "Node.js LTS"          = "OpenJS.NodeJS.LTS"
        "Python 3"             = "Python.Python.3.12"
        "Docker Desktop"       = "Docker.DockerDesktop"
        "Postman"              = "Postman.Postman"
        "JetBrains Toolbox"    = "JetBrains.Toolbox"
        "Windows Subsystem for Linux" = "9P9TQF7MRM4R"
        "Notepad++"            = "Notepad++.Notepad++"
        "MongoDB Compass"      = "MongoDB.Compass.Full"
        "IntelliJ IDEA Community" = "JetBrains.IntelliJIDEA.Community"
        "PyCharm Community"    = "JetBrains.PyCharm.Community"
        "Sublime Text"         = "SublimeHQ.SublimeText.4"
        "Vim"                  = "vim.vim"
        "WSL Ubuntu"           = "Canonical.Ubuntu.2404"
        "DBeaver"              = "dbeaver.dbeaver"
        "TablePlus"            = "TablePlus.TablePlus"
        "Insomnia"             = "Insomnia.Insomnia"
        "Fiddler"              = "Telerik.Fiddler.Classic"
        "Wireshark"            = "WiresharkFoundation.Wireshark"
        "CMake"                = "Kitware.CMake"
        "Java JDK 21"          = "EclipseAdoptium.Temurin.21.JDK"
        "Go"                   = "GoLang.Go"
        "Rust"                 = "Rustlang.Rust.MSVC"
        "Windows Subsystem for Android" = "9P3395VX91NR"
    }
    "Creative and Design" = [ordered]@{
        "GIMP"                 = "GIMP.GIMP"
        "Blender"              = "BlenderFoundation.Blender"
        "Inkscape"             = "Inkscape.Inkscape"
        "Krita"                = "KDE.Krita"
        "Paint.NET"            = "dotPDN.PaintDotNet"
        "DaVinci Resolve"      = "Blackmagicdesign.DaVinciResolve"
        "Figma"                = "Figma.Figma"
        "Audacity FX"          = "Audacity.Audacity"
        "Aseprite"             = "Aseprite.Aseprite"
        "FreeCAD"              = "FreeCAD.FreeCAD"
        "LMMS"                 = "LMMS.LMMS"
        "Cakewalk by BandLab"  = "BandLab.Cakewalk"
        "OBS Virtual Camera"   = "OBSProject.OBSStudio"
        "CapCut"               = "ByteDance.CapCut"
        "Canva"                = "Canva.Canva"
    }
    "Security" = [ordered]@{
        "Malwarebytes"         = "Malwarebytes.Malwarebytes"
        "Bitwarden"            = "Bitwarden.Bitwarden"
        "1Password"            = "AgileBits.1Password"
        "ProtonVPN"            = "ProtonTechnologies.ProtonVPN"
        "NordVPN"              = "NordVPN.NordVPN"
        "KeePass"              = "DominikReichl.KeePass"
        "Windows Defender"     = "Microsoft.WindowsDefender"
        "Norton 360"           = "Norton.Norton360"
        "Avast Free Antivirus" = "Avast.AvastFreeAntivirus"
        "AVG AntiVirus Free"   = "AVG.AVGAntiVirusFree"
        "Mullvad VPN"          = "MullvadVPN.MullvadVPN"
        "CryptoMator"          = "Cryptomator.Cryptomator"
    }
    "Cloud and Storage" = [ordered]@{
        "Google Drive"         = "Google.GoogleDrive"
        "Dropbox"              = "Dropbox.Dropbox"
        "OneDrive"             = "Microsoft.OneDrive"
        "Syncthing"            = "Syncthing.Syncthing"
        "MEGA"                 = "Mega.MEGASync"
        "pCloud"               = "pCloud.pCloud"
        "iCloud"               = "Apple.iCloud"
        "Box"                  = "Box.Box"
        "FileZilla"            = "TimKosse.FileZilla.Client"
        "WinSCP"               = "WinSCP.WinSCP"
    }
    "Fonts and System" = [ordered]@{
        ".NET Desktop Runtime 8" = "Microsoft.DotNet.DesktopRuntime.8"
        "Visual C++ Redistributables" = "Microsoft.VCRedist.2015+.x64"
        "DirectX Runtime"      = "Microsoft.DirectX"
        "Java Runtime (JRE)"   = "Oracle.JavaRuntimeEnvironment"
        "Nvidia Control Panel" = "9NF8H0H7WMLT"
    }
}

# ---------------------------------------------------------------------------
# XAML UI
# ---------------------------------------------------------------------------
[xml]$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="App Installer" Height="900" Width="960"
        WindowStartupLocation="CenterScreen" Background="#121212"
        FontFamily="Segoe UI">
    <Window.Resources>
        <SolidColorBrush x:Key="Accent" Color="#3B82F6"/>
        <SolidColorBrush x:Key="CardBg" Color="#1E1E1E"/>
        <SolidColorBrush x:Key="CardBorder" Color="#2A2A2A"/>

        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="#E8E8E8"/>
            <Setter Property="FontSize" Value="13.5"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
        </Style>

        <Style TargetType="Button" x:Key="PrimaryButton">
            <Setter Property="Background" Value="{StaticResource Accent}"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="18,10"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="Button" x:Key="SecondaryButton">
            <Setter Property="Background" Value="#2A2A2A"/>
            <Setter Property="Foreground" Value="#E8E8E8"/>
            <Setter Property="Padding" Value="12,8"/>
            <Setter Property="FontSize" Value="12.5"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="5" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#1E1E1E"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#333333"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="FontSize" Value="13.5"/>
            <Setter Property="CaretBrush" Value="White"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Padding" Value="14,8"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Border Name="Bd" Background="Transparent" BorderThickness="0,0,0,3" BorderBrush="Transparent" Padding="{TemplateBinding Padding}">
                            <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Bd" Property="BorderBrush" Value="{StaticResource Accent}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Setter Property="Foreground" Value="#AAAAAA"/>
            <Style.Triggers>
                <Trigger Property="IsSelected" Value="True">
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="FontWeight" Value="SemiBold"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style TargetType="Expander">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Margin" Value="0,0,0,10"/>
        </Style>
    </Window.Resources>

    <Grid Margin="16">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <StackPanel Grid.Row="0" Margin="0,0,0,12">
            <TextBlock Text="App Installer" Foreground="White" FontSize="24" FontWeight="Bold"/>
            <TextBlock Text="Pick apps below or search the full winget catalog, then install them all at once." Foreground="#999999" FontSize="12.5" Margin="0,2,0,0"/>
        </StackPanel>

        <TabControl Grid.Row="1" Name="MainTabs" Background="Transparent" BorderThickness="0">
            <TabItem Header="Popular Apps">
                <Grid Margin="0,10,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <DockPanel Grid.Row="0" Margin="0,0,0,10">
                        <TextBlock DockPanel.Dock="Left" Text="Filter:" Foreground="#AAAAAA" VerticalAlignment="Center" Margin="0,0,8,0"/>
                        <Button DockPanel.Dock="Right" Name="CollapseAllBtn" Content="Collapse All" Style="{StaticResource SecondaryButton}" Margin="6,0,0,0"/>
                        <Button DockPanel.Dock="Right" Name="ExpandAllBtn" Content="Expand All" Style="{StaticResource SecondaryButton}" Margin="6,0,0,0"/>
                        <TextBox Name="CuratedFilterBox" VerticalContentAlignment="Center"/>
                    </DockPanel>

                    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                        <StackPanel Name="CategoryPanel" Margin="0,0,6,0"/>
                    </ScrollViewer>
                </Grid>
            </TabItem>

            <TabItem Header="Search All Apps">
                <Grid Margin="0,10,0,0">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    <DockPanel Grid.Row="0" Margin="0,0,0,10">
                        <Button DockPanel.Dock="Right" Name="SearchBtn" Content="Search" Style="{StaticResource PrimaryButton}" Margin="8,0,0,0"/>
                        <TextBox Name="SearchBox" VerticalContentAlignment="Center"/>
                    </DockPanel>
                    <Border Grid.Row="1" Background="{StaticResource CardBg}" BorderBrush="{StaticResource CardBorder}" BorderThickness="1" CornerRadius="6">
                        <ListView Name="SearchResults" Background="Transparent" BorderThickness="0" Foreground="White">
                            <ListView.Resources>
                                <Style TargetType="ListViewItem">
                                    <Setter Property="Background" Value="Transparent"/>
                                    <Setter Property="Foreground" Value="#E8E8E8"/>
                                    <Setter Property="Padding" Value="4,6"/>
                                    <Setter Property="BorderThickness" Value="0,0,0,1"/>
                                    <Setter Property="BorderBrush" Value="#2A2A2A"/>
                                </Style>
                                <Style TargetType="GridViewColumnHeader">
                                    <Setter Property="Background" Value="#1E1E1E"/>
                                    <Setter Property="Foreground" Value="#AAAAAA"/>
                                    <Setter Property="Padding" Value="6,8"/>
                                    <Setter Property="BorderThickness" Value="0,0,0,1"/>
                                    <Setter Property="BorderBrush" Value="#333333"/>
                                    <Setter Property="HorizontalContentAlignment" Value="Left"/>
                                </Style>
                            </ListView.Resources>
                            <ListView.View>
                                <GridView>
                                    <GridViewColumn Header="Install" Width="55">
                                        <GridViewColumn.CellTemplate>
                                            <DataTemplate>
                                                <CheckBox IsChecked="{Binding IsChecked, Mode=TwoWay}"/>
                                            </DataTemplate>
                                        </GridViewColumn.CellTemplate>
                                    </GridViewColumn>
                                    <GridViewColumn Header="Name" Width="260" DisplayMemberBinding="{Binding Name}"/>
                                    <GridViewColumn Header="Id" Width="220" DisplayMemberBinding="{Binding Id}"/>
                                    <GridViewColumn Header="Version" Width="100" DisplayMemberBinding="{Binding Version}"/>
                                </GridView>
                            </ListView.View>
                        </ListView>
                    </Border>
                </Grid>
            </TabItem>
        </TabControl>

        <Border Grid.Row="2" Background="{StaticResource CardBg}" BorderBrush="{StaticResource CardBorder}" BorderThickness="1" CornerRadius="8" Margin="0,14,0,0" Padding="14,10">
            <DockPanel>
                <Button DockPanel.Dock="Right" Name="InstallBtn" Content="Install Selected" Style="{StaticResource PrimaryButton}" Background="#22A559"/>
                <TextBlock Name="SelectedCountText" Foreground="#AAAAAA" VerticalAlignment="Center" Text="0 apps selected"/>
                <TextBlock Name="StatusText" Foreground="#DDDDDD" VerticalAlignment="Center" Margin="16,0,0,0" Text=""/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
"@

# ---------------------------------------------------------------------------
# Load XAML
# ---------------------------------------------------------------------------
$reader = New-Object System.Xml.XmlNodeReader $Xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$CategoryPanel      = $window.FindName("CategoryPanel")
$CuratedFilterBox   = $window.FindName("CuratedFilterBox")
$ExpandAllBtn       = $window.FindName("ExpandAllBtn")
$CollapseAllBtn     = $window.FindName("CollapseAllBtn")
$SearchBox          = $window.FindName("SearchBox")
$SearchBtn          = $window.FindName("SearchBtn")
$SearchResults      = $window.FindName("SearchResults")
$InstallBtn         = $window.FindName("InstallBtn")
$StatusText         = $window.FindName("StatusText")
$SelectedCountText  = $window.FindName("SelectedCountText")

# ---------------------------------------------------------------------------
# Search tab collection (must exist before Update-SelectedCount is called)
# ---------------------------------------------------------------------------
$SearchItems = New-Object System.Collections.ObjectModel.ObservableCollection[Object]
$SearchResults.ItemsSource = $SearchItems

function Update-SelectedCount {
    $count = 0
    foreach ($entry in $CuratedCheckboxes.Values) {
        if ($entry.CheckBox.IsChecked) { $count++ }
    }
    foreach ($item in $SearchItems) {
        if ($item.IsChecked) { $count++ }
    }
    $SelectedCountText.Text = "$count app(s) selected"
}

# ---------------------------------------------------------------------------
# Build the categorized checklist (Expanders, first 3 open by default)
# ---------------------------------------------------------------------------
$CuratedCheckboxes = @{}   # winget id -> @{ CheckBox; Name; Category }
$CategoryExpanders = @()   # for filtering

$catIndex = 0
foreach ($cat in $CuratedCategories.Keys) {
    $catIndex++

    $expander = New-Object System.Windows.Controls.Expander
    $expander.Header = "$cat  ($($CuratedCategories[$cat].Count))"
    $expander.IsExpanded = ($catIndex -le 3)
    $expander.FontSize = 15
    $expander.FontWeight = 'SemiBold'

    $innerPanel = New-Object System.Windows.Controls.WrapPanel
    $innerPanel.Margin = "20,8,0,4"
    $innerPanel.Orientation = 'Horizontal'

    foreach ($name in $CuratedCategories[$cat].Keys) {
        $id = $CuratedCategories[$cat][$name]

        $cb = New-Object System.Windows.Controls.CheckBox
        $cb.Content = $name
        $cb.Tag = $id
        $cb.Width = 260
        $cb.Margin = "0,4,10,4"
        $cb.Add_Checked({ Update-SelectedCount })
        $cb.Add_Unchecked({ Update-SelectedCount })

        $innerPanel.Children.Add($cb) | Out-Null
        $CuratedCheckboxes[$id] = @{ CheckBox = $cb; Name = $name; Category = $cat }
    }

    $expander.Content = $innerPanel
    $CategoryPanel.Children.Add($expander) | Out-Null
    $CategoryExpanders += @{ Expander = $expander; Panel = $innerPanel; Category = $cat }
}

$ExpandAllBtn.Add_Click({
    foreach ($group in $CategoryExpanders) { $group.Expander.IsExpanded = $true }
})
$CollapseAllBtn.Add_Click({
    foreach ($group in $CategoryExpanders) { $group.Expander.IsExpanded = $false }
})

# ---------------------------------------------------------------------------
# Curated filter box: hide/show checkboxes and auto-expand matching categories
# ---------------------------------------------------------------------------
$CuratedFilterBox.Add_TextChanged({
    $q = $CuratedFilterBox.Text.Trim().ToLower()

    foreach ($group in $CategoryExpanders) {
        $anyVisible = $false
        foreach ($child in $group.Panel.Children) {
            if ($q -eq "") {
                $child.Visibility = 'Visible'
                $anyVisible = $true
            }
            elseif ($child.Content.ToString().ToLower().Contains($q)) {
                $child.Visibility = 'Visible'
                $anyVisible = $true
            }
            else {
                $child.Visibility = 'Collapsed'
            }
        }
        $group.Expander.Visibility = if ($anyVisible) { 'Visible' } else { 'Collapsed' }
        if ($q -ne "" -and $anyVisible) { $group.Expander.IsExpanded = $true }
    }
})

# ---------------------------------------------------------------------------
# Search tab logic
# ---------------------------------------------------------------------------
function Search-Winget {
    param([string]$Query)

    if ([string]::IsNullOrWhiteSpace($Query)) { return }

    $StatusText.Text = "Searching..."
    $window.Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)

    $SearchItems.Clear()

    try {
        $raw = winget search $Query --accept-source-agreements | Out-String
        $lines = $raw -split "`r?`n"

        $sepIndex = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^-{5,}') { $sepIndex = $i; break }
        }

        if ($sepIndex -ge 0) {
            for ($i = $sepIndex + 1; $i -lt $lines.Count; $i++) {
                $line = $lines[$i]
                if ([string]::IsNullOrWhiteSpace($line)) { continue }

                $parts = [System.Text.RegularExpressions.Regex]::Split($line.Trim(), '\s{2,}')
                if ($parts.Count -ge 3) {
                    $obj = [PSCustomObject]@{
                        IsChecked = $false
                        Name      = $parts[0]
                        Id        = $parts[1]
                        Version   = $parts[2]
                    }
                    $SearchItems.Add($obj) | Out-Null
                }
            }
        }

        $StatusText.Text = "Found $($SearchItems.Count) result(s)"
    }
    catch {
        $StatusText.Text = "Search failed: $($_.Exception.Message)"
    }
    Update-SelectedCount
}

$SearchBtn.Add_Click({ Search-Winget -Query $SearchBox.Text })
$SearchBox.Add_KeyDown({
    if ($_.Key -eq 'Return') { Search-Winget -Query $SearchBox.Text }
})

# ---------------------------------------------------------------------------
# Install selected apps (from both tabs)
# ---------------------------------------------------------------------------
$InstallBtn.Add_Click({
    $toInstall = @()

    foreach ($id in $CuratedCheckboxes.Keys) {
        if ($CuratedCheckboxes[$id].CheckBox.IsChecked) { $toInstall += $id }
    }
    foreach ($item in $SearchItems) {
        if ($item.IsChecked) { $toInstall += $item.Id }
    }

    if ($toInstall.Count -eq 0) {
        $StatusText.Text = "Nothing selected"
        return
    }

    $InstallBtn.IsEnabled = $false
    $StatusText.Text = "Installing $($toInstall.Count) app(s)... watch the console window"

    $ps = [powershell]::Create()
    $ps.AddScript({
        param($ids)
        foreach ($id in $ids) {
            Start-Process -FilePath "winget" `
                -ArgumentList "install --id `"$id`" --accept-package-agreements --accept-source-agreements -e" `
                -Wait -NoNewWindow
        }
    }) | Out-Null
    $ps.AddArgument($toInstall) | Out-Null

    $asyncResult = $ps.BeginInvoke()

    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromMilliseconds(500)
    $timer.Add_Tick({
        if ($asyncResult.IsCompleted) {
            $timer.Stop()
            $ps.EndInvoke($asyncResult)
            $ps.Dispose()
            $StatusText.Text = "Done. Installed $($toInstall.Count) app(s)."
            $InstallBtn.IsEnabled = $true
        }
    })
    $timer.Start()
})

Update-SelectedCount
$window.ShowDialog() | Out-Null
