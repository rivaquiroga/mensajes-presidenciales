# librerias ---------------------------------------------------------------
if (!require("pacman")) { install.packages("pacman") }
pacman::p_load(readr, dplyr, stringr, stringi, purrr, tidyr)

archivos_txt <- list.files(path = "archivos_txt", pattern = "1\\.txt", full.names = T)
archivos_txt_utf8 <- str_replace(archivos_txt, "\\.txt", "_utf8\\.txt")

arreglar_encoding <- function (t) {
  x <- archivos_txt[t]
  y <- archivos_txt_utf8[t]
  system(paste("iconv -t UTF-8//TRANSLIT", x, "-o", y))
}

lapply(seq_along(archivos_txt), arreglar_encoding)

contenido <- map(archivos_txt_utf8, read_lines, locale = locale(encoding = "UTF-8", asciify = TRUE))
contenido <- map(contenido, function (x) { paste(x, collapse = "\n") })

discursos <- tibble(
  fecha = as.Date(archivos_txt %>% str_replace_all("archivos_txt/", "") %>% str_replace_all("\\.txt", ""), "%Y%m%d"),
  presidente = NA,
  contenido = contenido
) %>%
  unnest(contenido)

saveRDS(discursos, file = "discursos.rds")
