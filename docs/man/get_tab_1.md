

# read_pob_tab_1

[**Source code**](https://github.com/PaulESantos/perucenso/tree/master/R/make_tab_1.R#L23)

## Description

Los datos son tomados desde la plataforma del INSTITUTO NACIONAL DE
ESTADÍSTICA E INFORMÁTICA - INEI
https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/

## Usage

<pre><code class='language-R'>get_tab_1(file, dep_name = NULL)
</code></pre>

## Arguments

<table>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="get_tab_1_:_file">file</code>
</td>
<td>
Ruta del archivo.
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

## Details

Lee la información del cuadro "POBLACIÓN CENSADA, POR ÁREA URBANA Y
RURAL; Y SEXO, SEGÚN PROVINCIA, DISTRITO Y EDADES SIMPLES" y genera una
tabla en formato tidy.

Esta función toma como argumentos el archivo donde se encuentra el
cuadro y el nombre del departamento.

## Value

Un tibble que muestra datos demográficos desglosados por: departamento,
provincia, distrito, distribución (urbano/rural), sexo, edad y
población.
