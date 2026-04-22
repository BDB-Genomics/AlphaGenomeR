.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Welcome to AlphaGenomeR!\n",
    "If you use this package in your research, please cite it:\n",
    "  citation(\"AlphaGenomeR\")\n",
    "This helps support the ongoing development of the package."
  )
}
