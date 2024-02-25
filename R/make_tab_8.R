#' @title get_tab_8
#'
#' @description
#' Ordena los datos del Cuadro Nº 8 del Tomo II de los Resultados del Censo Nacional de 2017.
#'
#' Esta función permite organizar los datos del Cuadro Nº 8 del Tomo II de los
#' Resultados del Censo Nacional de 2017, el cual tiene el siguiente título:
#' POBLACIÓN CENSADA DE 5 Y MÁS AÑOS DE EDAD, POR SEXO Y GRUPOS DE EDAD, SEGÚN
#' LUGAR DE RESIDENCIA PERMANENTE HACE CINCO AÑOS, DENTRO Y FUERA DEL PAÍS
#'
#' @param file Ruta del archivo Excel del Tomo II de los datos descargados desde la página del INEI
#' (https://censo2017.inei.gob.pe/resultados-definitivos-de-los-censos-nacionales-2017/).
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#'
#' @return Un tibble con los datos ordenados en formato largo.
#' @export
#'
get_tab_8 <- function(file, dep_name = NULL) {
  df <- readxl::read_xlsx(file, sheet = 3, skip = 4, col_names = FALSE)|>
    dplyr::select(-c(2, 5)) |>
    purrr::set_names(c(
      "residencia",
      "Hombres",
      "Mujeres",
      "5 a 14 años",
      "15 a 29 años",
      "30 a 44 años",
      "45 a 64 años",
      "65 y más años"
    ) |>
      janitor::make_clean_names()) |>
    dplyr::filter(!stringr::str_detect(residencia, "^1/")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(residencia, "^DEP|^DPT") ~ residencia,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(departamento, .direction = "down") |>
    dplyr::relocate(departamento) |>
    dplyr::filter(!stringr::str_detect(residencia, "^DEP|^DPT")) |>
    dplyr::mutate(departamento = dplyr::case_when(
      stringr::str_detect(residencia, "^EX") ~ residencia,
      stringr::str_detect(residencia, "PROV\\.") ~ residencia,
      TRUE ~ departamento
    )) |>
    dplyr::mutate(departamento = stringr::str_remove(departamento, "^DPTO\\.") |>
                    stringr::str_squish()) |>
    dplyr::mutate(dplyr::across(
      .cols = hombres:x65_y_mas_anos,
      ~ dplyr::if_else(. == "-", "0", .) |> as.numeric()
    )) |>
    tidyr::pivot_longer(
      cols = hombres:x65_y_mas_anos,
      names_to = "varname",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(tipo = dplyr::case_when(
      varname %in% c("hombres", "mujeres") ~ "sexo",
      TRUE ~ "rango etareo"
    )) |>
    dplyr::mutate(varname = stringr::str_replace(varname, "^x", "") |>
                    stringr::str_replace_all("_", " ")) |>
    dplyr::mutate(dplyr::across(
      .cols = c(varname, tipo),
      ~ stringr::str_to_sentence(.)
    )) |>
    dplyr::mutate(varname = stringr::str_replace(
      varname,
      "ano", "año"
    )) |>
    dplyr::mutate(dep_name = {{dep_name}}) |>
    dplyr::relocate(dep_name)
return(df)
}
