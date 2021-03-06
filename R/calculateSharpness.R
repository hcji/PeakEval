#' Calculate Sharpness (of a Chromatographic Peak)
#'
#' Calculate Sharpness of the integrated region of a chromatographic peak. The Sharpness is found by determining the sum of the
#' difference between the intensities of each adjacent pair of points on the peak normalized by the intensity of the peak boundaries.
#'
#' This function repurposed from Zhang et al. For details, see Zhang, W., & Zhao, P. X. (2014). Quality evaluation of extracted
#' ion chromatograms and chromatographic peaks in liquid chromatography/mass spectrometry-based metabolomics data. BMC Bioinformatics,
#' 15(Suppl 11), S5. https://doi.org/10.1186/1471-2105-15-S11-S5
#'
#' @param peakData A vector containing characteristic information about a chromatographic peak - including the retention time range
#' @param pts A 2D matrix containing the retention time and intensity values of a chromatographic peak
#' @return The Sharpness value (double)
#'
#' @examples
#' # Calculate Sharpness for a peak
#' data(ex_pts)
#' data(ex_peakData)
#' sharpness <- calculateSharpness(peakData = ex_peakData, pts = ex_pts)
#'
#' @export

calculateSharpness <- function(pts, rtmin, rtmax){
  peakrange <- c(rtmin, rtmax)
  ptsidx <- pts[, 1] >= peakrange[1] & pts[, 1] <= peakrange[2]
  intPts <- pts[ptsidx, ]

  if(length(intPts)>2){
    peak_intensity <- intPts[,2]
    num_pk_pts <- length(peak_intensity)

    sharpness = 0
    apex_intensity <- max(peak_intensity)
    apex_index <- which(peak_intensity == apex_intensity)
    if(length(apex_index) > 1){
      apex_index <- apex_index[1]
    }

    if(num_pk_pts > 1){
      for(i in 1:num_pk_pts){
        if(i < apex_index){
          sharpness = sharpness + (peak_intensity[i+1]-peak_intensity[i])/max(0.0001, peak_intensity[i])
        }else if(i < num_pk_pts){
          sharpness = sharpness + (peak_intensity[i]-peak_intensity[i+1])/max(0.0001, peak_intensity[i+1])
        }
      }
    }
  }else{
    sharpness <- NA
  }

  return(sharpness)

}
