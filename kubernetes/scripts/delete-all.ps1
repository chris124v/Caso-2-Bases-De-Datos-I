# delete-all.ps1 - Elimina y limpia todo 


Write-Host "=====================================" -ForegroundColor Red
Write-Host "  PromptSales - Cleanup Script  " -ForegroundColor Red
Write-Host "=====================================" -ForegroundColor Red
Write-Host ""
Write-Host "ADVERTENCIA: Esto eliminara TODOS los recursos de PromptSales" -ForegroundColor Yellow
Write-Host ""

$confirmation = Read-Host "Estas seguro? (escribe SI para confirmar)"

if ($confirmation -ne "SI") {
    Write-Host "Operacion cancelada." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Iniciando eliminacion..." -ForegroundColor Red
Write-Host ""

if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: kubectl no instalado" -ForegroundColor Red
    exit 1
}

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$kubernetesPath = Split-Path -Parent $scriptPath
Set-Location $kubernetesPath

Write-Host "[1/4] Eliminando recursos de bases de datos..." -ForegroundColor Yellow
kubectl delete -f databases/postgresql/ --ignore-not-found=true
kubectl delete -f databases/mongodb/ --ignore-not-found=true
kubectl delete -f databases/sqlserver-ads/ --ignore-not-found=true
kubectl delete -f databases/sqlserver-crm/ --ignore-not-found=true
kubectl delete -f databases/redis/ --ignore-not-found=true
Write-Host "OK Recursos eliminados" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] Esperando..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host "OK" -ForegroundColor Green
Write-Host ""

Write-Host "[3/4] Eliminando secrets..." -ForegroundColor Yellow
kubectl delete -f secrets/all-secrets.yaml --ignore-not-found=true
Write-Host "OK Secrets eliminados" -ForegroundColor Green
Write-Host ""

Write-Host "[4/4] Eliminando namespaces..." -ForegroundColor Yellow
kubectl delete -f namespaces/all-namespaces.yaml --ignore-not-found=true
Write-Host "OK Namespaces eliminados" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 5

Write-Host "=====================================" -ForegroundColor Green
Write-Host "  Limpieza completada!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para redesplegar: .\deploy-all.ps1" -ForegroundColor Cyan
Write-Host ""