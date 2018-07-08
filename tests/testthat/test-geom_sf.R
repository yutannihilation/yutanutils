context("test-geom_sf.R")

library(ggplot2)

nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
polygon_sf <- head(nc, 3)

suppressWarnings(
  polygon_centroids_sfc <- sf::st_point_on_surface(polygon_sf$geometry)
)
labels_df <- as.data.frame(sf::st_coordinates(polygon_centroids_sfc))
labels_df$NAME <- polygon_sf$NAME

test_that("geom_sf_label() works", {
  p <- ggplot(polygon_sf) +
    geom_sf(aes(fill = AREA))

  p1 <- p + geom_label(data = labels_df, aes(X, Y, label = NAME))
  p2 <- p + geom_sf_label(aes(label = NAME))

  suppressWarnings({
    # ensure both results are expected
    vdiffr::expect_doppelganger("geom_sf_label()", p1)
    vdiffr::expect_doppelganger("geom_sf_label()", p2)
  })

  p3 <- p + ggrepel::geom_label_repel(data = labels_df, aes(X, Y, label = NAME), seed = 10)
  p4 <- p + geom_sf_label_repel(aes(label = NAME), seed = 10)

  # TODO: geom_label_repel()s
  # suppressWarnings({
  #   # ensure both results are expected
  #   vdiffr::expect_doppelganger("geom_sf_label_repel()", p3)
  #   vdiffr::expect_doppelganger("geom_sf_label_repel()", p4)
  # })
})
