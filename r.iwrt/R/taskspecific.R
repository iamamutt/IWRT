
.matlab_data <- function() {
    library(data.table)
    normalizePath("../data")
}

#' Find task data files
#' 
#' Helper function to find a list of IWRT file names given a specific root folder.
#' 
#' @param root_path Path of the root folder to start search.
#' @return Character vector of path names.
#' @examples
#' find_task_data('../data')
#' find_task_data('path/to/data/folder')
#' @export
find_task_data <- function(root_path) {
    csv_files <- list.files(path = root_path, 
                            pattern = "_data\\.csv$", 
                            recursive = TRUE, 
                            include.dirs = TRUE)
    csv_files <- csv_files[grepl("Infant_WRT_", csv_files)]
    fpaths <- normalizePath(file.path(normalizePath(root_path), csv_files))
    return(fpaths)
}

#' Import IWRT Task Data into R
#' 
#' Imports the MATLAB task data into R from a folder or vector of filenames. 
#' 
#' This function should be used if you only want the task data in raw format.
#' Use the function \code{\link{iwrt_auto}} to do a complete import and data processing.
#' 
#' @param root_path Main path to folder where all the individual subject folders are contained.
#' @param file_paths A character vector that lists specific file names to import. 
#'   The function \code{\link{find_task_data}} may be used to find exact file names.
#' @return Will return a data.table containing the task data. Set \code{datatable=FALSE} to return a data.frame instead.
#' @examples
#' # import all data found in the upper level folder 'data'
#' import_tasks_data('../data')
#' 
#' # import data from specific files, use the default data.frame instead of data.table
#' import_task_data(file_paths=c('file1.csv', 'file2.csv'), datatable=FALSE)
#' @export
import_task_data <- function(root_path, file_paths, datatable = TRUE) {
    empty_folder <- missing(root_path)
    empty_files <- missing(file_paths)
    
    if (empty_folder & empty_files) {
        stop(simpleError("Must supply folder path or vector of file names to import"))
    } else if (!empty_folder & !empty_files) {
        message("Used both root_path and file_paths arguments. Using only file_paths.")
    } else if (!empty_folder & empty_files) {
        file_paths <- find_task_data(root_path)
    }
    
    dat <- lapply(file_paths, function(x) {
        y <- data.table::fread(x, integer64 = "numeric")
        y <- cbind(data.table::data.table(file_task = tools::file_path_sans_ext(basename(x))), y)
    })
    
    dat <- do.call(rbind, dat)
    dat_classes <- sapply(dat, class)
    dat_ints <- names(dat_classes)[dat_classes %in% c("integer", "integer64")]
    dat[, `:=`(eval(dat_ints), lapply(.SD, as.numeric)), .SDcols = dat_ints]
    dat[, `:=`(tobiiOnset, tobiiOnset/1e+06)]
    dat[, date := as.POSIXct(date, format="%d-%b-%Y %H:%M:%S")]
    
    if (!datatable) {
        return(as.data.frame(dat))
    } else {
        return(dat)
    }
}

#' Find tracking data files
#' 
#' Helper function to find a list of IWRT file names given a specific root folder.
#' 
#' If the root folder is provided this will find each of the separate .csv
#' files regarding the eye tracking data that exist for each trial 
#' and for each participant. 
#' 
#' @param root_path Path of the root folder to start search.
#' @return Character vector of path names.
#' @examples
#' find_tracking_data('../data')
#' find_tracking_data('path/to/data/folder')
#' @export
find_tracking_data <- function(root_path) {
    csv_files <- list.files(path = root_path, pattern = "\\.csv$", recursive = TRUE, include.dirs = TRUE)
    csv_files <- csv_files[grepl("_eyeData_", csv_files)]
    fpaths <- normalizePath(file.path(normalizePath(root_path), csv_files))
    return(fpaths)
}

#' Import IWRT Tracking Data into R
#' 
#' Imports the MATLAB tracking data into R from a folder or vector of filenames. 
#' 
#' This function should be used if you only want the tracking data in raw format.
#' Use the function \code{\link{iwrt_auto}} to do a complete import and data processing.
#' 
#' @param root_path Main path to folder where all the individual subject folders are contained.
#' @param file_paths A character vector that lists specific file names to import. 
#'   The function \code{\link{find_tracking_data}} may be used to find exact file names.
#' @return Will return a data.table containing the tracking data. Set \code{datatable=FALSE} to return a data.frame instead.
#' @examples
#' # import all data found in the upper level folder 'data'
#' import_tracking_data('../data')
#' 
#' # import data from specific files, use the default data.frame instead of data.table
#' import_tracking_data(file_paths=c('file1.csv', 'file2.csv'), datatable=FALSE)
#' @export
import_tracking_data <- function(root_path, file_paths, datatable = TRUE) {
    empty_folder <- missing(root_path)
    empty_files <- missing(file_paths)
    
    if (empty_folder & empty_files) {
        stop(simpleError("Must supply folder path or vector of file names to import"))
    } else if (!empty_folder & !empty_files) {
        message("Used both root_path and file_paths arguments. Using only file_paths.")
    } else if (!empty_folder & empty_files) {
        file_paths <- find_tracking_data(root_path)
    }
    
    dat <- lapply(file_paths, function(x) {
        y <- data.table::fread(x, integer64 = "numeric")
        fname <- tools::file_path_sans_ext(basename(x))
        fstr <- strsplit(fname, "_")[[1]]
        
        y <- cbind(data.table::data.table(file_track = fname, 
                                          id = as.numeric(fstr[3]), 
                                          name = fstr[4], 
                                          trial = as.numeric(fstr[6])), y)
    })
    
    dat <- do.call(rbind, dat)
    
    if (!datatable) {
        return(as.data.frame(dat))
    } else {
        return(dat)
    }
}

iwrt_merge <- function(task, tracking) {
    dat <- merge(task, tracking, by = c("name", "id", "trial"))
    dat <- dat[order(id, name, date, tet_musec)]

    return(dat)
}

#' Import raw data
#' 
#' Imports raw data with no processing and all columns from task and tracking
#' 
#' This is to get both tracking and task data merged as one complete set without 
#' doing any further processing of the data. Use \code{\link{iwrt_auto}} for
#' an automatic method for import and processing of ROI's and tracking columns.
#' 
#' @param root_path Character string of path to the root folder where
#'   data subfolders are contained
#' @return Returns a data.table of merged task and tracking data
#' @examples
#' iwrt_import_raw("../data")
#' @export
iwrt_import_raw <- function(root_path)
{
    message("\nImporting IWRT task data...")
    task <- import_task_data(root_path)
    message("\nImporting IWRT tracking data...")
    tracking <- import_tracking_data(root_path)
    dat <- iwrt_merge(task, tracking)
    return(dat)
}

iwrt_time_clean <- function(dat)
{
    message("\nRemoving timestamps outside of trial duration...")
    dat[, t_elapsed := (tet_musec-min(tet_musec_onset)) / 1000, 
        by=list(id, name, date, trial)]
    dat <- dat[t_elapsed >= 0, ]
    rm_out_ts <- dat[, tet_musec <= max(tet_musec_onset), 
                     by=list(id, name, date, trial)][, V1]
    dat <- dat[rm_out_ts==TRUE, ]
    return(dat)
}

#' ROI classification
#' 
#' Classifies ROIs based on coordinates
#'
#' Must use \code{options()} to set the column names of your ROIs. Defaults to
#'   left and right image locations. xname and yname are eyegaze positions.
#' 
#' @param dat data.table with the ROI column and their normalized coordinates
#' @param xname normalized coordinate for the x axis of the eye gaze position
#' @param yname normalized coordinate for the y axis of the eye gaze position
#'
#' @return Same data.table but we new columns added for each ROI
iwrt_roi <- function(dat, xname, yname)
{# xname="por_x"; yname="por_y"
    # TODO:
    # check if cols exist
    # check if data.table
    
    message("\nProcessing ROI's...") 
    adj <- getOption("roi.adj")
    roi <- getOption("roi.list")
    
    roi_cat <- lapply(roi, function(x) {
        dsub <- dat[, c(xname, yname, x), with=FALSE]
        setnames(dsub, names(dsub), c("x", "y", "l", "t", "r", "b"))
        dsub[, `:=` (l = l * 1/adj,
                     t = t * 1/adj,
                     r = r * adj,
                     b = b * adj)]
        dsub[, V1 := 0]
        dsub[x > l & y > t & x < r & y < b, V1 := 1]
        dsub[is.na(x) | is.na(y), V1 := NA]
        return(dsub[, V1])
    })
    
    out_roi_cat <- as.data.table(do.call(cbind, roi_cat))
    
    return(cbind(dat, out_roi_cat))
}

iwrt_roi_duration <- function(in_dat)
{# in_dat <- dat[order(tet_musec)]
    
    message("\nComputing ROI summary...") 
    roi <- getOption("roi.list")
    
    # tet_musec and ptb_musec_onset must exist
    looking_duration <- function(f,t1,t2,ts,pts) {
        # x=in_dat[id==3 & trial == 28, ]
        # t1=x$imgStart; t2=x$audioStart; ts=x$tet_musec; pts=x$ptb_musec_onset; f=x$roi_left
        idx <- pts > min(t1) & pts <= max(t2)
        # timestamps=ts[idx]; fixations=f[idx]
        fix_dat <- region_dwell_time(ts[idx], f[idx])
    }
    
    out_list <- lapply(names(roi), function(x) {
        in_dat[, roi_x := in_dat[[x]]]
        in_dat[, `:=` (pre_audio_duration=(audioStart-imgStart)/1000, 
                       post_audio_duration=(imgEnd-audioStart)/1000)]
        
        before_aud <- in_dat[order(tet_musec), 
                             looking_duration(roi_x,
                                              imgStart,
                                              audioStart,
                                              tet_musec,
                                              ptb_musec_onset),
                             by=list(id, age, name, date, trial, 
                                     new, left, right, word,
                                     pre_audio_duration)]
        
        after_aud <- in_dat[order(tet_musec), 
                            looking_duration(roi_x,
                                             audioStart,
                                             imgEnd,
                                             tet_musec,
                                             ptb_musec_onset),
                            by=list(id, age, name, date, trial,
                                    new, left, right, word,
                                    post_audio_duration)]
        
        setnames(before_aud, "pre_audio_duration", "phase_duration")
        setnames(after_aud, "post_audio_duration", "phase_duration")
        before_aud[, trial_phase := "pre_audio"]
        after_aud[, trial_phase := "post_audio"]
        y <- rbind(before_aud, after_aud)
        y[, roi := x]
        return(y)
    })
    
    out_dat <- do.call(rbind, out_list)
    out_dat <- out_dat[in_roi == 1 | is.na(in_roi), ]
    out_dat[is.na(in_roi), `:=` (roi = NA, time_segment = NA)]
    out_dat[, in_roi := NULL]
    out_dat <- unique(out_dat)
    out_dat <- out_dat[order(name, id, date, roi_onset, trial)]
    out_dat[order(name, id, date, roi_onset), 
            time_segment := as.numeric(seq_len(length(time_segment))), 
            by=list(name, id, date, trial, trial_phase)]
    
}

#' Automatic IWRT data import and processing
#' 
#' Will automatically import and processes data given root path
#' 
#' Must specify package \code{options()} if different from defaults
#' 
#' @param root_path Character string of main path to folder where all the 
#'   individual subject folders are contained.
#' @examples
#' # Only need to specify the root folder where data is contained
#' data_list <- iwrt_auto("../data")
#' 
#' # Extract specific datasets from the list
#' roi_data <- data_list$roi
#' all_data <- data_list$complete
#' @return List of data.tables
#' @export
iwrt_auto <- function(root_path)
{# root_path <- .matlab_data()
    dat <- iwrt_import_raw(root_path)
    message(paste("\nProcessing x tracking data..."))
    dat[, por_x := tracking_process(.SD, "x"), by=list(name, id, date, trial)]
    message(paste("\nProcessing y tracking data..."))
    dat[, por_y := tracking_process(.SD, "y"), by=list(name, id, date, trial)]
    dat <- iwrt_time_clean(dat)
    dat <- iwrt_roi(dat, "por_x", "por_y")
    dat_roi <- iwrt_roi_duration(dat)
    message("\nCompleted auto import!")
    out_list <- list(complete=dat,roi=dat_roi)
    return(out_list)
}
