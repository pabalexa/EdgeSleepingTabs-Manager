<#
.SYNOPSIS
    Revierte la configuración de las Pestañas en Suspensión (Sleeping Tabs) en Microsoft Edge
    a su estado predeterminado (habilitadas) eliminando la política del registro (HKLM).
.DESCRIPTION
    Este script elimina la propiedad 'SleepingTabsEnabled' de la clave de registro
    HKLM:\SOFTWARE\Policies\Microsoft\Edge, permitiendo que Edge use su
    comportamiento predeterminado para las pestañas en suspensión.
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

# --- Lógica Principal ---
Write-Host "Intentando revertir la configuración de Pestañas en Suspensión (Sleeping Tabs) a su estado predeterminado..."

try {
    # Verificar si la clave de directivas de Edge existe
    if (Test-Path $regPath) {
        # Verificar si la propiedad específica existe antes de intentar eliminarla
        $property = Get-ItemProperty -Path $regPath -Name $policyName -ErrorAction SilentlyContinue
        if ($property) {
            Write-Host "Eliminando la propiedad '$policyName' de la ruta '$regPath'..."
            Remove-ItemProperty -Path $regPath -Name $policyName -Force -ErrorAction Stop
            Write-Host ""
            Write-Host "---------------------------------------------------------------------"
            Write-Host "¡Éxito! La política '$policyName' ha sido eliminada."
            Write-Host "La configuración de Pestañas en Suspensión se ha revertido al predeterminado."
            Write-Host "Reinicia Microsoft Edge para que los cambios surtan efecto."
            Write-Host "---------------------------------------------------------------------"
        }
        else {
            Write-Host "La propiedad '$policyName' no existe en '$regPath'. No se requiere ninguna acción."
            Write-Host "La configuración ya está en el estado predeterminado (o gestionada de otra forma)."
        }
    }
    else {
        Write-Host "La ruta de registro '$regPath' no existe. No se requiere ninguna acción."
        Write-Host "La configuración ya está en el estado predeterminado (o gestionada de otra forma)."
    }
}
catch {
    Write-Error "Ocurrió un error al modificar el registro: $($_.Exception.Message)"
    # Opcional: Salir con un código de error
    # exit 1
}