# 定义提醒的声音文件路径
$soundPath = "C:\CreativeProjects\TTS tests\MDX Cursing.wav"
$remindInMinutes = 70

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName "System.Drawing"


$remindText = "
你坐那儿，像根钉子，钉在了时光的裂缝里，一动不动，难道你打算钉成永恒？

椅子成了你的第二张床，脊椎弯成了问号，血液慢成了蜗牛，肌肉软成了棉花糖，可你还笑得出来？

哦，年轻人，你总以为时间还长，健康可以挥霍。但你知不知道，那些小病小痛正排着队，拿着号码牌，等着在你身上开派对？

心脏说：我要罢工！肺说：我也累了！可你还沉浸在虚拟的世界里，忘记了肉体需要的是真实。

站起来！哪怕是晃两下也好啊！这不是为了别的，为了你的屁股不再跟椅子黏在一起，为了你的灵魂还能感受到风的拥抱。

你知道吗？站着，你的大脑会跳起欢快的踢踏舞，创意会像喷泉一样涌出来。坐着，你可能会变成一块石头，连思想都僵硬了。

别让椅子变成你的棺材，别让懒惰成为你的墓志铭。站起来，去看看窗外的世界，哪怕只是为了证明自己还有脚！

你说没时间？你确定？没时间动，有的是时间生病。到时候，你的时间全耗在医院的走廊上，这划算吗？

定个闹钟吧，每60分钟，给自己5分钟的自由。这5分钟不是浪费，它是投资，是你对未来健康的预付款。

别等身体发出了警报才后悔，那时候，你只能怪自己当初太固执。预防永远比治疗酷炫，就像提前知道结局的侦探小说，总是那么令人着迷。

所以，现在，立刻，马上，站起来！哪怕只是为了看看天花板上的蜘蛛有没有织好它的网。

记住：坐着不动，就像是一只蜗牛背着壳，在原地打转；而站起来，你就是那只甩掉壳的蜗牛，准备征服整个后花园。选哪条路，由你自己决定。
"

# 检查声音文件是否存在
if (!(Test-Path $soundPath)) {
    Write-Host "Error: Sound file not found at $soundPath"
    Exit
}

# 定义播放声音的函数
Function Play-Sound {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SoundFilePath
    )
    
    $player = New-Object Media.SoundPlayer $soundPath
    $player.Play()
}

Function Start-Countdown 
{   <#
    .SYNOPSIS
        Provide a graphical countdown if you need to pause a script for a period of time
    .PARAMETER Seconds
        Time, in seconds, that the function will pause
    .PARAMETER Messge
        Message you want displayed while waiting
    .EXAMPLE
        Start-Countdown -Seconds 30 -Message Please wait while Active Directory replicates data...
    .NOTES
        Author:            Martin Pugh
        Twitter:           @thesurlyadm1n
        Spiceworks:        Martin9700
        Blog:              www.thesurlyadmin.com
       
        Changelog:
           2.0             New release uses Write-Progress for graphical display while couting
                           down.
           1.0             Initial Release
    .LINK
        http://community.spiceworks.com/scripts/show/1712-start-countdown
    #>
    Param(
        [Int32]$Seconds = 10,
        [string]$Message = "Pausing for 10 seconds..."
    )
    ForEach ($Count in (1..$Seconds))
    {   Write-Progress -Id 1 -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $Count) left" -PercentComplete (($Count / $Seconds) * 100)
        Start-Sleep -Seconds 1
    }
    Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}

Function StandupAlert{
    # 播放声音
    Play-Sound -SoundFilePath $soundPath
    
    # 最小化所有桌面窗口
    $shell = New-Object -ComObject Shell.Application
    $shell.MinimizeAll()
    
    # 创建全屏窗口
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Reminder"
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
    $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
    
    # 设置窗口背景颜色
    $form.BackColor = [System.Drawing.Color]::LightBlue
    
    # 添加提示文本
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $remindText
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Arial", 20)
    $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $label.Dock = [System.Windows.Forms.DockStyle]::Fill
    $form.Controls.Add($label)
    
    # 添加按钮
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Click to Continue"
    $button.Font = New-Object System.Drawing.Font("Arial", 16)
    $button.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $button.Height = 60
    $button.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($button)
    
    # 显示窗口
    $form.ShowDialog()
    # 等待2秒
    Start-Sleep -Seconds 2
}


# 主循环
while ($true) {
    Write-Host "Work Work!~"
    # 等待一小时

    Start-Countdown -Seconds ($remindInMinutes * 60) -Message "Working for 1 hour..."
    # 播放声音提醒
    Play-Sound -SoundFilePath $soundPath
    
    # 显示提醒消息
    Write-Host "It's time to stand up and stretch!"

    # cycle StandupAlert 3 times
    for ($i = 1; $i -le 3; $i++) {
        StandupAlert
    }
}

