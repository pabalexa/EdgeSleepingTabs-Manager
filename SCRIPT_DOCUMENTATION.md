## Documentación Completa: Scripts de PowerShell para Gestionar Pestañas en Suspensión (Sleeping Tabs) en Microsoft Edge

### 1. Objetivo del Código

Estos dos scripts de PowerShell están diseñados para administrar la característica "Pestañas en Suspensión" (Sleeping Tabs) en el navegador Microsoft Edge a nivel de sistema (para todos los usuarios) mediante la modificación de políticas en el Registro de Windows.

- **Script 1 (Deshabilitar):** Su propósito es **desactivar** la función de Pestañas en Suspensión. Esto evita que Edge ponga en reposo las pestañas inactivas para ahorrar recursos, lo cual puede ser útil para usuarios que experimentan recargas de página no deseadas al volver a pestañas antiguas o que necesitan que ciertas pestañas permanezcan completamente activas en segundo plano.
- **Script 2 (Revertir/Habilitar):** Su propósito es **revertir** la configuración modificada por el primer script, eliminando la política específica del registro. Esto permite que Microsoft Edge vuelva a su comportamiento **predeterminado** con respecto a las Pestañas en Suspensión (generalmente habilitadas), o que respete cualquier otra configuración aplicada (por ejemplo, desde la interfaz de usuario de Edge o GPO si está en un dominio).

Estos scripts son útiles para administradores de sistemas o usuarios avanzados que desean controlar este comportamiento de Edge de forma programática o automatizada en una o varias máquinas.

### 2. Instrucciones de Uso

**Requisitos Previos:**

- Sistema operativo Windows.
- PowerShell (generalmente versión 5.1 o superior, incluido por defecto en Windows 10/11).
- Navegador Microsoft Edge instalado.
- **Privilegios de Administrador** para ejecutar los scripts, ya que modifican la rama `HKEY_LOCAL_MACHINE` (HKLM) del registro, que afecta a todos los usuarios del sistema.

**Pasos para Ejecutar:**

1.  **Guardar los Scripts:** Guarda cada bloque de código en un archivo de texto con la extensión `.ps1`. Por ejemplo:
    - `Disable-EdgeSleepingTabs.ps1` (para el script que deshabilita)
    - `Enable-EdgeSleepingTabs.ps1` o `Revert-EdgeSleepingTabs.ps1` (para el script que revierte)
2.  **Ejecutar como Administrador:** Tienes varias formas de hacerlo:
    - **Opción A (Explorador de Archivos):** Haz clic derecho sobre el archivo `.ps1` guardado y selecciona "Ejecutar con PowerShell". Si el sistema te pide permisos elevados (Control de Cuentas de Usuario - UAC), acéptalos. _Nota: La directiva de ejecución de PowerShell (`ExecutionPolicy`) podría impedir esto. Si es así, usa la Opción B._
    - **Opción B (Consola PowerShell):**
      1.  Abre PowerShell **como Administrador** (busca PowerShell en el menú Inicio, haz clic derecho y selecciona "Ejecutar como administrador").
      2.  Navega hasta el directorio donde guardaste los archivos `.ps1` usando el comando `cd`. Ejemplo: `cd "C:\ruta\a\tus\scripts"`
      3.  Ejecuta el script deseado escribiendo su nombre. Ejemplo: `.\Disable-EdgeSleepingTabs.ps1` o `.\Revert-EdgeSleepingTabs.ps1`.
3.  **Reiniciar Microsoft Edge:** Después de ejecutar cualquiera de los scripts, cierra todas las ventanas de Microsoft Edge y vuelve a abrirlo para que los cambios en la política del registro surtan efecto. Puedes verificar el estado de la política en Edge navegando a `edge://policy`.

**Parámetros:**

- Los scripts no aceptan parámetros externos. La configuración (ruta del registro, nombre de la política, valor a establecer/eliminar) está definida directamente dentro del código en la sección `--- Configuración ---`.

### 3. Explicación del Funcionamiento

Ambos scripts siguen una estructura similar pero realizan acciones opuestas sobre el registro.

**Script 1: Deshabilitar Pestañas en Suspensión (`Disable-EdgeSleepingTabs.ps1`)**

1.  **Requisito de Administrador:** La línea `#Requires -RunAsAdministrator` asegura que el script no se ejecute si no se inicia con privilegios elevados, mostrando un error claro.
2.  **Configuración:** Define variables clave:
    - `$regPath`: La ruta en HKLM donde se aplican las políticas de Edge (`HKLM:\SOFTWARE\Policies\Microsoft\Edge`).
    - `$policyName`: El nombre exacto de la política a modificar (`SleepingTabsEnabled`).
    - `$policyValue`: El valor que deshabilita la característica (`0`).
3.  **Mensaje Inicial:** Informa al usuario que se intentará deshabilitar la característica.
4.  **Bloque `try`:** Envuelve las operaciones críticas del registro para capturar posibles errores.
5.  **Verificar/Crear Ruta:** Usa `Test-Path` para comprobar si la clave `$regPath` existe.
    - Si **no** existe, informa al usuario y la crea usando `New-Item -Path $regPath -Force`. El `-Force` ayuda a crear directorios padres si fuera necesario (aunque en este caso `Policies\Microsoft` suele existir). `-ErrorAction Stop` asegura que si `New-Item` falla, se detenga y salte al `catch`.
    - Si **sí** existe, continúa al siguiente paso.
6.  **Establecer Propiedad:** Usa `Set-ItemProperty` para crear o modificar el valor DWORD llamado `$policyName` (`SleepingTabsEnabled`) dentro de `$regPath`, asignándole el valor `$policyValue` (`0`).
    - `-Type DWord`: Especifica que el tipo de valor del registro es un número de 32 bits.
    - `-Force`: Sobrescribe el valor si ya existe.
    - `-ErrorAction Stop`: Asegura que cualquier error en esta operación salte al bloque `catch`.
7.  **Mensajes de Éxito:** Si todo va bien, muestra mensajes claros indicando que la operación fue exitosa y que se debe reiniciar Edge.
8.  **Bloque `catch`:** Si ocurre algún error dentro del bloque `try` (p. ej., permisos insuficientes a pesar de `#Requires`, ruta inválida inesperada), captura la excepción y muestra un mensaje de error descriptivo usando `Write-Error` y accediendo al mensaje de la excepción (`$_.Exception.Message`).

**Script 2: Revertir/Habilitar Pestañas en Suspensión (`Revert-EdgeSleepingTabs.ps1`)**

1.  **Requisito de Administrador:** Idéntico al Script 1.
2.  **Configuración:** Define las variables `$regPath` y `$policyName`. No necesita `$policyValue` porque la acción es eliminar la propiedad.
3.  **Mensaje Inicial:** Informa al usuario que se intentará revertir la configuración.
4.  **Bloque `try`:** Envuelve las operaciones críticas.
5.  **Verificar Ruta:** Usa `Test-Path` para comprobar si la clave `$regPath` existe.
    - Si **no** existe, informa al usuario que no hay nada que hacer (la política no está aplicada o la ruta base falta) y termina la lógica principal dentro del `try`.
    - Si **sí** existe, procede a verificar la propiedad específica.
6.  **Verificar Propiedad:** Usa `Get-ItemProperty` para intentar obtener la propiedad `$policyName` dentro de `$regPath`.
    - `-ErrorAction SilentlyContinue`: Es crucial aquí. Si la propiedad no existe, no genera un error que detenga el script, simplemente devuelve `$null`.
    - Se guarda el resultado en `$property`.
7.  **Eliminar Propiedad (si existe):** Un `if ($property)` comprueba si `Get-ItemProperty` devolvió un objeto (es decir, la propiedad existe).
    - Si **sí** existe (`$property` no es `$null`), informa al usuario y usa `Remove-ItemProperty` para eliminarla.
      - `-Force`: Ayuda a asegurar la eliminación.
      - `-ErrorAction Stop`: Asegura que si la eliminación falla (p. ej., por permisos), salte al `catch`.
    - Si **no** existe (`$property` es `$null`), informa al usuario que la propiedad ya no está presente y no se requiere ninguna acción.
8.  **Mensajes de Estado/Éxito:** Muestra mensajes apropiados según si la propiedad fue eliminada o si ya no existía. Recuerda al usuario reiniciar Edge.
9.  **Bloque `catch`:** Similar al Script 1, captura y muestra errores ocurridos durante las operaciones del registro dentro del `try`.

### 4. Detalles de los Algoritmos

Estos scripts no implementan algoritmos computacionales complejos (como ordenación, búsqueda avanzada, etc.). Su lógica se basa en:

- **Flujo de Control Secuencial:** Ejecución de comandos uno tras otro.
- **Lógica Condicional:** Uso de `if` / `else` para tomar decisiones basadas en la existencia de claves o propiedades del registro (`Test-Path`, comprobación del resultado de `Get-ItemProperty`).
- **Manejo de Errores Estructurado:** Uso de bloques `try`/`catch` para aislar operaciones propensas a fallar (interacciones con el registro) y gestionarlas de forma controlada.
- **Interacción con el Sistema Operativo:** Utilización de cmdlets específicos de PowerShell para interactuar con el Registro de Windows (`Test-Path`, `New-Item`, `Set-ItemProperty`, `Get-ItemProperty`, `Remove-ItemProperty`).

El "algoritmo" principal es la secuencia de pasos para verificar el estado actual del registro y aplicar el cambio deseado (establecer o eliminar un valor específico) de manera segura.

### 5. Explicación Técnica de los Algoritmos

- **Complejidad:** La complejidad temporal y espacial de estos scripts es muy baja, prácticamente constante O(1) en términos algorítmicos, ya que realizan un número fijo de operaciones (verificaciones y una escritura/lectura/eliminación en el registro). El tiempo real de ejecución dependerá de la velocidad de acceso al disco/registro del sistema, pero será típicamente muy rápido (milisegundos).
- **Rendimiento:** El rendimiento de los scripts en sí es excelente. La consideración de rendimiento no está en la ejecución del script, sino en el _efecto_ de la configuración que aplica:
  - **Deshabilitar Sleeping Tabs:** Puede llevar a un **mayor consumo de memoria (RAM)** por parte de Microsoft Edge, ya que las pestañas inactivas no liberarán recursos. Esto podría impactar negativamente el rendimiento general del sistema en máquinas con poca RAM.
  - **Habilitar/Revertir Sleeping Tabs:** Permite a Edge usar menos RAM al poner pestañas inactivas en suspensión, lo cual es generalmente beneficioso para el rendimiento del sistema, especialmente en equipos con recursos limitados, a costa de posibles recargas o pausas al volver a esas pestañas.
- **Elección de Cmdlets:** Se utilizan los cmdlets estándar de PowerShell para la manipulación del registro. Son la forma recomendada y robusta de interactuar con el registro en scripts.
  - `Test-Path`: Eficiente para comprobar existencia antes de actuar.
  - `*-ItemProperty`: Cmdlets específicos para trabajar con valores (propiedades) dentro de claves de registro.
  - `-ErrorAction Stop` junto con `try/catch`: Es una práctica estándar en PowerShell para un manejo de errores robusto y predecible en operaciones críticas.
  - `-Force`: Se usa para evitar errores si la clave/propiedad ya existe (en `Set-ItemProperty`) o para asegurar la creación/eliminación (aunque los permisos siguen siendo el factor principal).

### 6. Estructura del Código

Ambos scripts son archivos `.ps1` independientes y siguen una estructura similar y clara:

1.  **Bloque de Comentarios de Ayuda (Header):**
    - Usa la sintaxis `<# ... #>` para proporcionar metadatos y descripciones (Synopsis, Description, Notes) que pueden ser leídos por `Get-Help`.
    - Incluye información sobre el propósito, autor, fecha (a rellenar) y requisitos.
2.  **Declaración de Requisitos:**
    - `#Requires -RunAsAdministrator`: Directiva que fuerza la ejecución con privilegios elevados.
3.  **Sección de Configuración:**
    - Define variables (`$regPath`, `$policyName`, `$policyValue`) con comentarios explicando su propósito. Esto centraliza los valores clave y facilita su modificación si fuera necesario en el futuro.
4.  **Sección de Lógica Principal:**
    - Comienza con un `Write-Host` informativo.
    - Utiliza un bloque `try` para encapsular las operaciones principales.
    - Dentro del `try`, contiene la lógica condicional (`if`/`else`) y las llamadas a los cmdlets del registro.
    - Incluye `Write-Host` para proporcionar feedback al usuario sobre los pasos realizados y el resultado.
    - Utiliza un bloque `catch` para manejar errores que ocurran en el `try`, mostrando un mensaje con `Write-Error`.
5.  **Comentarios Inline:**
    - Utiliza `#` para comentarios de una sola línea que explican pasos específicos o decisiones dentro del código (ej: `# Verificar si la clave...`, `# Establecer el valor...`).

No hay funciones, clases o módulos definidos; son scripts lineales simples.

### 7. Ejemplos de Entrada y Salida

- **Entrada:** Los scripts no toman argumentos de línea de comandos. Su "entrada" implícita es el estado actual del Registro de Windows en la ruta `HKLM:\SOFTWARE\Policies\Microsoft\Edge`.
- **Salida:**
  1.  **Consola:** Mensajes de texto que indican:
      - La acción que se está intentando realizar.
      - Si se crea la ruta del registro (si no existía).
      - Si se establece o elimina la propiedad del registro.
      - Mensajes de éxito claros al finalizar la operación.
      - Mensajes informativos si no se requiere ninguna acción (p. ej., al intentar revertir una política que no existe).
      - Mensajes de error si algo falla durante la ejecución (p. ej., "Ocurrió un error al modificar el registro: Acceso denegado.").
  2.  **Registro de Windows:** El efecto principal es el cambio en el registro:
      - **Script 1 (Deshabilitar):** Crea o modifica el valor DWORD `SleepingTabsEnabled` en `HKLM:\SOFTWARE\Policies\Microsoft\Edge` estableciéndolo en `0`.
      - **Script 2 (Revertir):** Elimina el valor `SleepingTabsEnabled` de `HKLM:\SOFTWARE\Policies\Microsoft\Edge`, si existe.

**Ejemplo de Salida en Consola (Script 1 - Éxito, ruta no existía):**

```
Intentando deshabilitar las Pestañas en Suspensión (Sleeping Tabs) en Microsoft Edge...
La ruta de registro 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' no existe. Creándola...
Ruta creada exitosamente.
Estableciendo 'SleepingTabsEnabled' en '0' en la ruta 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'...

---------------------------------------------------------------------
¡Éxito! Las Pestañas en Suspensión (Sleeping Tabs) han sido deshabilitadas.
Reinicia Microsoft Edge para que los cambios surtan efecto.
---------------------------------------------------------------------
```

**Ejemplo de Salida en Consola (Script 2 - Éxito, propiedad existía):**

```
Intentando revertir la configuración de Pestañas en Suspensión (Sleeping Tabs) a su estado predeterminado...
Eliminando la propiedad 'SleepingTabsEnabled' de la ruta 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'...

---------------------------------------------------------------------
¡Éxito! La política 'SleepingTabsEnabled' ha sido eliminada.
La configuración de Pestañas en Suspensión se ha revertido al predeterminado.
Reinicia Microsoft Edge para que los cambios surtan efecto.
---------------------------------------------------------------------
```

**Ejemplo de Salida en Consola (Script 2 - Propiedad no existía):**

```
Intentando revertir la configuración de Pestañas en Suspensión (Sleeping Tabs) a su estado predeterminado...
La propiedad 'SleepingTabsEnabled' no existe en 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'. No se requiere ninguna acción.
La configuración ya está en el estado predeterminado (o gestionada de otra forma).
```

**Ejemplo de Salida en Consola (Error):**

```
Write-Error: Ocurrió un error al modificar el registro: Se intentó realizar una operación no autorizada.
```

### 8. Manejo de Errores

El manejo de errores se implementa a través de varios mecanismos:

1.  **`#Requires -RunAsAdministrator`:** Previene la ejecución sin los permisos necesarios, generando un error claro al inicio si no se cumple.
2.  **Bloques `try`/`catch`:** Aíslan las operaciones de registro que podrían fallar (por permisos, rutas inválidas, etc.).
3.  **`-ErrorAction Stop`:** Se usa en los cmdlets críticos dentro del `try` (`New-Item`, `Set-ItemProperty`, `Remove-ItemProperty`). Esto asegura que si uno de estos comandos genera un error _terminating_, la ejecución salte inmediatamente al bloque `catch`, en lugar de intentar continuar.
4.  **`Write-Error` en `catch`:** Muestra un mensaje de error formateado en la consola, incluyendo el mensaje específico de la excepción capturada (`$_.Exception.Message`), lo que ayuda a diagnosticar el problema.
5.  **Verificaciones explícitas (`Test-Path`, `Get-ItemProperty`):** El script de reversión comprueba explícitamente si la ruta y la propiedad existen antes de intentar eliminarlas, evitando errores innecesarios y proporcionando mensajes informativos si la acción no es necesaria. `Get-ItemProperty` usa `-ErrorAction SilentlyContinue` específicamente para suprimir el error si la propiedad no existe, permitiendo que el script lo maneje con lógica `if`.

**Depuración de Problemas Comunes:**

- **Error "Acceso denegado" o "Operación no autorizada":** Asegúrate de estar ejecutando el script desde una consola de PowerShell abierta **como Administrador**. Verifica que UAC no esté bloqueando la acción silenciosamente.
- **El script no se ejecuta (error de Directiva de Ejecución):** Puedes necesitar cambiar temporalmente la directiva de ejecución de PowerShell. Desde una consola de PowerShell como Administrador, puedes usar `Set-ExecutionPolicy RemoteSigned -Scope Process -Force` para permitir la ejecución de scripts locales en esa sesión, y luego ejecutar tu script. (Consulta `Get-Help Set-ExecutionPolicy` para más detalles y precauciones).
- **Los cambios no surten efecto en Edge:** Asegúrate de haber **reiniciado completamente** Microsoft Edge (cierra todas las ventanas, verifica en el Administrador de Tareas que no queden procesos `msedge.exe` en segundo plano, y vuelve a abrirlo). Verifica también en `edge://policy` si la política `SleepingTabsEnabled` aparece con el valor esperado (0 para deshabilitado, o ausente/sin establecer para revertido).
- **Errores inesperados en `catch`:** El mensaje proporcionado por `Write-Error` debería dar una pista. Puedes añadir más depuración dentro del `catch` o ejecutar los comandos del `try` manualmente en una consola de administrador para ver mensajes de error más detallados.

### 9. Dependencias y Requisitos

- **Sistema Operativo:** Windows (probado en Windows 10 y Windows 11, debería funcionar en versiones de servidor compatibles).
- **PowerShell:** Versión 5.1 o superior (incluida por defecto en Windows 10/11). Versiones anteriores podrían no reconocer `#Requires` o tener diferencias menores en cmdlets.
- **Software:** Microsoft Edge (basado en Chromium) debe estar instalado en el sistema.
- **Permisos:** Se requieren privilegios de Administrador local para ejecutar el script.

No hay dependencias de bibliotecas externas, módulos de PowerShell adicionales ni frameworks. Utiliza únicamente cmdlets incorporados de PowerShell.

### 10. Notas sobre Rendimiento y Optimización

- **Rendimiento del Script:** La ejecución de los scripts es extremadamente rápida y eficiente. Las operaciones de registro son ligeras. No hay bucles ni operaciones computacionalmente intensivas.
- **Optimización:** Los scripts ya son bastante óptimos para su propósito:
  - Usan `Test-Path` para evitar intentos innecesarios de crear claves que ya existen (Script 1) o actuar sobre rutas inexistentes (Script 2).
  - El Script 2 usa `Get-ItemProperty` para verificar la existencia de la propiedad antes de intentar eliminarla, evitando errores y operaciones innecesarias.
- **Impacto en el Sistema (Post-Ejecución):** La principal consideración de rendimiento, como se mencionó antes, es el efecto de la _política_ que se aplica:
  - Deshabilitar Sleeping Tabs (`SleepingTabsEnabled=0`) **aumentará el consumo de RAM** de Edge.
  - Habilitar Sleeping Tabs (eliminando la política) permite a Edge **reducir su consumo de RAM** a lo largo del tiempo.
  - No hay un impacto significativo en el rendimiento de la CPU o del disco atribuible directamente a la _presencia_ de esta clave de registro en sí.

### 11. Comentarios dentro del Código

El código proporcionado ya incluye comentarios claros y útiles:

- **Bloque de Ayuda/Sinopsis:** `<# ... #>` al inicio describe el propósito general, cómo funciona a alto nivel y los requisitos.
- **Comentarios de Configuración:** Cada variable en la sección `--- Configuración ---` tiene un comentario `#` explicando qué representa.
- **Comentarios de Lógica:** Hay comentarios `#` antes de bloques lógicos clave (p. ej., `# Verificar si la clave...`, `# Establecer el valor...`, `# Eliminar la propiedad...`) que explican la intención del siguiente comando o bloque de comandos.
