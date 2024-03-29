% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_tab_2.R
\name{get_tab_2}
\alias{get_tab_2}
\title{get_tab_2}
\usage{
get_tab_2(file, dep_name = NULL)
}
\arguments{
\item{file}{Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
(https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).}

\item{dep_name}{Nombre del departamento al que pertenecen los datos.}
}
\value{
Un tibble con los datos ordenados en formato largo.
}
\description{
Ordena los datos del Cuadro Nº 2 del Tomo I de los Resultados del Censo Nacional de 2017.

Esta función permite organizar los datos del Cuadro Nº 2 del Tomo I de los Resultados del Censo Nacional de 2017,
el cual tiene el siguiente título: "POBLACIÓN CENSADA, POR GRUPOS DE EDAD, SEGÚN PROVINCIA,
DISTRITO, ÁREA URBANA Y RURAL, TIPO DE VIVIENDA Y SEXO".
}
