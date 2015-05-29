# Tobii data processing functions -----------------------------------------

tracking_invalid <- function(x,v,value)
{# v=trackdat$left.validity; x=trackdat$left.x; value=NA
    x[v == 4] <- value
    return(x)
}

tracking_out_of_range <- function(x,r,value)
{# x = trackdat$left.x; r=c(0,1); value=NA
    x[x < r[1] | x > r[2]] <- value
    return(x)
}

tracking_filter <- function(x, k, width)
{# x = trackdat$left.x; k=7; width=0.99
    l <- length(x)
    if (k >= l) stop(simpleError("filter: k larger than length of x"))
    if (k < 3) stop(simpleError("filter: k value must be at least 3"))
    if (k %% 2 != 1) stop(simpleError("filter: k must be odd"))
    if (width < 0 | width > 1) stop(simpleError("filter: width out of range"))
    
    q <- qnorm((1-width)/2)
    d <- dnorm(seq(-q, q, length.out=k))
    w <- d / sum(d)

    pad_len <- floor(k / 2)
    finite_vals <- is.finite(x)
    x[!finite_vals] <- NA
    first_real <- mean(x[finite_vals][1:pad_len], na.rm=TRUE)
    last_real <- mean(rev(x[finite_vals])[1:pad_len], na.rm=TRUE)
    y <- c(rep(first_real, pad_len), x, rep(last_real, pad_len))
    
    for (i in (pad_len+1):(length(y)-pad_len)) {
        v <- y[(i-pad_len):(i+pad_len)]
        nas <- is.na(v)
        if (any(nas)) {
            if (nas[pad_len+1]) {
                y[i] <- NA
            } else {
                y[i] <- sum(v[!nas] * (w[!nas] / sum(w[!nas])))  
            }
        } else {
            y[i] <- sum(v * w)
        }
    }
    
    y <- y[(pad_len+1):(length(y)-pad_len)]
    #y <- as.numeric(filter(x, w, "convolution"))
    
    return(y)
}

linear_fill <- function(pts, xout)
{
    out_idx <- which(xout)
    len_out <- length(out_idx)
    in_l <- out_idx[1]-1
    in_r <- len_out + in_l + 1
    out_vals <- seq(pts[in_l], pts[in_r], length.out=len_out+2)
    return(list(x=out_idx, y=out_vals[2:(length(out_vals)-1)]))
}

tracking_interpolation <- function(x, k, splines=FALSE, plotfill=FALSE)
{# x <- out_coord; k=30; splines=FALSE; plotfill=FALSE
    
    if (plotfill) {
        s <- seq_len(length(x))
        plot(s, x, type="l", xlab="sample", ylab="px_coord")
        old_nas <- is.na(x)
    }
    
    # mark where NAs are found
    get_na <- ifelse(is.na(x), 1, 0)
    count_fixable <- unlist(lapply(rle(get_na)$lengths, function(i) {
        if (i > k) {
            l <- rep(0, i)
        } else {
            l <- seq_len(i)
        }
        return(l)
    })) * get_na
    
    # find range where to fill NAs
    patch_idx <- which(count_fixable == 1)
    patch_idx <- patch_idx[patch_idx != 1]
    
    if (length(patch_idx) == 0) {
        return(x)
    }
    
    if (length(patch_idx) > 1) {
        patch_rng <- matrix(c(patch_idx, 
                              c(patch_idx[2:length(patch_idx)]-1, length(x))
        ), ncol=2)
    } else { # only one NA found
        patch_rng <- matrix(c(patch_idx, length(x)), ncol=2)
    }
    
    for (r in 1:nrow(patch_rng)) {
        # get current range and their values
        i <- patch_rng[r, ]

        left_rng <- max(c(1, i[1]-k)):max(c(1, i[1]-1))
        right_rng <- i[1]:(i[2])
        left_pts <- x[left_rng]
        
        # find last set of good values to use
        get_na <- ifelse(is.na(left_pts), 0, 1)
        left_len <- rle(get_na)
        last_good_exists <- left_len$values == 1
        
        if (last_good_exists[length(last_good_exists)]) {# last real values
            
            len_size <- length(last_good_exists)
            
            if (len_size == 1) {# all values are good
                junk_len <- 0
            } else {# some NAs and some good at the end
                junk_len <- sum(unlist(left_len$lengths[1:(len_size-1)]))
            }
            
            # indices of last good set of values
            good_rng <- seq_len(left_len$lengths[len_size])+junk_len
            
            # map to original x indices
            left_x_good_rng <- left_rng[good_rng]
            
            # right side should have real values in order to fill gap
            right_rle <- rle(ifelse(is.na(x[right_rng]), 0, 1))
            
            if (any(right_rle$values == 1)) {
                good_right_sum <- sum(right_rle$lengths[1:2]) # right cutoffs
                eval_rng <- c(left_x_good_rng, right_rng[1:good_right_sum])
                eval_pts <- x[eval_rng]
                interp_pts <- is.na(eval_pts)
                
                # select which method to use based on R options
                if (splines) {
                    est_pts <- spline(eval_pts, 
                                      xout=which(interp_pts),
                                      method="natural", ties=mean)
                    
                } else {
                    est_pts <- linear_fill(eval_pts, interp_pts)
                }
                
                # overwrite original vector
                x[eval_rng[interp_pts]] <- est_pts$y
                
                # show fill lines as red
                if (plotfill) {
                    lines(s[eval_rng[interp_pts]], 
                          x[eval_rng[interp_pts]], 
                          cex=0.75, col="red")
                }
            }
        }
    }
    return(x)
}

#' Process tracking data
#' 
#' A series of operations to filter and processing eye tracking data
#' 
#' Must use \code{options} to set parameters for how to process the data. This
#'   function is used automatically by the main function \code{\link{iwrt_auto}}. 
#'
#' @param in_dat    data.table with necessary tracking columns. Will attempt to find
#'   them from the package options in \code{options()}
#' @param which_axis    character string indicating which axis to process. Can be one 
#'   of \code{c("x","y","horz","vert")}
#'
#' @return Numeric vector of eyetracker coordinates for one of the specified axes
#' @export
#'
#' @examples
#' tracking_process(my_raw_data, "x")
tracking_process <- function(in_dat, which_axis)
{# in_dat=dat[id==3 & trial == 5,]; which_axis = "y"
    
    # print(in_dat[,imgStart[1]])
    if (missing(which_axis)) stop(simpleError("Need tracking axis character"))
    if (tolower(which_axis) %in% c("x", "horz", "horizontal")) {
        axis_names <- c("tobii.col.left.xaxis", "tobii.col.right.xaxis")
        axis_rng <- getOption("tobii.coord.xrange")
    } else if (tolower(which_axis) %in% c("y", "vert", "vertical")) {
        axis_names <- c("tobii.col.left.yaxis", "tobii.col.right.yaxis")
        axis_rng <- getOption("tobii.coord.yrange")
    } else {
        stop(simpleError("Wrong tracking axis character entered."))
    }
    
    op_names <- c("tobii.col.left.validity",
                  "tobii.col.right.validity",
                  axis_names)
    
    op_vals <- sapply(op_names, getOption)
    
    if (any(is.na(names(op_vals)))) {
        stop(simpleError(
            "Missing important option: tracking column names in options()"
        ))
    }
    
    if (any(!op_vals %in% names(in_dat))) {
        stop(simpleError(
            "Names for tracking cols in options() don't match column names in data"
            ))
    }
    
    if (!any(class(in_dat) %in% "data.table")) in_dat <- as.data.table(in_dat)
    
    trackdat <- copy(in_dat[, .SD, .SDcols=op_vals])
    op_names <- sub(".xaxis", ".coord", op_names)
    op_names <- sub(".yaxis", ".coord", op_names)
    setnames(trackdat, names(trackdat), sub("tobii.col.", "", op_names))

    k_interpol <- getOption("tobii.interpolation.window")
    k_filter <- getOption("tobii.filter.window")
    width_filter <- getOption("tobii.filter.width")
    
    use_splines <- switch(getOption("tobii.interpolation.method")[1],
                              "linear" = FALSE,
                              "splines" = TRUE,
                              "line" = FALSE,
                              "spline" = TRUE,
                              "l" = FALSE,
                              "s" = TRUE,
    )
    
    if (is.na(use_splines)) {
        stop(simpleError("Wrong interpolation method option"))
    }
    
    # remove bad values based on validity codes
    trackdat[, right.coord := tracking_invalid(right.coord,right.validity,NA)]
    trackdat[, left.coord := tracking_invalid(left.coord,left.validity,NA)]
    
    # remove out of range
    trackdat[, right.coord := tracking_out_of_range(right.coord,axis_rng,NA)]
    trackdat[, left.coord := tracking_out_of_range(left.coord,axis_rng,NA)]
    
    # merge eyes
    out_coord <- trackdat[, rowMeans(.SD, na.rm=TRUE), 
             .SDcols=c("left.coord", "right.coord")]
    out_coord[is.nan(out_coord)] <- NA
    
    # 1st pass forward interpolation
    out_coord <- tracking_interpolation(out_coord, k_interpol, use_splines)
    
    # remove out of range due to interpolation method
    out_coord <- tracking_out_of_range(out_coord, axis_rng, NA)
    
    # 2nd pass backward interpolation
    out_coord <- tracking_interpolation(rev(out_coord), k_interpol, use_splines)
    
    # remove out of range due to interpolation method
    out_coord <- tracking_out_of_range(rev(out_coord), axis_rng, NA)
    
    # filter data
    out_coord <- tracking_filter(out_coord, k_filter, width_filter)
    
    return(out_coord)
}

region_dwell_time <- function(timestamps, in_region)
{
    if (length(timestamps) == 0 | length(in_region) == 0) {
        out_vals <- data.table(time_segment=NA, in_roi=NA, roi_dwell_time=NA,
                               roi_onset=NA, roi_offset=NA, tracking_time=NA)
        out_vals <- out_vals[, lapply(.SD, as.numeric)]
        return(out_vals)
    }
    if (length(timestamps) != length(in_region)) {
        stop(simpleError("timestamps and fixations lengths differ"))
    }
    in_region[is.na(in_region)] <- -1
    if (any(!unique(in_region) %in% c(-1,0,1))) {
        stop(simpleError("fixation vector must be 0's and 1's or NA"))
    }
    
    t <- timestamps[order(timestamps)]
    f <- in_region[order(timestamps)]
    fix_len <- rle(f)
    
    iter <- 1
    time_segment <- c()
    for (i in fix_len$lengths) {
        time_segment <- c(time_segment, rep(iter, i))
        iter <- iter + 1
    }
    
    d <- data.table(time_segment, ts=t, in_roi=f)
    
    out_vals <- d[, list(roi_dwell_time = diff(range(ts)) / 1000,
                         roi_onset=min(ts)/1000,
                         roi_offset=max(ts)/1000), 
                  by=list(time_segment, in_roi)]
    out_vals[in_roi == -1, in_roi := NA]
    out_vals[, tracking_time := diff(range(t)) / 1000]
    out_vals <- out_vals[, lapply(.SD, as.numeric)]
    
    return(out_vals) # returns data.table
}
