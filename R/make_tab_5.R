#' Procesar datos del cuadro de población censada por tenencia de documento de identidad
#'
#' Esta función lee y procesa los datos del cuadro de población censada por tenencia de algún tipo de documento de identidad,
#' según provincia, distrito, área urbana y rural, grupos de edad y sexo.
#'
#' @param file Ruta del archivo Excel que contiene los datos.
#' @param dep_name Nombre del departamento al que pertenecen los datos.
#' @return Un tibble con los datos procesados.
#' @import readxl dplyr tidyr janitor stringr pesa
#' @export

get_tab_5 <- function(file, dep_name = NULL){
  df <- readxl::read_excel(file,
                           sheet = 5,
                           skip = 4,
                           col_names = FALSE) |>
    dplyr::select(-2) |>
    purrr::set_names(c("edad", "No_tiene_documento_alguno", "DNI",
                       "Solo_tiene_partida_de_nacimiento",
                       "Solo_tiene_carne_de_extranjería")) |>
    janitor::make_clean_names() |>
    dplyr::filter(!is.na(edad)) |>
    dplyr::filter(!stringr::str_detect(edad, "^Fuente|^1/")) |>
    dplyr::mutate(distrito = dplyr::if_else(stringr::str_detect(edad, "^DISTRITO"),
                                            edad,
                                            NA_character_)) |>
    dplyr::mutate(provincia = dplyr::if_else(stringr::str_detect(edad, "^PROVINCIA"),
                                             edad,
                                             NA_character_)) |>
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
    add_repetitions_regex("edad",
                                paste0(
                                  c(
                                    "Menores de 1 ano",
                                    "De 1 a 5 anos",
                                    "De 6 a 14 anos",
                                    "De 15 a 29 anos",
                                    "De 30 a 44 anos",
                                    "De 45 a 64 anos",
                                    "De 65 y mas anos"
                                  ),
                                  collapse = "|"
                                ),
                                new_column_name = "rango_etareo",
                                n_repetitions = 2) |>
    dplyr::mutate(
      rango_etareo = dplyr::case_when(
        edad %in% c(
          "Menores de 1 ano",
          "De 1 a 5 anos",
          "De 6 a 14 anos",
          "De 15 a 29 anos",
          "De 30 a 44 anos",
          "De 45 a 64 anos",
          "De 65 y mas anos"
        ) & is.na(rango_etareo) ~ edad,
        TRUE ~ rango_etareo
      )
    ) |>
    dplyr::mutate(sexo = dplyr::case_when(
      stringr::str_detect(edad, "^Hombres") ~ edad,
      stringr::str_detect(edad, "^Mujeres") ~ edad,
      stringr::str_detect(edad, "^URBANA") ~ edad,
      stringr::str_detect(edad, "^RURAL") ~ edad,
      TRUE ~ NA_character_
    )) |>
    tidyr::fill(sexo, .direction = "down") |>
    dplyr::filter(!is.na(distrito)) |>
    dplyr::filter(stringr::str_detect(edad, "^Hombres|^Mujeres")) |>
    dplyr::filter(edad == sexo) |>
    dplyr::filter(distribucion %in% c("URBANA", "RURAL")) |>
    dplyr::filter(!is.na(rango_etareo)) |>
    dplyr::filter(stringr::str_detect(tag, "^DISTRITO")) |>
    dplyr::mutate(
      provincia = stringr::str_remove(provincia, "PROVINCIA "),
      distrito = stringr::str_remove(distrito, "^DISTRITO ")
    ) |>
    dplyr::select(-c(edad, tag)) |>
    dplyr::mutate_all(as.character) |>
    tidyr::pivot_longer(
      -c(provincia, distrito, distribucion, sexo, rango_etareo),
      names_to = "doc_status",
      values_to = "poblacion"
    ) |>
    dplyr::mutate(poblacion = stringr::str_replace(
      poblacion,
      "-",
      NA_character_
    ) |> as.numeric()) |>
    dplyr::mutate(doc_status = stringr::str_replace_all(doc_status, "_", " ")) |>
    dplyr::mutate_if(is.character, ~toupper(.)) |>
    dplyr::mutate(departamento = {{dep_name}}) |>
    dplyr::relocate(departamento)

  return(df)
}
