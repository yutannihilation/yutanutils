#' Variants Of 'geom_sf()'
#'
#' @name geom_sf_label
NULL

#' @rdname geom_sf_label
#' @importFrom ggplot2 stat
#' @inheritParams ggplot2::geom_label
#' @export
StatSfCoordinates <- ggplot2::ggproto(
  "StatSfCoordinates", ggplot2::Stat,
  compute_group = function(data, scales, fun.geometry) {
    points_sfc <- fun.geometry(data$geometry)
    coordinates <- sf::st_coordinates(points_sfc)
    data <- cbind(data, coordinates)

    data
  },

  default_aes = ggplot2::aes(x = stat(X), y = stat(Y)),
  required_aes = c("geometry")
)

geom_sf_label_variants <- function(mapping = NULL,
                                   data = NULL,
                                   fun.geometry,
                                   geom_fun,
                                   ...) {
  if (is.null(mapping$geometry)) {
    geometry_col <- attr(data, "sf_column") %||% "geometry"
    mapping$geometry <- as.name(geometry_col)
  }

  geom_fun(
    mapping = mapping,
    data = data,
    stat = StatSfCoordinates,
    fun.geometry = fun.geometry,
    ...
  )
}

#' @name geom_sf_label
#' @export
geom_sf_label <- function(mapping = NULL,
                          data = NULL,
                          fun.geometry = sf::st_point_on_surface,
                          ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggplot2::geom_label
  )
}

#' @name geom_sf_label
#' @export
geom_sf_label_repel <- function(mapping = NULL,
                                data = NULL,
                                fun.geometry = sf::st_point_on_surface,
                                ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggrepel::geom_label_repel
  )
}
