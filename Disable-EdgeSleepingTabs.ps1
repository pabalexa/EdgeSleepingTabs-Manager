<#
.SYNOPSIS
    Deshabilita la característica de Pestañas en Suspensión (Sleeping Tabs) en Microsoft Edge
    modificando el registro para todos los usuarios (HKLM).
.DESCRIPTION
    Este script crea o modifica la clave de registro necesaria bajo
    HKLM:\SOFTWARE\Policies\Microsoft\Edge para establecer la política
    'SleepingTabsEnabled' en 0, deshabilitando así las pestañas en suspensión.
    Requiere privilegios de administrador.
.NOTES
    Autor: Pablo Alexandre
    Fecha: 2025.04.27
    Requiere: Privilegios de Administrador, PowerShell.
#>
#Requires -RunAsAdministrator

# --- Configuración ---
# Ruta de la política de Edge en el registro para todos los usuarios
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
# Nombre de la política para habilitar/deshabilitar Sleeping Tabs
$policyName = "SleepingTabsEnabled"
# Valor para deshabilitar Sleeping Tabs (0 = deshabilitado, 1 = habilitado)
$policyValue = 0

# --- Lógica Principal ---
Write-Host "Intentando deshabilitar las Pestañas en Suspensión (Sleeping Tabs) en Microsoft Edge..."

try {
    # Verificar si la clave de directivas de Edge existe, si no, crearla
    if (-not (Test-Path $regPath)) {
        Write-Host "La ruta de registro '$regPath' no existe. Creándola..."
        New-Item -Path $regPath -Force -ErrorAction Stop
        Write-Host "Ruta creada exitosamente."
    }

    # Establecer el valor de la política para deshabilitar Sleeping Tabs
    Write-Host "Estableciendo '$policyName' en '$policyValue' en la ruta '$regPath'..."
    Set-ItemProperty -Path $regPath -Name $policyName -Value $policyValue -Type DWord -Force -ErrorAction Stop

    Write-Host ""
    Write-Host "---------------------------------------------------------------------"
    Write-Host "¡Éxito! Las Pestañas en Suspensión (Sleeping Tabs) han sido deshabilitadas."
    Write-Host "Reinicia Microsoft Edge para que los cambios surtan efecto."
    Write-Host "---------------------------------------------------------------------"
}
catch {
    Write-Error "Ocurrió un error al modificar el registro: $($_.Exception.Message)"
    # Opcional: Salir con un código de error
    # exit 1
}