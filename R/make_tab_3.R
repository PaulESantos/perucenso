#' @title get_tab_3
#'
#' @description
#'
#' Esta función permite organizar los datos del Cuadro Nº 3 del Tomo I de los Resultados del Censo Nacional de 2017,
#' el cual tiene el siguiente título: "POBLACION CENSADA EN VIVIENDAS PARTICULARES, POR GRUPOS DE EDAD
#'
#' @param file Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#'
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble ordenado con la informacion procesada.
#'
#' @examples
#' \dontrun{
#' df <- get_tab_3("rawdata/08TOMO_01.xlsx", dep_name = "CUSCO")
#' }
#'
#' @export
get_tab_3 <- function(file, dep_name = NULL) {
  df <- readxl::read_excel(file, sheet = 3, skip = 4, col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(c("tipo_vivienda", "Menores de 1 ano",
                       "de 1 a 14 anos", "de 15 a 29 anos",
                       "de 30 a 44 anos", "de 45 a 64 anos",
                       "de 65 y mas anos") |>
                       janitor::make_clean_names()) |>
    dplyr::filter(!is.na(tipo_vivienda)) |>
    dplyr::filter(!stringr::str_detect(tipo_vivienda, "^1/")) |>
    dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(tipo_vivienda, "^DISTRITO"),
                                            tipo_vivienda,
                                            NA_character_)) |>
    dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(tipo_vivienda, "^PROVINCIA"),
                                             tipo_vivienda,
                                             NA_character_)) |>
    dplyr::mutate(tag = dplyr::case_when(
      !is.na(distrito) ~ distrito,
      !is.na(provincia) ~ provincia,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(tag, .direction = "down") |>
    tidyr::fill(provincia, .direction = "down") |>
    dplyr::filter(!stringr::str_detect(tag, "^PROVI")) |>
    dplyr::mutate(urbana = dplyr::if_else(stringr::str_detect(tipo_vivienda, "URBANA"),
                                          tipo_vivienda,
                                          NA_character_
    )) |>
    dplyr::mutate(rural = dplyr::if_else(stringr::str_detect(tipo_vivienda, "RURAL"),
                                         tipo_vivienda,
                                         NA_character_
    )) |>
    tidyr::fill(distrito, .direction = "down") |>
    dplyr::mutate(tag2 = dplyr::case_when(
      !is.na(urbana) ~ urbana,
      !is.na(rural) ~ rural,
      stringr::str_detect(tipo_vivienda, "^DISTRITO") ~ tipo_vivienda,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(tag2, .direction = "down") |>
    dplyr::filter(!stringr::str_detect(tag2, "^DISTRI")) |>
    dplyr::filter(tipo_vivienda != tag2) |>
    dplyr::select(provincia, distrito, ubicacion = tag2,
                  tipo_vivienda, menores_de_1_ano:de_65_y_mas_anos) |>
    dplyr::mutate(provincia = stringr::str_remove(provincia, "^PROVINCIA "),
                  distrito = stringr::str_remove(distrito, "^DISTRITO ")) |>
    tidyr::pivot_longer(-c(1:4),
                        names_to = "rango_etareo",
                        values_to = "poblacion") |>
    dplyr::mutate(poblacion = stringr::str_replace(poblacion,
                                                   "-",
                                                   NA_character_) |>
                    as.numeric())

  return(df |>
           dplyr::mutate(departamento = {{dep_name}}) |>
           dplyr::relocate(departamento)
    )
}
