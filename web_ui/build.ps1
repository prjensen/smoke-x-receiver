param(
    [string]$TGT_DIR = "."
)

if (-not (Test-Path $TGT_DIR)) {
    Write-Error "Target directory '$TGT_DIR' does not exist."
    exit 1
}

Write-Host "Installing web UI dependencies in '$TGT_DIR'..."
npm install --prefix $TGT_DIR

Write-Host "Building web UI in '$TGT_DIR'..."
npm run build --prefix $TGT_DIR

$distDir = Join-Path $TGT_DIR "dist"
if (-not (Test-Path $distDir)) {
    Write-Error "Build output directory '$distDir' was not created."
    exit 1
}

$removePatterns = @('*.js', '*.css', '*.ico', '*.html', '*.png', 'mockServiceWorker.*')
foreach ($pattern in $removePatterns) {
    Get-ChildItem -Path $distDir -Recurse -Include $pattern -File -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
}
