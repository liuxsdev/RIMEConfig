# 获取当前用户的AppData目录路径
$appDataPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
$rimePath = Join-Path $appDataPath "Rime"

# 如果Rime目录不存在，创建它
if (-not (Test-Path $rimePath)) {
    New-Item -Path $rimePath -ItemType Directory
}

# 获取当前脚本所在的目录路径
$currentDirectory = Get-Location

# 获取当前目录下的所有YAML文件
$yamlFiles = Get-ChildItem -Path $currentDirectory -Filter "*.yaml" -File

# 拷贝YAML文件到Rime目录
foreach ($file in $yamlFiles) {
    $destinationPath = Join-Path $rimePath $file.Name
    Copy-Item -Path $file.FullName -Destination $destinationPath -Force
    Write-Host "Copied $($file.Name) to $rimePath"
}

# 拷贝custom_phrase
$custom_phrase = Join-Path $currentDirectory "custom_phrase.txt"
$dest_custom_phrase = Join-Path $rimePath "custom_phrase.txt"
Copy-Item -Path $custom_phrase -Destination $dest_custom_phrase -Force
Write-Host "Copied $custom_phrase to $dest_custom_phrase"

# 定义需要拷贝的文件夹
$foldersToCopy = @("dict", "icon","lua","opencc")

# 遍历需要拷贝的文件夹并拷贝文件
foreach ($folder in $foldersToCopy) {
    $sourceFolderPath = Join-Path $currentDirectory $folder
    $destinationFolderPath = Join-Path $rimePath $folder

    # 如果目标文件夹不存在，创建它
    if (-not (Test-Path $destinationFolderPath)) {
        New-Item -Path $destinationFolderPath -ItemType Directory
    }

    # 获取文件夹内的所有文件
    $folderFiles = Get-ChildItem -Path $sourceFolderPath -File

    # 拷贝文件夹内的所有文件到Rime目录
    foreach ($file in $folderFiles) {
        $destinationPath = Join-Path $destinationFolderPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Copied $($file.Name) to $destinationFolderPath"
    }
}

Write-Host "All files and folders copied to $rimePath"

# 重新部署

$rimeInstallDir = [Environment]::GetEnvironmentVariable("RIME_INSTALL_DIR")

# Write-Host "Rime install dir: $rimeInstallDir"
# # 检查环境变量是否存在
if ([string]::IsNullOrWhiteSpace($rimeInstallDir)) {
    Write-Host "RIME_INSTALL_DIR not set"
} else {
    Write-Host "Rime install dir: $rimeInstallDir"
    $deployerPath = Join-Path $rimeInstallDir "WeaselDeployer.exe"
    Invoke-Expression -Command "$deployerPath /deploy"
}