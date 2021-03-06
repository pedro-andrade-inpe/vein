% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/emis_wrf.R
\name{emis_wrf-deprecated}
\alias{emis_wrf-deprecated}
\title{Generates emissions dataframe to generate WRF-Chem inputs}
\arguments{
\item{sdf}{Gridded emissions, which can be a SpatialPolygonsDataFrame, or a list
of SpatialPolygonsDataFrame, or a sf object of "POLYGON". The user must enter
a list with 36 SpatialPolygonsDataFrame with emissions for the mechanism CBMZ.}

\item{nr}{Number of repetitions of the emissions period}

\item{dmyhm}{String indicating Day Month Year Hour and Minute in the format
"d-m-Y H:M" e.g.: "01-05-2014 00:00" It represents the time of the first
hour of emissions in Local Time}

\item{tz}{Time zone as required in for function \code{\link{as.POSIXct}}}

\item{crs}{Coordinate reference system, e.g: "+init=epsg:4326". Used to
transform the coordinates of the output}

\item{utc}{ignored.}

\item{islist}{logical value to indicate if sdf is a list or not}
}
\description{
\code{emis_wrf} returns a dataframes with columns lat, long, id, pollutants, local time
and GMT time. This dataframe has the proper format to be used with WRF
assimilation system: "ASimilation System 4 WRF (AS4WRF Vera-Vala et al (2016))
}
\seealso{
\code{\link{vein-deprecated}}
}
\keyword{internal}
