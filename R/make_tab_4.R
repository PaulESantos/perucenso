#' @title get_tab_4
#'
#' @description
#' Ordena los datos del Cuadro Nº 4 del Tomo I de los Resultados del Censo Nacional de 2017.
#'
#' Esta función permite organizar los datos del Cuadro Nº 5 del Tomo I de los Resultados del Censo Nacional de 2017,
#' el cual tiene el siguiente título: "POBLACIÓN CENSADA EN VIVIENDAS PARTICULARES,
#' POR GRUPOS DE EDAD, SEGÚN PROVINCIA, DISTRITO, ÁREA URBANA Y RURAL, SEXO Y RELACIÓN
#' DE PARENTESCO CON EL JEFE O JEFA DEL HOGAR".
#'
#' @param file Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#'
#' @examples
#' \dontrun{
#' df <-  get_tab_4("rawdata/08TOMO_01.xlsx", dep_name = "CUSCO")
#' }
#'
#' @export
get_tab_4 <- function(file, dep_name = NULL) {
   readxl::read_excel(file,
                      sheet = 4,
                      col_names = FALSE,
                      skip = 4) |>
     dplyr::select(-2) |>
     purrr::set_names(c("parentesco", "Menores de 1 ano", "1 a 14", "15 a 29",
                        "30 a 44", "45 a 64", "65 y mas") |>
                        janitor::make_clean_names() ) |>
     dplyr::filter(!is.na(parentesco)) |>
     dplyr::filter(!stringr::str_detect(parentesco, "^Fuente")) |>
     dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(parentesco, "^DISTRITO"),
                                             parentesco,
                                             NA_character_)) |>
     dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(parentesco, "^PROVINCIA"),
                                              parentesco,
                                              NA_character_)) |>
     tidyr::fill(provincia, .direction = "down") |>
     tidyr::fill(distrito, .direction = "down") |>
     dplyr::mutate(distribucion = dplyr::case_when(
       stringr::str_detect(parentesco, "^URBANA") ~ parentesco,
       stringr::str_detect(parentesco, "^RURAL") ~ parentesco,
       stringr::str_detect(parentesco, "^DISTRITO") ~ parentesco,
       TRUE ~ NA_character_
     )) |>
     tidyr::fill(distribucion, .direction = "down") |>
     dplyr::mutate(sexo = dplyr::case_when(
       stringr::str_detect(parentesco, "^Hombres") ~ parentesco,
       stringr::str_detect(parentesco, "^Mujeres") ~ parentesco,
       stringr::str_detect(parentesco, "^URBANA") ~ parentesco,
       stringr::str_detect(parentesco, "^RURAL") ~ parentesco,
       TRUE ~ NA_character_
     )) |>
     tidyr::fill(sexo, .direction = "down") |>
     dplyr::filter(stringr::str_detect(sexo, "^Hombres|^Mujeres")) |>
     dplyr::filter(!is.na(distrito)) |>
     dplyr::filter(parentesco != distrito) |>
     dplyr::filter(parentesco != sexo) |>
     dplyr::filter(distribucion %in% c("URBANA", "RURAL")) |>
     dplyr::mutate(provincia = stringr::str_remove(provincia, "PROVINCIA "),
                   distrito = stringr::str_remove(distrito, "^DISTRITO ")) |>
     tidyr::pivot_longer(-c(provincia, distrito, distribucion, sexo, parentesco),
                         names_to = "rango_etareo",
                         values_to = "poblacion") |>
     dplyr::mutate(poblacion = stringr::str_replace(poblacion,
                                                    "-",
                                                    NA_character_)) |>
     dplyr::mutate(rango_etareo = stringr::str_remove(rango_etareo,
                                                      "^x")) |>
     dplyr::mutate(departamento = {{dep_name}}) |>
     dplyr::relocate(departamento)
}

