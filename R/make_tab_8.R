#' Procesar datos del cuadro de población censada de 5 y más años de edad por sexo y grupos de edad
#'
#' Esta función lee y procesa los datos del cuadro de población censada de 5 y más años de edad por sexo y grupos de edad,
#' según lugar de residencia permanente hace cinco años, dentro y fuera del país.
#'
#' @param file Ruta del archivo Excel que contiene los datos.
#' @param sheet Número de la hoja en el archivo Excel que contiene los datos.
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#' @return Un tibble con los datos procesados.
#' @import readxl dplyr tidyr janitor stringr
#' @export
#' @examples
get_tab_8 <- function(file, sheet, dep_name = NULL) {
  df <- readxl::read_xlsx(file, sheet = sheet, skip = 4, col_names = FALSE)|>
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

}