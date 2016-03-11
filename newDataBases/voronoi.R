library(sp)
library(deldir)
library(GISTools)
library(rgdal)
library(RPostgreSQL)



SPointsDF_to_voronoi_SPolysDF <- function(sp) {
  
  # tile.list extracts the polygon data from the deldir computation
  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))
  
  lapply(1:(length(vor_desc)), function(i) {
    
    # tile.list gets us the points for the polygons but we
    # still have to close them, hence the need for the rbind
    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
    tmp <- rbind(tmp, tmp[1,])
    
    # now we can make the Polygon(s)
    Polygons(list(Polygon(tmp)), ID=i)
    
  }) -> vor_polygons
  
  # hopefully the caller passed in good metadata!
  sp_dat <- sp@data
  
  # this way the IDs _should_ match up w/the data & voronoi polys
  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons),
                                  'polygons'),
                             slot, 'ID')
  
  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
                           data=sp_dat)
  
}



#vor_pts <- SpatialPointsDataFrame(cbind(airports$longitude,
#                                        airports$latitude),
#                                  airports, match.ID=TRUE)

#vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)

#writeOGR(obj=vor, dsn="/Users/saultoscano/Documents", layer="vor", driver="ESRI Shapefile") 

con = dbConnect(dbDriver("PostgreSQL"), dbname = "nyc-taxi-data", host = "localhost")
query = function(sql) { fetch(dbSendQuery(con, sql), n = 1e8) }


points = query("SELECT longitude, latitude FROM stations")
