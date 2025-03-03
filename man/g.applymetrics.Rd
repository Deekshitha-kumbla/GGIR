\name{g.applymetrics}
\alias{g.applymetrics}
\title{
  Extract metrics from acceleration signals
}
\description{
  Function to extract metrics from acceleration signal. Not intended
  for direct use by user
}
\usage{
  g.applymetrics(data, sf, ws3, metrics2do,
                          n = 4, lb = 0.2, hb = 15,
                          zc.lb = 0.25, zc.hb = 3, 
                          zc.sb = 0.01, zc.order = 2,
                          actilife_LFE = FALSE)
}
\arguments{
  \item{data}{
    Three column matrix with x, y, and z acceleration data
  }
  \item{n}{
    filter order, see \link{GGIR} for details
  }
  \item{sf}{
     sample frequency
  }
   \item{ws3}{
     Epoch size in seconds
  }
  \item{metrics2do}{
    Dataframe with Boolean indicator for all metrics whether
    they should be extracted or not. For instance,
    metrics2do$do.bfen = TRUE, indicates that the bfen metric
    should be extracted
  }
  \item{lb}{
    Lower boundery of cut-off frequencies, see \link{GGIR}.
  }
  \item{hb}{
    Higher boundery of cut-off frequencies, see \link{GGIR}.
  }
  \item{zc.lb}{
    See \link{GGIR}
  }
  \item{zc.hb}{
    See \link{GGIR}
  }
  \item{zc.sb}{
    See \link{GGIR}
  }
  \item{zc.order}{
    See \link{GGIR}
  }
  \item{actilife_LFE}{
    See \link{GGIR}
  }
}
\value{
  Dataframe with metric values in columns average per epoch (ws3)
}

\examples{
  Gx = runif(n=10000,min=0,max=2)
  Gy = runif(n=10000,min=1,max=3)
  Gz = runif(n=10000,min=0,max=2)
  data = cbind(Gx, Gy, Gz)
  metrics2do = data.frame(do.bfen=TRUE,do.enmo=TRUE,do.lfenmo=FALSE,
  do.en=FALSE,do.hfen=FALSE,do.hfenplus=FALSE,do.mad=FALSE,do.anglex=FALSE,
  do.angley=FALSE,do.anglez=FALSE,do.roll_med_acc_x=FALSE,
  do.roll_med_acc_y=FALSE,do.roll_med_acc_z=FALSE,
  do.dev_roll_med_acc_x=FALSE,do.dev_roll_med_acc_y=FALSE,
  do.dev_roll_med_acc_z=FALSE,do.enmoa=FALSE,
  do.lfx=FALSE, do.lfy=FALSE, do.lfz=FALSE, 
  do.hfx=FALSE, do.hfy=FALSE, do.hfz=FALSE, 
  do.bfx=FALSE, do.bfy=FALSE, do.bfz=FALSE,
  do.zcx=FALSE, do.zcy=FALSE, do.zcz=FALSE, 
  do.brondcounts=FALSE, do.neishabouricounts=FALSE)
  
  extractedmetrics = g.applymetrics(data,n=4,sf=40,ws3=5,metrics2do)
}

\author{
  Vincent T van Hees <v.vanhees@accelting.com>
}
