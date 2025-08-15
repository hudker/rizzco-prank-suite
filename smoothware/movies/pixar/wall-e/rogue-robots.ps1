Add-Type -AssemblyName PresentationFramework

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Resolve image and sound paths
$imagePath = Join-Path $scriptDir "rogue-robots.png"
$soundPath = Join-Path $scriptDir "rogue-robots.mp3"

# Create fullscreen window
$window = New-Object Windows.Window
$window.WindowStyle = 'None'
$window.WindowState = 'Maximized'
$window.ResizeMode = 'NoResize'
$window.Background = 'Black'
$window.Topmost = $true

# Load image
$image = New-Object Windows.Controls.Image
$image.Source = [Windows.Media.Imaging.BitmapImage]::new([Uri]::new("file:///$imagePath"))
$image.Stretch = 'Uniform'
$window.Content = $image

# Timer to play sound after 0.1 seconds
$soundTimer = New-Object Windows.Threading.DispatcherTimer
$soundTimer.Interval = [TimeSpan]::FromMilliseconds(100)
$soundTimer.Add_Tick({
    $soundTimer.Stop()
    $player = New-Object -ComObject WMPlayer.OCX
    $player.URL = $soundPath
    $player.controls.play()
})
$soundTimer.Start()

# Auto-close after 5 seconds
$closeTimer = New-Object Windows.Threading.DispatcherTimer
$closeTimer.Interval = [TimeSpan]::FromSeconds(5)
$closeTimer.Add_Tick({ $window.Close() })
$closeTimer.Start()

# Show fullscreen image
$window.ShowDialog()
