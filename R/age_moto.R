#' Returns amount of vehicles at each age
#'
#' @description \code{\link{age_moto}} returns amount of vehicles at each age
#'
#' @param x Numeric; numerical vector of vehicles with length equal to lines features of road network
#' @param name Character; of vehicle assigned to columns of dataframe
#' @param a Numeric; parameter of survival equation
#' @param b Numeric; parameter of survival equation
#' @param agemin Integer; age of newest vehicles for that category
#' @param agemax Integer; age of oldest vehicles for that category
#' @param k Numeric; multiplication factor. If its length is > 1, it must match the length of x
#' @param bystreet Logical; when TRUE it is expecting that 'a' and 'b' are numeric vectors with length equal to x
#' @param net SpatialLinesDataFrame or Spatial Feature of "LINESTRING"
#' @param verbose Logical;  message with average age and total numer of vehicles
#' @param namerows Any vector to be change row.names. For instance, name of
#' regions or streets.
#' @return dataframe of age distrubution of vehicles
#' @importFrom sf st_sf st_as_sf
#' @export
#' @examples {
#' data(net)
#' MOTO_E25_500 <- age_moto(x = net$ldv, name = "M_E25_500", k = 0.4)
#' plot(MOTO_E25_500)
#' MOTO_E25_500 <- age_moto(x = net$ldv, name = "M_E25_500", k = 0.4, net = net)
#' plot(MOTO_E25_500)
#' }
age_moto <- function (x,
                      name = "age",
                      a = 0.2,
                      b = 17,
                      agemin = 1,
                      agemax = 50,
                      k = 1,
                      bystreet = FALSE,
                      net,
                      verbose = FALSE,
                      namerows){
  #check agemax
  if(agemax < 1) stop("Agemax should be bigger than 1")

  if (missing(x) | is.null(x)) {
    stop (print("Missing vehicles"))
  }
  # bystreet = TRUE
  if (bystreet == T){
    if(length(x) != length(a)){
      stop(print("Lengths of veh and age must be the same"))
    }
    d <- suca <- list()
    for (i in seq_along(x)) {
      suca[[i]] <- function (t) {1/(1 + exp(a[i]*(t+b[i])))+1/(1 + exp(a[i]*(t-b[i])))}
      anos <- seq(agemin,agemax)
      d[[i]] <- (-1)*diff(suca[[i]](anos))
      d[[i]][length(d[[i]])+1] <- d[[i]][length(d[[i]])]
      d[[i]] <- d[[i]] + (1 - sum(d[[i]]))/length(d[[i]])
      d[[i]] <- d[[i]]*x[i]
    }
    df <- as.data.frame(matrix(0,ncol=length(anos), nrow=1))


    for (i in seq_along(x)) {
      df[i,] <- d[[i]]
    }

    df <- as.data.frame(cbind(as.data.frame(matrix(0,ncol=agemin-1,
                                                   nrow=length(x))), df))

    names(df) <- paste(name, seq(1, agemax), sep="_")


    if(length(k) > 1){
      df <- vein::matvect(df = df, x = k)
    } else {
      df <- df*k
    }


    if(verbose){

      message(paste("Average age of",name, "is",
                    round(sum(seq(1,agemax)*base::colSums(df, na.rm = T)/sum(df, na.rm = T)), 2),
                    sep=" "))
      message(paste("Number of",name, "is",
                    round(sum(df, na.rm = T)/1000, 2),
                    "* 10^3 veh",
                    sep=" ")
      )
      cat("\n")
    }


    df <- Vehicles(df)
    if(!missing(namerows)) {
      if(length(namerows) != nrow(df)) stop("length of namerows must be the length of number of rows of veh")
      row.names(df) <- namerows
    }

    if(!missing(net)){
      netsf <- sf::st_as_sf(net)
      dfsf <- sf::st_sf(df, geometry = netsf$geometry)
      return(dfsf)
    } else {

      return(Vehicles(df))
    }

  } else {
    suca <- function (t) {1/(1 + exp(a*(t+b)))+1/(1 + exp(a*(t-b)))}
    anos <- seq(agemin,agemax)
    d <- (-1)*diff(suca(anos))
    d[length(d)+1] <- d[length(d)]
    d <- d + (1 - sum(d))/length(d)
    df <- as.data.frame(as.matrix(x) %*%matrix(d,ncol=length(anos), nrow=1))

    df <- as.data.frame(cbind(as.data.frame(matrix(0,ncol=agemin-1,
                                                   nrow=length(x))),
                              df))

    names(df) <- paste(name,seq(1,agemax),sep="_")

    if(length(k) > 1){
      df <- vein::matvect(df = df, x = k)
    } else {
      df <- df*k
    }



    if(verbose){
      message(paste("Average age of",name, "is",
                    round(sum(seq(1,agemax)*base::colSums(df, na.rm = T)/sum(df, na.rm = T)), 2),
                    sep=" "))
      message(paste("Number of",name, "is",
                    round(sum(df, na.rm = T)/1000, 2),
                    "* 10^3 veh",
                    sep=" ")
      )
      cat("\n")
    }
    if(!missing(namerows)) {
      if(length(namerows) != nrow(df)) stop("length of namerows must be the length of number of rows of veh")
      row.names(df) <- namerows
    }

    if(!missing(net)){
      netsf <- sf::st_as_sf(net)
      dfsf <- sf::st_sf(Vehicles(df), geometry = netsf$geometry)
      return(dfsf)
    } else {
      return(Vehicles(df))
    }

  }
}
