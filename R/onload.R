
.onAttach <- function(lib, pkg) {
  packageStartupMessage("This is perucenso package ",
                        utils::packageDescription("perucenso",
                                                  fields = "Version"
                        ),
                        appendLF = TRUE
  )
}


# -------------------------------------------------------------------------

show_progress <- function() {
  isTRUE(getOption("perucenso.show_progress")) && interactive()
}



.onLoad <- function(libname, pkgname) {
  opt <- options()
  opt_perucenso <- list(
    perucenso.show_progress = TRUE
  )
  to_set <- !(names(opt_perucenso) %in% names(opt))
  if (any(to_set)) options(opt_perucenso[to_set])
  invisible()
}


# -------------------------------------------------------------------------
