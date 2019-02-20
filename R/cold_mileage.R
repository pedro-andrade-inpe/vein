#' Fraction of mileage driven with a cold engine or catalizer below normal temperature
#'
#' This function depends length of trip and on ambient temperature.
#' From the guidelines  EMEP/EEA air pollutant emission inventory guidebook
#' http://www.eea.europa.eu/themes/air/emep-eea-air-pollutant-emission-inventory-guidebook
#'
#' @param ltrip Numeric; Length of trip.
#' @param ta Numeric; average monthly temperature
#' @keywords cold mileage
#' @note This function is set so that values vaires between 0 and 1.
#' @export
#' @examples {
#' cold_mileage(10, 0)
#' a <-sapply(1:50, function(i){cold_mileage(0:40, (1:50)[i])})
#' filled.contour(a, col = cptcity::cpt(2860))
#' }
cold_mileage <- function(ltrip, ta){
ifelse(
  0.6474 - 0.02545 * ltrip - (0.00974 - 0.000385 * ltrip) * ta < 0, 0,
       ifelse(
         0.6474 - 0.02545 * ltrip - (0.00974 - 0.000385 * ltrip) * ta > 1, 1,
         0.6474 - 0.02545 * ltrip - (0.00974 - 0.000385 * ltrip) * ta))

}