context("sf")

points_sfc <- sf::st_sfc(
  sf::st_point(c(1, 1)),
  sf::st_point(c(2, 2))
)

points_sf <- sf::st_sf(
  value = c(10, 20),
  geometry = points_sfc
)

test_that("st_add_point_coordinates() works", {
  expect_equal(st_add_point_coordinates(points_sf),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         X = 1:2, Y = 1:2))
  expect_equal(st_add_point_coordinates(points_sf, col_names = c("x", "y")),
               sf::st_sf(value = c(10, 20), geometry = points_sfc,
                         x = 1:2, y = 1:2))
})
