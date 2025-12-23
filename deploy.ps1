# Flutter Web Deployment Script for Vercel (PowerShell)

Write-Host "🚀 Starting Flutter Web Deployment to Vercel..." -ForegroundColor Green

# Clean previous build
Write-Host "🧹 Cleaning previous build..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Cyan
flutter pub get

# Build for web
Write-Host "🔨 Building Flutter web app..." -ForegroundColor Magenta
flutter build web --release

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful!" -ForegroundColor Green
    
    # Navigate to build directory
    Set-Location build\web
    
    # Check if vercel.json exists
    if (!(Test-Path "vercel.json")) {
        Write-Host "⚠️  vercel.json not found, creating default..." -ForegroundColor Yellow
        $vercelConfig = @{
            version = 2
            builds = @{
                src = "web"
                use = "@vercel/static"
                config = @{
                    source = "web/build"
                }
            }
            routes = @{
                src = "web"
                dest = "/"
            }
        }
        $vercelConfig | ConvertTo-Json | Out-File -FilePath "vercel.json" -Encoding utf8
    }
    
    # Deploy to Vercel
    Write-Host "🌐 Deploying to Vercel..." -ForegroundColor Blue
    vercel --prod
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "🎉 Deployment successful!" -ForegroundColor Green
        Write-Host "📱 Your app is now live on Vercel!" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Deployment failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}
