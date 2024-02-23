

# Procesar datos del cuadro de población censada por sexo y grupos de edad según lugar de residencia de la madre cuando usted nació

## Description

Esta función lee y procesa los datos del cuadro de población censada por
sexo y grupos de edad, según lugar de residencia de la madre cuando
usted nació, dentro y fuera del país.

## Usage

<pre><code class='language-R'>get_tab_9(file, sheet, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_9_:_file">file</code>
</td>
<td>
Ruta del archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_9_:_sheet">sheet</code>
</td>
<td>
Número de la hoja en el archivo Excel que contiene los datos.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_9_:_dep_name">dep_name</code>
</td>
<td>
Nombre del departamento al que pertenecen los datos.
</td>
</tr>
</table>

## Value

Un tibble con los datos procesados.