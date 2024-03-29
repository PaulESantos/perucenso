

## get_tab_1

### Description

Esta función permite organizar los datos del Cuadro Nº 1 del Tomo I de
los Resultados del Censo Nacional de 2017, el cual tiene el siguiente
título: "POBLACIÓN CENSADA, POR ÁREA URBANA Y RURAL; Y SEXO, SEGÚN
PROVINCIA, DISTRITO Y EDADES SIMPLES"

### Usage

<pre><code class='language-R'>get_tab_1(file, dep_name = NULL)
</code></pre>

### Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_1_:_file">file</code>
</td>
<td>
Ruta del archivo Excel del Tomo I de los datos descargados desde la
página del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_1_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento al que pertenecen los datos.
</td>
</tr>
</table>

### Value

Un tibble con los datos ordenados en formato largo.
