#' @title get_tab_2
#'
#' @description
#' Ordena los datos del Cuadro Nº 2 del Tomo I de los Resultados del Censo Nacional de 2017.
#'
#' Esta función permite organizar los datos del Cuadro Nº 2 del Tomo I de los Resultados del Censo Nacional de 2017,
#' el cual tiene el siguiente título: "POBLACIÓN CENSADA, POR GRUPOS DE EDAD, SEGÚN PROVINCIA,
#' DISTRITO, ÁREA URBANA Y RURAL, TIPO DE VIVIENDA Y SEXO".
#'
#' @param file Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#'
#' @export
#'
get_tab_2 <- function(file, dep_name = NULL){
  df <- readxl::read_excel(file,
                           sheet = 2,
                           skip = 4,
                           col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(c("sexo",
                       "Menores de 1",
                       "1 a 14",
                       "15 a 29",
                       "30 a 44",
                       "45 a 64",
                       "65 y mas")) |>
    janitor::clean_names() |>
    dplyr::filter(!is.na(sexo)) |>
    dplyr::filter(!stringr::str_detect(sexo, "^Fuente|^1/")) |>
    dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(sexo,
                                                                "^DISTRITO"),
                                            sexo,
                                            NA_character_)) |>
    dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(sexo,
                                                                 "^PROVINCIA"),
                                             sexo,
                                             NA_character_)) |>
    dplyr::mutate(tag = dplyr::case_when(
      stringr::str_detect(sexo, "DISTRITO") ~ sexo,
      stringr::str_detect(sexo, "PROVINCIA") ~ sexo,
      stringr::str_detect(sexo, "DEPARTA") ~ sexo,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(tag, .direction = "down") |>
    tidyr::fill(provincia, .direction = "down") |>
    tidyr::fill(distrito, .direction = "down") |>
    dplyr::mutate(distribucion = dplyr::case_when(
      stringr::str_detect(sexo, "^URBANA") ~ sexo,
      stringr::str_detect(sexo, "^RURAL") ~ sexo,
      stringr::str_detect(sexo, "^DISTRITO") ~ sexo,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(distribucion, .direction = "down") |>
    dplyr::filter(!stringr::str_detect(tag, "^DEP")) |>
    dplyr::mutate(vivienda = dplyr::case_when(
      sexo %in% c("Viviendas particulares",
                  "Viviendas colectivas", "Otro tipo 1/" ) ~ sexo,
      sexo %in% c("URBANA", "RURAL") ~ sexo,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(vivienda, .direction = "down") |>
    dplyr::filter(!is.na(distrito)) |>
    dplyr::filter(stringr::str_detect(sexo, "^Hombres|^Mujeres")) |>
    dplyr::filter(distribucion %in% c("URBANA", "RURAL")) |>
    dplyr::filter(!is.na(vivienda)) |>
    dplyr::filter(stringr::str_detect(tag, "^DISTRITO")) |>
    dplyr::mutate(
      provincia = stringr::str_remove(provincia, "PROVINCIA "),
      distrito = stringr::str_remove(distrito, "^DISTRITO ")
    ) |>
    dplyr::filter(!vivienda %in% c("URBANA", "RURAL") ) |>
    dplyr::mutate(vivienda = dplyr::if_else(vivienda == "Otro tipo 1/",
                                            "Otro tipo",
                                            vivienda)) |>
    dplyr::select(-tag) |>
    dplyr::mutate_all(as.character) |>
    tidyr::pivot_longer(
      -c(provincia, distrito, distribucion, sexo, vivienda),
      names_to = "rango_etareo",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |>
      as.numeric()) |>
    dplyr::mutate(rango_etareo = stringr::str_remove(rango_etareo, "^x") |>
                    stringr::str_squish() |>
                    stringr::str_replace_all("_", " ")) |>
    dplyr::mutate_if(is.character, ~ toupper(.)) |>
    dplyr::mutate(departamento = {{ dep_name }}) |>
    dplyr::select(departamento, provincia, distrito, distribucion, vivienda,
                  sexo, rango_etareo, poblacion)
  return(df)

}
