# Load options ------------------------------------------------------------

.onLoad <- function(libname, pkgname)
{
    op <- options()
    op.r.iwrt <- list(
        tobii.interpolation.window = 30,
        tobii.interpolation.method = c("linear", "spline"),
        tobii.filter.width = 0.99, # gaussian interval of 99%
        tobii.filter.window = 11, # gaussian within 92ms at 120hz
        tobii.coord.xrange = c(0,1),
        tobii.coord.yrange = c(0,1),
        tobii.col.left.validity = "left_validity",
        tobii.col.right.validity = "right_validity",
        tobii.col.left.xaxis = "left_gaze_acs_x",
        tobii.col.right.xaxis = "right_gaze_acs_x",
        tobii.col.left.yaxis = "left_gaze_acs_y",
        tobii.col.right.yaxis = "right_gaze_acs_y",
        # must be in this exact order left, top, right, bottom
        roi.list = list(roi_left=c("imgLx0", "imgLy0", "imgLx1", "imgLy1"),
                         roi_right= c("imgRx0", "imgRy0", "imgRx1", "imgRy1")),
        roi.adj = 1 # roi multiplier
        )
    toset <- !(names(op.r.iwrt) %in% names(op))
    if(any(toset)) options(op.r.iwrt[toset])
    return(invisible())
}
