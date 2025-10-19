# status-check.ps1 - Esto sirve para verificar el estado del ambiente de PromptSales en Kubernetes
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  PromptSales - Status Check  " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: kubectl no instalado" -ForegroundColor Red
    exit 1
}

Write-Host "[1/5] Estado del cluster..." -ForegroundColor Yellow
kubectl cluster-info --request-timeout=5s 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "OK Kubernetes corriendo" -ForegroundColor Green
} else {
    Write-Host "X Kubernetes NO corriendo" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "[2/5] Verificando namespaces..." -ForegroundColor Yellow
$namespaces = @("promptsales", "promptcontent", "promptads", "promptcrm", "redis")
foreach ($ns in $namespaces) {
    $exists = kubectl get namespace $ns --ignore-not-found=true 2>$null
    if ($exists) {
        Write-Host "  OK $ns" -ForegroundColor Green
    } else {
        Write-Host "  X $ns no existe" -ForegroundColor Red
    }
}
Write-Host ""

Write-Host "[3/5] Estado de los pods..." -ForegroundColor Yellow
kubectl get pods --all-namespaces | Select-String "prompt|redis"
Write-Host ""

Write-Host "[4/5] Servicios..." -ForegroundColor Yellow
Write-Host "  PostgreSQL: localhost:30432" -ForegroundColor White
Write-Host "  MongoDB:    localhost:30017" -ForegroundColor White
Write-Host "  SQL Ads:    localhost:31433" -ForegroundColor White
Write-Host "  SQL CRM:    localhost:32433" -ForegroundColor White
Write-Host "  Redis:      localhost:30379" -ForegroundColor White
Write-Host ""

Write-Host "[5/5] Credenciales..." -ForegroundColor Yellow
Write-Host "PostgreSQL: user=postgres, pass=postgres123" -ForegroundColor Gray
Write-Host "MongoDB:    user=mongouser, pass=mongo123" -ForegroundColor Gray
Write-Host "SQL Server: user=sa, pass=YourStrong!Passw0rd" -ForegroundColor Gray
Write-Host "Redis:      pass=redis123" -ForegroundColor Gray
Write-Host ""
Write-Host "Listo!" -ForegroundColor Green