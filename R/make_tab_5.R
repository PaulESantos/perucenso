#' @title get_tab_5
#'
#' @description
#' Ordena los datos del Cuadro Nº 5 del Tomo I de los Resultados del Censo Nacional de 2017.
#'
#' Esta función permite organizar los datos del Cuadro Nº 5 del Tomo I de los Resultados del Censo Nacional de 2017,
#' el cual tiene el siguiente título: "DOCUMENTO DE IDENTIDAD, SEGÚN PROVINCIA, DISTRITO, ÁREA URBANA Y RURAL,
#' GRUPOS DE EDAD Y SEXO".
#'
#' @param file Ruta del archivo Excel del Tomo I de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#'
#' @export
#'
get_tab_5 <- function(file, dep_name = NULL){
  rag_label <- c(
    "Menores de 1", "De 1 a 5", "De 6 a 14", "De 15 a 29",
    "De 30 a 44", "De 45 a 64", "De 65 y mas")

  df <- readxl::read_excel(file,
                           sheet = 5,
                           skip = 4,
                           col_names = FALSE
  ) |>
    dplyr::select(-2) |>
    purrr::set_names(c(
      "edad", "DNI",
      "Solo_tiene_partida_de_nacimiento",
      "Solo_tiene_carne_de_extranjeria",
      "No_tiene_documento_alguno"
    )) |>
    janitor::clean_names() |>
    dplyr::filter(!is.na(edad)) |>
    dplyr::filter(!stringr::str_detect(edad, "^Fuente|^1/")) |>
    dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(edad, "^DISTRITO"),
                                            edad,
                                            NA_character_
    )) |>
    dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(edad, "^PROVINCIA"),
                                             edad,
                                             NA_character_
    )) |>
    dplyr::mutate(tag = dplyr::case_when(
      stringr::str_detect(edad, "DISTRITO") ~ edad,
      stringr::str_detect(edad, "PROVINCIA") ~ edad,
      stringr::str_detect(edad, "DEPARTA") ~ edad,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(tag, .direction = "down") |>
    tidyr::fill(provincia, .direction = "down") |>
    tidyr::fill(distrito, .direction = "down") |>
    dplyr::mutate(distribucion = dplyr::case_when(
      stringr::str_detect(edad, "^URBANA") ~ edad,
      stringr::str_detect(edad, "^RURAL") ~ edad,
      stringr::str_detect(edad, "^DISTRITO") ~ edad,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(distribucion, .direction = "down") |>
    dplyr::filter(!stringr::str_detect(tag, "^DEP")) |>
    dplyr::mutate(rango_etareo = dplyr::case_when(
      edad %in% rag_label ~ edad,
      edad %in% c("URBANA", "RURAL") ~ edad,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(rango_etareo, .direction = "down") |>
    dplyr::filter(!is.na(distrito)) |>
    dplyr::filter(stringr::str_detect(edad, "^Hombres|^Mujeres")) |>
    dplyr::filter(edad %in% c("Mujeres", "Hombres")) |>
    dplyr::filter(distribucion %in% c("URBANA", "RURAL")) |>
    dplyr::filter(!is.na(rango_etareo)) |>
    dplyr::filter(stringr::str_detect(tag, "^DISTRITO")) |>
    dplyr::mutate(
      provincia = stringr::str_remove(provincia, "PROVINCIA "),
      distrito = stringr::str_remove(distrito, "^DISTRITO ")
    ) |>
    dplyr::filter(!rango_etareo %in% c("URBANA", "RURAL")) |>
    dplyr::select(-tag) |>
    dplyr::mutate_all(as.character) |>
    dplyr::rename(sexo = edad) |>
    tidyr::pivot_longer(
      -c(provincia, distrito, distribucion, sexo, rango_etareo),
      names_to = "doc_status",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |>
      as.numeric()) |>
    dplyr::mutate(doc_status = stringr::str_replace_all(
      doc_status,
      "_",
      " "
    )) |>
    dplyr::mutate_if(is.character, ~ toupper(.)) |>
    dplyr::mutate(departamento = {{ dep_name }}) |>
    dplyr::relocate(departamento)
  return(df)
}
